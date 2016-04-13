//
//  ChatModel.h
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "EditorView.h"
#import "JSONModel/JSONModel/JSONModel/JSONModel.h"
#import <UIKit/UIKit.h>

@interface ChatModel : JSONModel
@property (assign, nonatomic) NSUInteger identifier;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSDate* sendTime;
@property (strong, nonatomic) NSString* message;
@property (assign, nonatomic) ChatMessageType messageType;

+ (instancetype)chatModelWithId:(NSUInteger)identifier
                           name:(NSString*)name
                       sendTime:(NSDate*)sendTime
                        message:(NSString*)message
                    messageType:(ChatMessageType)messageType;
@end
