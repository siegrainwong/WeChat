//
//  UIImage+RandomImage.m
//  WeChat
//
//  Created by Siegrain on 16/3/29.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "UIImage+RandomImage.h"

@implementation UIImage (RandomImage)
+ (UIImage*)randomImageInPath:(NSString*)path
{
  NSString* imagePath =
    [NSString stringWithFormat:@"%@/%u.jpg", [[NSBundle mainBundle] bundlePath],
                               arc4random() % 29];

  UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];

  return image;
}

@end
