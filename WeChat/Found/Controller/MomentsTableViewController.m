//
//  MomentsTableViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/21.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "CoverHeaderView.h"
#import "MJRefresh/MJRefresh/Custom/Footer/Auto/MJRefreshAutoNormalFooter.h"
#import "Masonry/Masonry/Masonry.h"
#import "Moment.h"
#import "MomentsDataSource.h"
#import "MomentsTableViewController.h"
#import "SpinningLoadingView.h"

@interface
MomentsTableViewController ()
@property (strong, nonatomic) CoverHeaderView* coverView;
@property (assign, nonatomic) float contentInsetY;

@property (strong, nonatomic) MomentsDataSource* datasource;
@property (strong, nonatomic) NSMutableArray<Moment*>* momentsArray;
@end

@implementation MomentsTableViewController
- (NSMutableArray<Moment*>*)momentsArray
{
    if (_momentsArray == nil) {
        _momentsArray = [NSMutableArray array];
    }
    return _momentsArray;
}
- (MomentsDataSource*)datasource
{
    static MomentsDataSource* datasource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      datasource = [[MomentsDataSource alloc] init];
    });

    return datasource;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentInsetY = -150;

    [self buildTableview];
    [self bindConstraints];
    [self loadData:true];
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
          dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
          dispatch_get_main_queue(), ^{
            [self loadData:true];
            [self.tableView.mj_header endRefreshing];
          });
      }];
    loadingView.ignoredScrollViewContentInsetTop = self.contentInsetY;
    self.tableView.mj_header = loadingView;

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
      dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
        ^{
          [self loadData:false];
          [self.tableView.mj_footer endRefreshing];
        });
    }];
}
- (void)bindConstraints
{
    [self.coverView mas_makeConstraints:^(MASConstraintMaker* make) {
      make.right.left.top.offset(0);
      make.width.equalTo(self.tableView.mas_width);
      make.height.equalTo(self.tableView.mas_width).offset(30);
    }];
}

- (void)loadData:(BOOL)isInitial
{
    if (isInitial) [self.momentsArray removeAllObjects];

    NSArray* datas = [self.datasource moments];
    [self.momentsArray addObjectsFromArray:datas];

    if (isInitial)
        [self.tableView reloadData];
    else {
        NSMutableArray* indexPaths = [NSMutableArray array];
        for (NSUInteger i = 0; i < datas.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }

        [UIView setAnimationsEnabled:false];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [UIView setAnimationsEnabled:true];
    }

    /*
	 tableview.header默认是在tableview.tableHeaerView后面的
	 而且每次更新表格后都会重置这个顺序，所以每次刷新都要执行一次这个方法
	 */
    [self.tableView bringSubviewToFront:self.tableView.mj_header];
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
    return self.momentsArray.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell =
      [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:@"ss"];
    cell.textLabel.text = self.momentsArray[indexPath.row].content;
    return cell;
}
#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    //  NSLog(@"%f", scrollView.contentOffset.y);
}
@end
