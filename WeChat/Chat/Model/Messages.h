//
//  ChatModel.h
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "EditorView.h"
#import "WechatConstants.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface Messages : NSManagedObject

@property (assign, nonatomic) NSNumber* sender;
@property (strong, nonatomic) NSDate* sendTime;
@property (strong, nonatomic) NSString* message;
@property (assign, nonatomic) NSNumber* messageType;
@property (assign, nonatomic) NSNumber* showSendTime;
@property (strong, nonatomic) NSNumber* height;

+ (instancetype)messageWithSender:(NSUInteger)sender
                         sendTime:(NSDate*)sendTime
                          message:(NSString*)message
                      messageType:(ChatMessageType)messageType;
@end
