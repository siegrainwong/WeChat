//
//  WeChatHelper.m
//  WeChat
//
//  Created by Siegrain on 16/4/25.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "WeChatHelper.h"

@implementation WeChatHelper
#pragma mark - accessors
+ (UIColor*)wechatFontColor
{
	static UIColor* color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(
      &onceToken,
      ^{
		  color = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:1];
	  });
	return color;
}
+ (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}
@end
