//
//  UIImage+RandomImage.m
//  WeChat
//
//  Created by Siegrain on 16/3/29.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "UIImage+RandomImage.h"

@implementation UIImage (RandomImage)
+ (UIImage*)randromImageInPath:(NSString*)path
{
  NSFileManager* fm = [[NSFileManager alloc] init];
  if (![fm fileExistsAtPath:path])
    return nil;

  NSArray* files = [fm subpathsAtPath:path];
  NSString* randomFileName = files[arc4random() % files.count - 1];
  NSString* combinedFilePath =
    [NSString stringWithFormat:@"%@/%@", path, randomFileName];

  NSString* imagePath =
    [[NSBundle mainBundle] pathForResource:combinedFilePath ofType:nil];
  UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];

  return image;
}
@end
