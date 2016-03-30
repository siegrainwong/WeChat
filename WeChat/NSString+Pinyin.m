//
//  NSString+Pinyin.m
//  WeChat
//
//  Created by Siegrain on 16/3/30.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "NSString+Pinyin.h"

@implementation NSString (Pinyin)
- (NSString*)transformToPinyin
{
  NSMutableString* mutableString = [NSMutableString stringWithString:self];
  CFStringTransform((CFMutableStringRef)mutableString, NULL,
                    kCFStringTransformToLatin, false);
  CFStringTransform((CFMutableStringRef)mutableString, NULL,
                    kCFStringTransformStripDiacritics, false);
  return mutableString;
}
@end
