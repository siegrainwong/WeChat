//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "SpinningLoadingView.h"
/*
 朋友圈的转圈下拉加载
 */
@interface
SpinningLoadingView ()
@property (weak, nonatomic) UIImageView* logo;
@end

@implementation SpinningLoadingView
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
  [super prepare];

  // 设置控件的高度
  self.mj_h = 50;

  // logo
  UIImageView* logo = [[UIImageView alloc]
    initWithImage:[UIImage imageNamed:@"ff_IconShowAlbum"]];
  logo.contentMode = UIViewContentModeScaleAspectFit;
  [self addSubview:logo];
  self.logo = logo;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
  [super placeSubviews];

  self.logo.bounds = CGRectMake(0, 0, self.bounds.size.width, 100);
  self.logo.center = CGPointMake(self.mj_w * 0.5, -self.logo.mj_h + 20);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary*)change
{
  [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary*)change
{
  [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary*)change
{
  [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
  MJRefreshCheckState;
  switch (state) {
    case MJRefreshStateIdle:
      // 3. 停止转圈
      break;
    case MJRefreshStatePulling:
      // 1. 一边移动一边根据下拉长度转圈，移动到固定位置后停止移动
      break;
    case MJRefreshStateRefreshing:
      // 2. 一直转圈
      break;
    default:
      break;
  }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
  [super setPullingPercent:pullingPercent];

  //根据比例来转圈...
}

@end
