//
//  ChatViewController.m
//  WeChat
//
//  Created by Siegrain on 16/3/28.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ChatViewController.h"
#import "UIImage+RandomImage.h"

@interface
ChatViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, copy) NSArray* dataArr;
@end

@implementation ChatViewController

- (void)viewDidLoad
{
  [self initializeData];
  [self buildTableView];
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
  _tableView = ({
    UITableView* tableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                               self.view.frame.size.height - 44)
              style:UITableViewStyleGrouped];

    tableView.delegate = self;
    tableView.dataSource = self;

    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    tableView;
  });

  [self.view addSubview:_tableView];
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
  UITableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:identifier];

    cell.preservesSuperviewLayoutMargins = false;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsMake(5, 0, 5, 0);
  }

  return cell;
}

- (void)tableView:(UITableView*)tableView
  willDisplayCell:(UITableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath
{
  UIImage* icon = [UIImage randromImageInPath:@"Images/cell_icons"];
  CGSize size = CGSizeMake(36, 36);
  UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
  CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
  [icon drawInRect:imageRect];

  cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  cell.textLabel.text = self.dataArr[indexPath.row][0];
  cell.detailTextLabel.text = self.dataArr[indexPath.row][1];
}

- (CGFloat)tableView:(UITableView*)tableView
  heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 44;
}
@end
