//
//  CommentTableViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/25.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentTableViewController.h"
#import "MomentsDataSource.h"
#import "UITableView+FDTemplateLayoutCell/Classes/UITableView+FDTemplateLayoutCell.h"

static NSString* const kIdentifier = @"commentIdentifier";

@interface
CommentTableViewController ()
@property (strong, nonatomic) MomentsDataSource* dataSource;
@end

@implementation CommentTableViewController
#pragma mark - accessors
- (MomentsDataSource*)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[MomentsDataSource alloc] init];
    }
    return _dataSource;
}
#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.scrollEnabled = false;
        self.tableView.showsHorizontalScrollIndicator = false;
        self.tableView.showsVerticalScrollIndicator = false;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:kIdentifier];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setComments:(NSArray*)comments
{
    _comments = comments;

    [self.tableView reloadData];
}
#pragma mark - tableview
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kIdentifier
                                       configuration:^(id cell) {
                                           [self configureCell:cell atIndexPath:indexPath];
                                       }];
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(CommentTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    NSString* data = self.comments[indexPath.row];
    [cell cellDataWithName:[self.dataSource randomName] andContent:data];
}
@end
