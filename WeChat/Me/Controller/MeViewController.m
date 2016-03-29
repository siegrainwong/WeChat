//
//  MeViewController.m
//  WeChat
//
//  Created by Siegrain on 16/3/28.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "MeTableViewCell.h"
#import "MeViewController.h"
#import "PersonModel.h"

@interface
MeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;

//名字数组
@property (nonatomic, copy) NSArray* dataArr;

//图片数组
@property (nonatomic, copy) NSArray* imgArr;
@end

@implementation MeViewController
- (void)viewDidLoad
{
  [self initializeData];
  [self buildTableView];
}

- (void)initializeData
{
  PersonModel* model = [[PersonModel alloc] init];
  model.avatar = @"siegrain_avatar";
  model.name = @"Siegrain";
  model.wechatId = @"euphoria33";

  _dataArr = @[
    @[ model ],
    @[ @"相册", @"收藏", @"钱包", @"卡包" ],
    @[ @"表情" ],
    @[ @"设置" ]
  ];

  _imgArr = @[
    @[ @"" ],
    @[
      @"ff_IconShowAlbum",
      @"MoreMyFavorites",
      @"MoreMyBankCard",
      @"MyCardPackageIcon"
    ],
    @[ @"MoreExpressionShops" ],
    @[ @"MoreSetting" ]
  ];
}
- (void)buildTableView
{
  _tableView = ({
    UITableView* tableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                               self.view.frame.size.height - 44)
              style:UITableViewStyleGrouped];

    tableView.delegate = self;
    tableView.dataSource = self;

    //调整两个cell之间的分割线的长度
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    tableView;
  });

  [self.view addSubview:_tableView];
}
#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
  return _dataArr.count;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
  NSArray* rowArr = _dataArr[section];
  return rowArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  static NSString* identifier = @"meCellIdentifier";
  UITableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];

  if (cell == nil) {
    if (indexPath.section == 0) {
      cell = [[MeTableViewCell alloc] init];
    } else {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  }

  return cell;
}

- (void)tableView:(UITableView*)tableView
  willDisplayCell:(UITableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath
{
  if (indexPath.section == 0) {
    MeTableViewCell* meCell = (MeTableViewCell*)cell;
    meCell.model = _dataArr[indexPath.section][indexPath.row];
  } else {
    cell.imageView.image =
      [UIImage imageNamed:_imgArr[indexPath.section][indexPath.row]];
    cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];
  }
}

- (CGFloat)tableView:(UITableView*)tableView
  heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  if (indexPath.section == 0)
    return 90;

  return 44;
}

//设置头视图高度
- (CGFloat)tableView:(UITableView*)tableView
  heightForHeaderInSection:(NSInteger)section
{
  if (section == 0)
    return 15;

  return 5;
}

@end
