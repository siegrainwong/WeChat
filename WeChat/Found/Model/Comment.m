//
//  Comment.m
//  WeChat
//
//  Created by Siegrain on 16/4/26.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Comment.h"

@implementation Comment
+ (instancetype)commentWithName:(NSString*)name content:(NSString*)content
{
    Comment* model = [[Comment alloc] init];
    model.name = name;
    model.content = content;

    return model;
}
@end
