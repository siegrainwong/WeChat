//
//  ChatroomViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/3.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "AppDelegate.h"
#import "ChatroomViewController.h"
#import "EditorView.h"
#import "MJRefresh/MJRefresh/MJRefresh.h"
#import "Masonry/Masonry/Masonry.h"
#import "Messages.h"
#import "TRRTuringRequestManager.h"
#import "TextMessageTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell/Classes/UITableView+FDTemplateLayoutCell.h"
#import "WeChat.h"

static NSString* const kTuringAPIKey = @"7b698d636ca822b96f78a2fcef16a47f";
static NSInteger const kEditorHeight = 50;
static NSUInteger const kShowSendTimeInterval = 60;
static NSUInteger const kFetchLimit = 15;

@interface
ChatroomViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) EditorView* editorView;

@property (assign, nonatomic) NSInteger contentOffsetYFarFromBottom;

@property (strong, nonatomic) TRRTuringAPIConfig* apiConfig;
@property (strong, nonatomic) TRRTuringRequestManager* apiRequest;

@property (strong, nonatomic) NSMutableArray<Messages*>* chatModelArray;

@property (strong, nonatomic) NSManagedObjectContext* context;

@property (assign, nonatomic) BOOL isLoading;
@end

@implementation ChatroomViewController
#pragma mark - accessors
- (NSManagedObjectContext*)context
{
  if (_context == nil) {
    _context = [[WeChat sharedManager] managedObjectContext];
  }
  return _context;
}
- (NSString*)chatroomIdentifier:(NSIndexPath*)indexPath
{
  return self.chatModelArray[indexPath.row].sender == 1 ? kCellIdentifierRight
                                                        : kCellIdentifierLeft;
}
- (NSMutableArray<Messages*>*)chatModelArray
{
  if (_chatModelArray == nil) {
    _chatModelArray = [NSMutableArray array];
  }
  return _chatModelArray;
}
+ (NSInteger)EditorHeight
{
  return kEditorHeight;
}
#pragma mark - init
- (void)viewDidLoad
{
  [super viewDidLoad];

  [self buildView];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  //滚不到最下面。。将就一下了只有。。。
  [self scrollToBottom:false];
}
#pragma mark - build
- (void)buildView
{
  self.navigationItem.title = self.barTitle;

  [self buildTableView];
  [self buildEditorView];

  [self bindConstraints];
  [self bindGestureRecognizer];
  [self setupTuringRobot];
}
- (void)setupTuringRobot
{
  self.apiConfig = [[TRRTuringAPIConfig alloc] initWithAPIKey:kTuringAPIKey];
  self.apiRequest =
    [[TRRTuringRequestManager alloc] initWithConfig:self.apiConfig];
}
- (void)buildTableView
{
  if (self.tableView != nil)
    return;

  self.tableView = [[UITableView alloc] init];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
  self.tableView.fd_debugLogEnabled = false;

  [self.tableView registerClass:[TextMessageTableViewCell class]
         forCellReuseIdentifier:kCellIdentifierLeft];
  [self.tableView registerClass:[TextMessageTableViewCell class]
         forCellReuseIdentifier:kCellIdentifierRight];

  [self.chatModelArray
    addObjectsFromArray:
      [[WeChat sharedManager]
        messagesBeforeTimeInterval:[NSDate timeIntervalSinceReferenceDate]
                        fetchLimit:kFetchLimit]];

  //下拉刷新控件
  MJRefreshNormalHeader* header =
    [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      [self updateHistoryDataInTableview];
    }];
  header.lastUpdatedTimeLabel.hidden = true;
  header.stateLabel.hidden = true;
  self.tableView.mj_header = header;

  [self.view addSubview:self.tableView];
}

- (void)buildEditorView
{
  if (self.editorView != nil)
    return;

  self.editorView = [EditorView editor];
  [self.view addSubview:self.editorView];

  __weak typeof(self) weakSelf = self;
  [weakSelf.editorView
    setKeyboardWasShown:^(NSInteger animCurveKey, CGFloat duration,
                          CGSize keyboardSize) {
      if (keyboardSize.height == 0)
        return;

      //若要在修改约束的同时进行动画的话，需要调用其父视图的layoutIfNeeded方法，并在动画中再调用一次
      [weakSelf.editorView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.bottom.offset(-keyboardSize.height);
      }];
      [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.bottom.offset(-keyboardSize.height - kEditorHeight);
      }];
      [UIView animateWithDuration:duration
                            delay:0
                          options:animCurveKey
                       animations:^{
                         [weakSelf.view layoutIfNeeded];

                         //滚动动画必须在约束动画之后执行，不然会被中断
                         [weakSelf scrollToBottom:true];
                       }
                       completion:nil];
    }];
  [weakSelf.editorView
    setKeyboardWillBeHidden:^(NSInteger animCurveKey, CGFloat duration,
                              CGSize keyboardSize) {
      [weakSelf.view layoutIfNeeded];
      [weakSelf.editorView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.bottom.offset(0);
      }];
      [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.bottom.offset(-kEditorHeight);
      }];
      [UIView animateWithDuration:duration
                            delay:0
                          options:animCurveKey
                       animations:^{
                         [weakSelf.view layoutIfNeeded];
                       }
                       completion:nil];
    }];
  [weakSelf.editorView
    setMessageWasSend:^(id message, ChatMessageType messageType) {

      __block Messages* robotModel = (Messages*)[NSEntityDescription
        insertNewObjectForEntityForName:kdb_Messages
                 inManagedObjectContext:self.context];
      robotModel.sender = 2;
      robotModel.messageType = ChatMessageTypeText;

      void (^justBlock)(NSDictionary*, TRRAPIErrorType, NSString*) =
        ^(NSDictionary* dict, TRRAPIErrorType errorType, NSString* infoStr) {
          robotModel.message = dict == nil ? infoStr : dict[@"text"];
          NSDate* date = [NSDate date];
          robotModel.sendTime = date.timeIntervalSinceReferenceDate;
          robotModel.showSendTime = [self needsShowSendTime:date];
          [[WeChat sharedManager] save];

          [weakSelf.chatModelArray addObject:robotModel];
          [self updateNewOneRowInTableview];
        };

      [weakSelf.apiConfig request_UserIDwithSuccessBlock:^(NSString* str) {
        [weakSelf.apiRequest request_OpenAPIWithInfo:message
          successBlock:^(NSDictionary* dict) {
            justBlock(dict, 0, nil);
          }
          failBlock:^(TRRAPIErrorType errorType, NSString* infoStr) {
            justBlock(nil, errorType, infoStr);
          }];
      }
        failBlock:^(TRRAPIErrorType errorType, NSString* infoStr) {
          justBlock(nil, errorType, infoStr);
        }];

      NSDate* date = [NSDate date];
      Messages* meModel = [[WeChat sharedManager] insertRecordInRecordTable:@{
        kdb_Messages_message : message,
        kdb_Messages_sender : @1,
        kdb_Messages_sendTime : date,
        kdb_Messages_showSendTime : @([self needsShowSendTime:date]),
        kdb_Messages_messageType : @(ChatMessageTypeText)
      }];

      [weakSelf.chatModelArray addObject:meModel];
      [self updateNewOneRowInTableview];
    }];
}
- (void)bindConstraints
{
  [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.top.left.right.offset(0);
    make.bottom.offset(-kEditorHeight);
  }];
  [self.editorView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.left.right.bottom.offset(0);
    make.height.offset(kEditorHeight);
  }];
}
- (void)bindGestureRecognizer
{
  UITapGestureRecognizer* singleTapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(endTextEditing)];
  singleTapGestureRecognizer.numberOfTapsRequired = 1;
  [self.tableView addGestureRecognizer:singleTapGestureRecognizer];
}
#pragma mark - tableview
- (CGFloat)tableView:(UITableView*)tableView
  estimatedHeightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView*)tableView
  heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  Messages* model = self.chatModelArray[indexPath.row];
  CGFloat height = model.height;

  if (!height) {
    height = [self.tableView
      fd_heightForCellWithIdentifier:[self chatroomIdentifier:indexPath]
                    cacheByIndexPath:indexPath
                       configuration:^(TextMessageTableViewCell* cell) {
                         cell.model = model;
                       }];

    model.height = height;
  }

  return height;
}
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return self.chatModelArray.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  TextMessageTableViewCell* cell = [tableView
    dequeueReusableCellWithIdentifier:[self chatroomIdentifier:indexPath]];

  [self configureCell:cell atIndexPath:indexPath];

  return cell;
}
- (void)configureCell:(BaseMessageTableViewCell*)cell
          atIndexPath:(NSIndexPath*)indexPath
{
  Messages* model = self.chatModelArray[indexPath.row];
  cell.model = model;
}
#pragma mark - scrollview
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
  [self endTextEditing];
}
#pragma mark -
- (void)endTextEditing
{
  [self.view endEditing:true];
}
- (void)scrollToBottom:(BOOL)animated
{
  if (self.chatModelArray.count == 0)
    return;

  [self.tableView
    scrollToRowAtIndexPath:[NSIndexPath
                             indexPathForRow:self.chatModelArray.count - 1
                                   inSection:0]
          atScrollPosition:UITableViewScrollPositionBottom
                  animated:animated];
}
- (BOOL)needsShowSendTime:(NSDate*)date
{
  NSTimeInterval lastRecordDatetimeInterval =
    self.chatModelArray.lastObject.sendTime;

  return date.timeIntervalSinceReferenceDate - lastRecordDatetimeInterval >=
         kShowSendTimeInterval;
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
  NSLog(@"%f", scrollView.contentOffset.y);
}
- (void)updateNewOneRowInTableview
{
  NSIndexPath* insertion =
    [NSIndexPath indexPathForRow:self.chatModelArray.count - 1 inSection:0];
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:@[ insertion ]
                        withRowAnimation:UITableViewRowAnimationNone];
  [self.tableView endUpdates];
  [self.tableView scrollToRowAtIndexPath:insertion
                        atScrollPosition:UITableViewScrollPositionBottom
                                animated:true];
}
- (void)updateHistoryDataInTableview
{
  if (self.isLoading)
    return;

  self.isLoading = true;

  //  for (Messages* msg in self.chatModelArray) {
  //    NSLog(@"%@", [NSDate
  //    dateWithTimeIntervalSinceReferenceDate:msg.sendTime]);
  //  }
  dispatch_after(
    dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
    dispatch_get_main_queue(), ^{
      NSArray* datas = [[WeChat sharedManager]
        messagesBeforeTimeInterval:self.chatModelArray.firstObject.sendTime
                        fetchLimit:kFetchLimit];
      [self.chatModelArray
        insertObjects:datas
            atIndexes:[NSIndexSet
                        indexSetWithIndexesInRange:NSMakeRange(0,
                                                               datas.count)]];
      NSMutableArray* indexPaths = [NSMutableArray array];
      for (NSUInteger i = 0; i < datas.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
      }

      /*
       Mark:
       使用beginUpdates更新的row就算指定了AnimationNone，也会有一个莫名其妙的SlideDown的动画
       必须全局禁止动画，更新后再恢复...蛇精病
       */
      //      CGFloat oldHeight = self.tableView.contentSize.height;
      CGFloat offsetY = self.tableView.contentOffset.y;
      //      NSLog(@"%f %f", oldHeight, offsetY);

      NSLog(@"%f %f", self.tableView.contentSize.height,
            self.tableView.contentOffset.y);
      [UIView setAnimationsEnabled:false];
      [self.tableView beginUpdates];
      [self.tableView insertRowsAtIndexPaths:indexPaths
                            withRowAnimation:UITableViewRowAnimationNone];
      [self.tableView endUpdates];
      [UIView setAnimationsEnabled:true];
      NSLog(@"%f %f", self.tableView.contentSize.height,
            self.tableView.contentOffset.y);

      //      CGFloat increasedHeight = self.tableView.contentSize.height -
      //      oldHeight;
      //      self.tableView.contentOffset = CGPointMake(0, offsetY +
      //      increasedHeight);
      //      NSLog(@"%f", offsetY + increasedHeight);

      //刷新结束后通知菊花停止转动
      [self.tableView.mj_header endRefreshing];
      self.isLoading = false;
    });
}
@end
