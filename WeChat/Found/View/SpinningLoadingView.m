//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "CoverHeaderView.h"
#import "SpinningLoadingView.h"

static NSString* const kRotateAnimationKey = @"RotateAnimation";
static NSUInteger const kSpinningPosition = 30;
static NSInteger const kViewHeight = 60;
static NSUInteger const kSpinningSize = 30;

/*
 朋友圈的转圈下拉加载
 我也是脑子残了拿MJRefresh来改
 体验不完美，下拉松开后有时菊花会朝上弹一截再回到原位
 */
@interface
SpinningLoadingView ()
@property (weak, nonatomic) UIImageView* spinningView;
@property (strong, nonatomic) CoverHeaderView* coverView;

@property (strong, nonatomic) CABasicAnimation* rotateAnimation;
@end

@implementation SpinningLoadingView
#pragma mark - 重写方法
- (void)dealloc
{
    //    NSLog(@"SpinningLoading View已释放。");
}
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];

    self.dontSetYWhenPlaceSubviews = true;
    self.mj_h = kViewHeight;

    UIImageView* spinningView = [[UIImageView alloc]
      initWithImage:[UIImage imageNamed:@"AlbumReflashIcon"]];
    spinningView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:spinningView];
    self.spinningView = spinningView;

    self.rotateAnimation = [[CABasicAnimation alloc] init];
    self.rotateAnimation.keyPath = @"transform.rotation.z";
    self.rotateAnimation.fromValue = @0;
    self.rotateAnimation.toValue = @(M_PI * 2);
    self.rotateAnimation.duration = 1.0;
    self.rotateAnimation.repeatCount = MAXFLOAT;

    self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop;
}

#pragma mark 在这里设置子控件的位置和尺寸
/*这个方法会在下拉状态被不停地调用..*/
- (void)placeSubviews
{
    [super placeSubviews];

    //这里用frame的话下拉旋转的时候会变大变小..日了狗了
    self.spinningView.bounds = CGRectMake(0, 0, kSpinningSize, kSpinningSize);
    self.spinningView.center = CGPointMake(kSpinningPosition, kSpinningPosition);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary*)change
{
    [super scrollViewContentOffsetDidChange:change];

    self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop;

    CGFloat pullingY = fabs(self.scrollView.mj_offsetY + 64 +
                            self.ignoredScrollViewContentInsetTop);
    if (pullingY >= kViewHeight) {
        CGFloat marginY = -kViewHeight - (pullingY - kViewHeight) -
                          self.ignoredScrollViewContentInsetTop;
        self.mj_y = marginY;
    }

    CGFloat rotateAngle = pullingY / kViewHeight * M_PI;
    CGAffineTransform transform = CGAffineTransformIdentity;
    //设置旋转角度
    transform = CGAffineTransformRotate(transform, rotateAngle);

    self.spinningView.transform = transform;
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
            [self.spinningView.layer removeAnimationForKey:kRotateAnimationKey];
            break;
        case MJRefreshStatePulling:
            break;
        case MJRefreshStateRefreshing:
            // 2. 一直转圈
            [self.spinningView.layer addAnimation:self.rotateAnimation
                                           forKey:kRotateAnimationKey];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}

@end
