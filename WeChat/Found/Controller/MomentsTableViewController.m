//
//  MomentsTableViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/21.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "CoverHeaderView.h"
#import "Masonry/Masonry/Masonry.h"
#import "MomentsTableViewController.h"
#import "SpinningLoadingView.h"

@interface
MomentsTableViewController ()
@property (strong, nonatomic) CoverHeaderView* coverView;
@property (assign, nonatomic) float contentInsetY;
@end

@implementation MomentsTableViewController
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.contentInsetY = -150;

  [self buildTableview];
  [self bindConstraints];
}
- (void)buildTableview
{
  self.coverView = [CoverHeaderView
    coverHeaderWithCover:[UIImage imageNamed:@"cover"]
                  avatar:[UIImage imageNamed:@"siegrain_avatar"]
                    name:@"Siegrain Wong"];
  self.tableView.contentInset = UIEdgeInsetsMake(self.contentInsetY, 0, 0, 0);
  self.tableView.tableHeaderView = self.coverView;

  SpinningLoadingView* loadingView =
    [SpinningLoadingView headerWithRefreshingBlock:^{
      dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          //          self.tableView.contentOffset = CGPointMake(0, -124);
          //          [UIView animateWithDuration:0.5
          //                           animations:^{
          //                             self.tableView.contentOffset =
          //                             CGPointMake(0, 86);
          //                           }];
          [self.tableView.mj_header endRefreshing];
        });
    }];
  loadingView.ignoredScrollViewContentInsetTop = self.contentInsetY;
  self.tableView.mj_header = loadingView;

  // tableview.header默认是在tableview.tableHeaerView后面的
  [self.tableView bringSubviewToFront:self.tableView.mj_header];
}
- (void)bindConstraints
{
  [self.coverView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.right.left.top.offset(0);
    make.height.width.equalTo(self.tableView.mas_width);
  }];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
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
  return 50;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  UITableViewCell* cell =
    [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:@"ss"];
  cell.textLabel.text = @"尼玛。。。。";
  return cell;
}
#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
  NSLog(@"%f", scrollView.contentOffset.y);
}
@end
