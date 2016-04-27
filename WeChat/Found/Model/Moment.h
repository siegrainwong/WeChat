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

@property (strong, nonatomic) NSIndexPath* indexPath;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger contentLineCount;
@property (assign, nonatomic) CGFloat contentLabelHeight;

+ (instancetype)momentWithContent:(NSString*)content name:(NSString*)name pictures:(NSArray*)pictures comments:(NSArray*)comments;
@end
