//
//  ChatroomTableViewCell.h
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatModel;

@interface ChatroomTableViewCell : UITableViewCell
+ (instancetype)chatCellWithModel:(ChatModel*)model;

@property (strong, nonatomic) ChatModel* model;
@end
