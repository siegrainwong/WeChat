//
//  ChatroomViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/3.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ChatModel.h"
#import "ChatroomViewController.h"
#import "EditorView.h"
#import "Masonry/Masonry/Masonry.h"
#import "TextMessageTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell/Classes/UITableView+FDTemplateLayoutCell.h"

static NSString* const kCellIdentifier = @"ChatroomIdentifier";
static NSInteger const kEditorHeight = 50;

@interface
ChatroomViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) EditorView* editorView;
@property (assign, nonatomic) NSUInteger rowCount;

@property (assign, nonatomic) NSInteger contentOffsetYFarFromBottom;
@end

@implementation ChatroomViewController
#pragma mark - accessors
- (NSUInteger)rowCount
{
  if (_rowCount == 0) {
    _rowCount = 10;
  }
  return _rowCount;
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

  [self.tableView setContentOffset:CGPointMake(0, MAXFLOAT)];
}
#pragma mark - build
- (void)buildView
{
  self.navigationItem.title = self.barTitle;

  [self buildTableView];
  [self buildEditorView];

  [self bindConstraints];
  [self bindGestureRecognizer];
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
  self.tableView.fd_debugLogEnabled = true;

  [self.tableView registerClass:[TextMessageTableViewCell class]
         forCellReuseIdentifier:kCellIdentifier];
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

      //若要在修改约束的同时进行动画的话，需要调用其父视图的layoutIfNeeded方法，并在动画中再调用一次！
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
      NSIndexPath* insertion =
        [NSIndexPath indexPathForRow:self.rowCount inSection:0];
      [self.tableView beginUpdates];
      [self.tableView insertRowsAtIndexPaths:@[ insertion ]
                            withRowAnimation:UITableViewRowAnimationTop];
      self.rowCount++;
      [self.tableView endUpdates];
      [self.tableView scrollToRowAtIndexPath:insertion
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:true];
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
  float height = [self.tableView
    fd_heightForCellWithIdentifier:kCellIdentifier
                  cacheByIndexPath:indexPath
                     configuration:^(TextMessageTableViewCell* cell) {
                       cell.model = [self testModel:indexPath];
                     }];
  return height <= 10 ? 100 : height;
}
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return self.rowCount;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  TextMessageTableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                    forIndexPath:indexPath];
  if (cell == nil) {
    cell = [[TextMessageTableViewCell alloc]
        initWithStyle:UITableViewCellStyleDefault
      reuseIdentifier:kCellIdentifier];
  }

  return cell;
}
- (void)tableView:(UITableView*)tableView
  willDisplayCell:(TextMessageTableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath
{
  cell.model = [self testModel:indexPath];
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
  [self.tableView
    scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.rowCount - 1
                                              inSection:0]
          atScrollPosition:UITableViewScrollPositionBottom
                  animated:animated];
}
- (ChatModel*)testModel:(NSIndexPath*)indexPath
{
  ChatModel* model = [[ChatModel alloc] init];
  model.messageType = ChatMessageTypeText;
  model.identifier = indexPath.row;
  model.sendTime = model.identifier % 2 == 0 ? [NSDate date] : nil;
  model.name = model.identifier % 2 == 0 ? @"Siegrain" : @"Turning robot";
  model.message = model.identifier % 2 == 0
                    ? @"锄禾日当午，汗滴禾下土。"
                      @"\n谁知盘中餐，粒粒皆辛苦。"
                    : @"《静夜思》"
                      @"\n\t李白"
                      @"\n床前明月光，疑是地上霜。"
                      @"\n举头望明月，低头思故乡。";

  //  NSLog(@"喜怒无常的表格：%ld - %@", indexPath.row, model.sendTime);
  return model;
}
@end
