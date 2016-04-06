//
//  DateUtil.m
//  zhihuDaily
//
//  Created by Siegrain on 16/3/16.
//  Copyright © 2016年 siegrain.zhihuDaily. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+ (NSDate*)stringToDate:(NSString*)dateString format:(NSString*)format
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateString];
}
+ (NSString*)dateString:(NSDate*)date withFormat:(NSString*)format
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSString* dateToString = [dateFormatter stringFromDate:date];
    return dateToString;
}
+ (NSString*)dateString:(NSString*)originalStr fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = fromFormat;
    NSDate* date = [dateFormatter dateFromString:originalStr];
    dateFormatter.dateFormat = toFormat;
    return [dateFormatter stringFromDate:date];
}
+ (NSString*)dateIdentifierNow
{
    return [self dateString:[NSDate date] withFormat:@"yyyyMMddHHmmssfff"];
}
@end
