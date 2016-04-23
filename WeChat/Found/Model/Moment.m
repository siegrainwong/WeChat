//
//  Moment.m
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Moment.h"

@implementation Moment
+ (instancetype)momentWithContent:(NSString*)content name:(NSString*)name pictures:(NSArray*)pictures comments:(NSArray*)comments
{
    Moment* model = [[Moment alloc] init];
    model.content = content;
    model.name = name;
    model.pictures = pictures;
    model.comments = comments;

    return model;
}
@end
