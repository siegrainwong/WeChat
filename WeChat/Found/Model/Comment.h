//
//  Comment.h
//  WeChat
//
//  Created by Siegrain on 16/4/26.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* content;
@property (assign, nonatomic) float height;

+ (instancetype)commentWithName:(NSString*)name content:(NSString*)content;
@end