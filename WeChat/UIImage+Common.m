//
//  UIImage+Common.m
//  WeChat
//
//  Created by Siegrain on 16/3/31.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "UIImage+Common.h"

@implementation UIImage (Common)
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
  CGRect rect = CGRectMake(0, 0, size.width, size.height);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}
@end
