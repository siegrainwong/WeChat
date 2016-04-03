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

  __weak typeof(self.editorView) weakEditorView = self.editorView;
  [weakEditorView setKeyboardWasShown:^(NSInteger animCurveKey,
                                        CGFloat duration, CGSize keyboardSize) {

    //若要在修改约束的同时进行动画的话，需要调用其父视图的layoutIfNeeded方法，并在动画中再调用一次！
    [weakEditorView.superview layoutIfNeeded];
    [weakEditorView mas_updateConstraints:^(MASConstraintMaker* make) {
      make.bottom.offset(-keyboardSize.height);
    }];
    [UIView animateWithDuration:duration
                          delay:0
                        options:animCurveKey
                     animations:^{
                       [weakEditorView.superview layoutIfNeeded];
                     }
                     completion:nil];
  }];
  [weakEditorView
    setKeyboardWillBeHidden:^(NSInteger animCurveKey, CGFloat duration,
                              CGSize keyboardSize) {
      [weakEditorView.superview layoutIfNeeded];
      [weakEditorView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.bottom.offset(0);
      }];
      [UIView animateWithDuration:duration
                            delay:0
                          options:animCurveKey
                       animations:^{
                         [weakEditorView.superview layoutIfNeeded];
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
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return 0;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return [[UITableViewCell alloc] init];
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
