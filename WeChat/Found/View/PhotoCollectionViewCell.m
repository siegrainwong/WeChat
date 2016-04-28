//
//  PhotoCollectionViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/24.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Masonry/Masonry/Masonry.h"
#import "PhotoCollectionViewCell.h"

@interface
PhotoCollectionViewCell ()
@end
@implementation PhotoCollectionViewCell
- (void)dealloc
{
    NSLog(@"PhotoCollectionView Cell已释放。");
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildCell];
        [self bindConstraints];
    }

    return self;
}
- (void)buildCell
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = true;
    [self addSubview:self.imageView];
}

- (void)bindConstraints
{
    [self.imageView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.bottom.offset(0);
    }];
}
@end
