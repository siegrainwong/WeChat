//
//  DateUtil.m
//  zhihuDaily
//
//  Created by Siegrain on 16/3/16.
//  Copyright © 2016年 siegrain.zhihuDaily. All rights reserved.
//

#import "DateUtil.h"

static const NSUInteger kIntervalOfDay = 24 * 60 * 60;

@implementation DateUtil
#pragma mark - formatter
+ (NSDateFormatter*)sharedDateFormatter
{
  static NSDateFormatter* dateFormatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
  });

  return dateFormatter;
}
#pragma mark - format
+ (NSDate*)stringToDate:(NSString*)dateString format:(NSString*)format
{
  NSDateFormatter* dateFormatter = [self sharedDateFormatter];
  dateFormatter.dateFormat = format;
  return [dateFormatter dateFromString:dateString];
}
+ (NSString*)dateString:(NSDate*)date withFormat:(NSString*)format
{
  NSDateFormatter* dateFormatter = [self sharedDateFormatter];
  dateFormatter.dateFormat = format;
  NSString* dateToString = [dateFormatter stringFromDate:date];
  return dateToString;
}
+ (NSString*)dateString:(NSString*)originalStr
             fromFormat:(NSString*)fromFormat
               toFormat:(NSString*)toFormat
{
  NSDateFormatter* dateFormatter = [self sharedDateFormatter];
  dateFormatter.dateFormat = fromFormat;
  NSDate* date = [dateFormatter dateFromString:originalStr];
  dateFormatter.dateFormat = toFormat;
  return [dateFormatter stringFromDate:date];
}
#pragma mark - calculate
+ (NSDateComponents*)differsDaysFromDate:(NSDate*)date
                                 andDate:(NSDate*)otherDate

{
  NSCalendar* calendar = [NSCalendar currentCalendar];
  int unit = NSCalendarUnitDay | NSCalendarUnitWeekOfMonth;

  date = [self shortDate:date];
  otherDate = [self shortDate:otherDate];

  return [calendar components:unit fromDate:date toDate:otherDate options:0];
}
#pragma mark - helper
+ (NSString*)dateIdentifierNow
{
  return [self dateString:[NSDate date] withFormat:@"yyyyMMddHHmmssfff"];
}

+ (NSDate*)shortDate:(NSDate*)date
{
  NSString* format = [self dateString:date withFormat:@"yyyy-MM-dd"];
  return [self stringToDate:format format:@"yyyy-MM-dd"];
}
+ (NSDate*)localizedDate:(NSDate*)date
{
  //设置源日期时区
  NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
  //设置转换后的目标日期时区
  NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
  //得到源日期与世界标准时间的偏移量
  NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
  //目标日期与本地时区的偏移量
  NSInteger destinationGMTOffset =
    [destinationTimeZone secondsFromGMTForDate:date];
  //得到时间偏移量的差值
  NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
  //转为现在时间
  NSDate* destinationDateNow =
    [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
  return destinationDateNow;
}
+ (NSString*)localizedShortDateString:(NSDate*)date
{
  NSDateComponents* dateComponents =
    [self differsDaysFromDate:[NSDate date] andDate:date];

  if (dateComponents.day == 0)
    return [self dateString:date withFormat:@"HH:mm"];
  else if (dateComponents.day == -1)
    return [self dateString:date withFormat:@"昨天 HH:mm"];
  else if (dateComponents.weekOfMonth == 0)
    return [self dateString:date withFormat:@"EEEE HH:mm"];
  else
    return [self dateString:date withFormat:@"yyyy年MM月dd日 HH:mm"];
}
+ (NSString*)localizedShortDateStringFromInterval:(NSTimeInterval)interval
{
  return [self localizedShortDateString:
                 [NSDate dateWithTimeIntervalSinceReferenceDate:interval]];
}
@end
