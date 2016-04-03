//
//  ChatViewController.m
//  WeChat
//
//  Created by Siegrain on 16/3/28.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ChatViewController.h"
#import "ContactsTableViewCell.h"
#import "UIImage+RandomImage.h"

@interface
ChatViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, copy) NSArray* dataArr;
@end

@implementation ChatViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initializeData];
  [self buildTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}
- (void)initializeData
{
  self.dataArr = @[
    @[ @"吴正祥", @"Github: https://github.com/Seanwong933" ],
    @[ @"陈维", @"博客地址: http://siegrain.wang" ],
    @[ @"赖杰", @"[语音]" ],
    @[ @"范熙丹", @"[链接]红包话语飘落的季节。饿了么送你外卖红包~" ],
    @[
      @"丁亮",
      @"皇室战争50元红包来洗！登录就送！不信你不来！..."
    ],
    @[ @"赵雨彤",
       @"您已添加了Darui Li，现在可以开始聊天了。" ],
    @[ @"落落",
       @"刚翻到了之前给肉团儿拍的小时候皂片！！！" ],
    @[ @"Leo琦仔", @"Leo琦仔 领取了您的红包" ],
    @[ @"廖宇超", @"[动画表情]" ],
    @[ @"Darui Li",
       @"关于刘亦菲美貌的8歌秘密，你知道几个？" ],
    @[ @"刘洋", @"逼乎日报" ]
  ];
}
- (void)buildTableView
{
  // tableviewstyle为groupped的话，会有莫名其妙的contentInsets出现
  self.tableView = [[UITableView alloc]
    initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                             self.view.frame.size.height)
            style:UITableViewStylePlain];

  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

  [self.view addSubview:self.tableView];
}
#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  static NSString* identifier = @"chatCellIdentifier";
  ContactsTableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];

  if (cell == nil) {
    cell =
      [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier];

    cell.preservesSuperviewLayoutMargins = false;
    cell.separatorInset = UIEdgeInsetsMake(5, 0, 0, 0);
    cell.layoutMargins = UIEdgeInsetsZero;
  }

  return cell;
}

- (void)tableView:(UITableView*)tableView
  willDisplayCell:(ContactsTableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath
{
  cell.style = ContactsTableViewCellStyleSubtitle;
  cell.avatar = [UIImage randomImageInPath:@"Images/cell_icons"];
  cell.name = self.dataArr[indexPath.row][0];
  cell.descriptionText = self.dataArr[indexPath.row][1];
}

- (CGFloat)tableView:(UITableView*)tableView
  heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 60;
}
@end
