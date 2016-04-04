//
//  ChatModel.h
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "EditorView.h"
#import <UIKit/UIKit.h>

@interface ChatModel : NSObject
@property (assign, nonatomic) NSUInteger identifier;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSDate* sendTime;
@property (strong, nonatomic) id message;
@property (assign, nonatomic) ChatMessageType messageType;

- (instancetype)initWithDic:(NSDictionary*)dic;
+ (instancetype)chatWithDic:(NSDictionary*)dic;

+ (NSArray*)chat;
@end
