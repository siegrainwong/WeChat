//
//  GlassView.m
//  WeChat
//
//  Created by Siegrain on 16/3/30.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "GlassView.h"

@implementation GlassView
- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    UIBlurEffect* blurEffect =
      [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* effectView =
      [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

    [self addSubview:effectView];
  }
  return self;
}
@end
