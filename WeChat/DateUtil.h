//
//  DateUtil.h
//  zhihuDaily
//
//  Created by Siegrain on 16/3/16.
//  Copyright © 2016年 siegrain.zhihuDaily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject
+ (NSDate*)stringToDate:(NSString*)dateString format:(NSString*)format;
+ (NSString*)dateString:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*)dateIdentifierNow;
+ (NSString*)dateString:(NSString*)originalStr
             fromFormat:(NSString*)fromFormat
               toFormat:(NSString*)toFormat;
@end
