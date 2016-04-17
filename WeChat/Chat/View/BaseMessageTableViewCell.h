//
//  BaseMessageTableViewCell.h
//  WeChat
//
//  Created by Siegrain on 16/4/7.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 在从重用池出列时，修改的数据会作用到其他具有相同标识的待重用列上，所以需要用到两个标识避免数据错误
 */
static NSString* const kCellIdentifierLeft = @"ChatroomIdentifierLeft";
static NSString* const kCellIdentifierRight = @"ChatroomIdentifierRight";

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
