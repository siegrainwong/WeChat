//
//  ChatModel.m
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Messages.h"

@implementation Messages
@dynamic sender;
@dynamic sendTime;
@dynamic message;
@dynamic messageType;
@dynamic showSendTime;
@dynamic height;

+ (instancetype)messageWithSender:(NSUInteger)sender
                         sendTime:(NSDate*)sendTime
                          message:(NSString*)message
                      messageType:(ChatMessageType)messageType
{
  Messages* model = [[Messages alloc] init];
  model.sender = @(sender);
  model.sendTime = sendTime;
  model.message = message;
  model.messageType = @(messageType);

  return model;
}
@end
