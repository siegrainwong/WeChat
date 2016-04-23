//
//  Moment.h
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Moment : NSObject
@property (copy, nonatomic) NSString* content;
@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) UIImage* avatar;

@property (copy, nonatomic) NSArray* pictures;
@property (copy, nonatomic) NSArray* comments;

+ (instancetype)momentWithContent:(NSString*)content name:(NSString*)name pictures:(NSArray*)pictures comments:(NSArray*)comments;
@end
