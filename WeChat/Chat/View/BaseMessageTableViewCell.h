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
@class InsetsTextField;

@interface BaseMessageTableViewCell : UITableViewCell {
@protected
  UIImageView* bubbleView;
  UIImageView* avatarImageView;
  InsetsTextField* sendTimeField;
}
@property (assign, nonatomic) MessageAlignement alignement;
@property (strong, nonatomic) ChatModel* model;
@end
