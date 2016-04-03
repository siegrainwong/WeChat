//
//  ChatroomViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/3.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ChatroomViewController.h"
#import "EditorView.h"
#import "Masonry/Masonry/Masonry.h"

static NSInteger const kEditorHeight = 50;

@interface
ChatroomViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) EditorView* editorView;
@end

@implementation ChatroomViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self buildTableView];
  [self buildEditorView];

  [self bindConstraints];
  [self bindGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - build
- (void)buildTableView
{
  self.tableView = [[UITableView alloc] init];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
}
- (void)buildEditorView
{
  self.editorView = [EditorView editor];
  [self.view addSubview:self.editorView];

  __weak typeof(self) weakSelf = self;
  __block NSUInteger keyboardHeight = 0;
  [weakSelf.editorView
    setKeyboardWasShown:^(NSInteger animCurveKey, CGFloat duration,
                          CGSize keyboardSize) {
      keyboardHeight = keyboardSize.height;
      //若要在修改约束的同时进行动画的话，需要调用其父视图的layoutIfNeeded方法，并在动画中再调用一次！
      [weakSelf.view layoutIfNeeded];
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
                         CGPoint contentOffset =
                           CGPointMake(weakSelf.tableView.contentOffset.x,
                                       weakSelf.tableView.contentOffset.y +
                                         keyboardSize.height);
                         weakSelf.tableView.contentOffset = contentOffset;
                         [weakSelf.view layoutIfNeeded];
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
                         CGPoint contentOffset = CGPointMake(
                           weakSelf.tableView.contentOffset.x,
                           weakSelf.tableView.contentOffset.y - keyboardHeight);
                         weakSelf.tableView.contentOffset = contentOffset;
                         [weakSelf.view layoutIfNeeded];
                       }
                       completion:nil];
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
  heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 50;
}
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return 15;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  static NSString* identifier = @"ChatroomIdentifier";
  UITableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:identifier];
  }
  return cell;
}
- (void)tableView:(UITableView*)tableView
  willDisplayCell:(UITableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath
{
  cell.textLabel.text = [NSString
    stringWithFormat:@"Cell：%ld - %ld", indexPath.section, indexPath.row];
  ;
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
@end
