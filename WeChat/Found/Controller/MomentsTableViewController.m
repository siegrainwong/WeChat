//
//  MomentsTableViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/21.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "MomentsTableViewController.h"
#import "SpinningLoadingView.h"

@interface
MomentsTableViewController ()

@end

@implementation MomentsTableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.tableView.mj_header = [SpinningLoadingView headerWithRefreshingBlock:^{

  }];
  UIView* view = [[UIView alloc] init];
  view.backgroundColor = [UIColor redColor];
  view.frame = CGRectMake(0, -50, self.tableView.bounds.size.width, 50);
  [self.tableView.mj_header addSubview:view];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
  return 0;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

@end
