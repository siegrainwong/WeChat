//
//  BaseMessageTableViewCell.h
//  WeChat
//
//  Created by Siegrain on 16/4/7.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MessageAlignement) {
  MessageAlignementUndefined,
  MessageAlignementLeft,
  MessageAlignementRight
};

@class ChatModel;

@interface BaseMessageTableViewCell : UITableViewCell
@property (assign, nonatomic) MessageAlignement alignement;
@property (strong, nonatomic) ChatModel* model;

@property (strong, nonatomic) UIImageView* bubbleView;

- (void)buildCell;
- (void)bindConstraints;

- (void)longPressOnBubble:(UILongPressGestureRecognizer*)press;
@end
