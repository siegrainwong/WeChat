//
//  ChatModel.m
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel
- (instancetype)initWithDic:(NSDictionary*)dic
{
  self = [super init];
  if (self) {
    [self setValuesForKeysWithDictionary:dic];
  }
  return self;
}

+ (instancetype)chatWithDic:(NSDictionary*)dic
{
  return [[self alloc] initWithDic:dic];
}

+ (NSArray*)chat
{
  NSArray* array = [NSArray
    arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chat"
                                                            ofType:@"plist"]];

  NSMutableArray* arrayM = [NSMutableArray array];
  for (NSDictionary* dic in array) {
    [arrayM addObject:[self chatWithDic:dic]];
  }

  return arrayM;
}
@end
