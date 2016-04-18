//
//  ChatModel.m
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Message.h"

@implementation Message
+ (instancetype)chatModelWithId:(NSUInteger)identifier
                         sender:(NSUInteger)sender
                       sendTime:(NSDate*)sendTime
                        message:(NSString*)message
                    messageType:(ChatMessageType)messageType
{
  Message* model = [[Message alloc] init];
  model.identifier = identifier;
  model.sender = sender;
  model.sendTime = sendTime;
  model.message = message;
  model.messageType = messageType;

  return model;
}
@end
