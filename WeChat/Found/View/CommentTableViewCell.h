//
//  CommentTableViewCell.h
//  WeChat
//
//  Created by Siegrain on 16/4/25.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) Comment* model;
@end
