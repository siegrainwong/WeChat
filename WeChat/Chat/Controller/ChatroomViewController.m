//
//  ChatroomViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/3.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Message.h"
#import "ChatroomViewController.h"
#import "EditorView.h"
#import "Masonry/Masonry/Masonry.h"
#import "TRRTuringRequestManager.h"
#import "TextMessageTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell/Classes/UITableView+FDTemplateLayoutCell.h"

static NSString* const kTuringAPIKey = @"7b698d636ca822b96f78a2fcef16a47f";
static NSInteger const kEditorHeight = 50;

@interface
ChatroomViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) EditorView* editorView;

@property (assign, nonatomic) NSInteger contentOffsetYFarFromBottom;

@property (strong, nonatomic) TRRTuringAPIConfig* apiConfig;
@property (strong, nonatomic) TRRTuringRequestManager* apiRequest;

@property (strong, nonatomic) NSMutableArray<ChatModel*>* chatModelArray;
@end

@implementation ChatroomViewController
#pragma mark - accessors
- (NSString*)chatroomIdentifier:(NSIndexPath*)indexPath
{
  return self.chatModelArray[indexPath.row].sender == 1 ? kCellIdentifierRight
                                                        : kCellIdentifierLeft;
}
- (NSMutableArray<ChatModel*>*)chatModelArray
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

      __block ChatModel* robotModel =
        [ChatModel chatModelWithId:2
                            sender:2
                          sendTime:nil
                           message:nil
                       messageType:ChatMessageTypeText];
      [weakSelf.apiConfig request_UserIDwithSuccessBlock:^(NSString* str) {
        [weakSelf.apiRequest request_OpenAPIWithInfo:message
          successBlock:^(NSDictionary* dict) {
            robotModel.message = dict[@"text"];
            robotModel.sendTime = [NSDate date];
            [weakSelf.chatModelArray addObject:robotModel];

            [self updateNewOneRowInTableview];
          }
          failBlock:^(TRRAPIErrorType errorType, NSString* infoStr) {
            robotModel.message = infoStr;
            robotModel.sendTime = [NSDate date];

            [weakSelf.chatModelArray addObject:robotModel];
            [self updateNewOneRowInTableview];
          }];
      }
        failBlock:^(TRRAPIErrorType errorType, NSString* infoStr) {
          robotModel.message = infoStr;
          robotModel.sendTime = [NSDate date];

          [weakSelf.chatModelArray addObject:robotModel];

          [self updateNewOneRowInTableview];
        }];

      ChatModel* meModel = [ChatModel chatModelWithId:1
                                               sender:1
                                             sendTime:[NSDate date]
                                              message:message
                                          messageType:ChatMessageTypeText];
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
  Message* model = self.chatModelArray[indexPath.row];
  CGFloat height = model.height.floatValue;

  if (!height) {
    height = [self.tableView
      fd_heightForCellWithIdentifier:[self chatroomIdentifier:indexPath]
                    cacheByIndexPath:indexPath
                       configuration:^(TextMessageTableViewCell* cell) {
                         cell.model = model;
                       }];

    model.height = @(height);
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
  Message* model = self.chatModelArray[indexPath.row];
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
@end
