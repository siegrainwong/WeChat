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
#import "MomentTableViewCell.h"
#import "MomentsDataSource.h"
#import "MomentsTableViewController.h"
#import "SpinningLoadingView.h"
#import "UIImage+RandomImage.h"
#import "UITableView+FDTemplateLayoutCell/Classes/UITableView+FDTemplateLayoutCell.h"

static NSString* const kIdentifier = @"Identifier0";
static NSString* const kIdentifierOnePicRow = @"Identifier1";
static NSString* const kIdentifierTwoPicRow = @"Identifier2";
static NSString* const kIdentifierThreePicRow = @"Identifier3";

static NSUInteger const kCoverViewHeight = 450;

@interface
MomentsTableViewController ()
@property (strong, nonatomic) CoverHeaderView* coverView;
@property (assign, nonatomic) float contentInsetY;

@property (strong, nonatomic) MomentsDataSource* datasource;
@property (strong, nonatomic) NSMutableArray<Moment*>* momentsArray;

@property (nonatomic, strong) MomentTableViewCell* prototypeCell;
@end

@implementation MomentsTableViewController
#pragma mark - accessors
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
#pragma mark - init
/*
 Mark: 
 tableView似乎只认tableHeaderView的frame，不认约束，所以要在这里用systemLayoutSizeFittingSize算出约束高度后再重新赋值给tableHeaderView
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    CoverHeaderView* headerView = (CoverHeaderView*)self.tableView.tableHeaderView;

    /*
	 黑历史：systemLayoutSizeFittingSize算出来有700多，没办法只有设成死值了
	 实际原因是因为我没有给coverView添加Bottom约束，所以算出来的值不对
	 */
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;

    self.tableView.tableHeaderView = headerView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentInsetY = -150;

    [self buildTableview];
    [self loadData:true];
    [self bindConstraints];
}
- (void)buildTableview
{
    [self.tableView registerClass:[MomentTableViewCell class] forCellReuseIdentifier:kIdentifier];
    [self.tableView registerClass:[MomentTableViewCell class] forCellReuseIdentifier:kIdentifierOnePicRow];
    [self.tableView registerClass:[MomentTableViewCell class] forCellReuseIdentifier:kIdentifierTwoPicRow];
    [self.tableView registerClass:[MomentTableViewCell class] forCellReuseIdentifier:kIdentifierThreePicRow];

    self.tableView.contentInset = UIEdgeInsetsMake(self.contentInsetY, 0, 0, 0);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    //cover
    self.coverView = [CoverHeaderView
      coverHeaderWithCover:[UIImage imageNamed:@"cover"]
                    avatar:[UIImage imageNamed:@"siegrain_avatar"]
                      name:@"Siegrain Wong"];
    self.tableView.tableHeaderView = self.coverView;

    //pull-down refresh
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

    //pull-up refresh
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
        make.width.equalTo(self.view);
        make.height.offset(kCoverViewHeight);
        make.bottom.offset(-10);
    }];
}

- (void)loadData:(BOOL)isInitial
{
    if (isInitial) [self.momentsArray removeAllObjects];

    NSArray* datas = [self.datasource moments];
    [self.momentsArray addObjectsFromArray:datas];

    [self.tableView reloadData];

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
- (CGFloat)tableView:(UITableView*)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView*)tableView
  heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 传统算高。。。
    //    static MomentTableViewCell* templateCell;
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        templateCell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    //    });
    //
    //    [self configureCell:templateCell atIndexPath:indexPath];
    //
    //    //    [templateCell.contentView setNeedsLayout];
    //    //    [templateCell.contentView layoutIfNeeded];

    Moment* model = self.momentsArray[indexPath.row];
    if (model.height <= 0) {
        // 根据当前数据，计算Cell的高度，注意+1
        //                model.height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        model.height = [tableView
          fd_heightForCellWithIdentifier:[self cellIdentifier:indexPath]
                           configuration:^(id cell) {
                               [self configureCell:cell atIndexPath:indexPath];
                           }];
    }

    return model.height;
}
- (NSInteger)tableView:(UITableView*)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return self.momentsArray.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    MomentTableViewCell* cell = [tableView
      dequeueReusableCellWithIdentifier:[self cellIdentifier:indexPath]
                           forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(MomentTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Moment* model = self.momentsArray[indexPath.row];
    if (!model.avatar)
        model.avatar = [UIImage randomImageInPath:@"Images/cell_icons"];

    model.indexPath = indexPath;

    [cell setModel:model];
}
#pragma mark -
- (NSString*)cellIdentifier:(NSIndexPath*)indexPath
{
    Moment* model = self.momentsArray[indexPath.row];
    int rowCount = ceilf(model.pictures.count / 3.0);
    return [NSString stringWithFormat:@"Identifier%d", rowCount];
}
@end
