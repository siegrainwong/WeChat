//
//  CoverHeaderView.m
//  WeChat
//
//  Created by Siegrain on 16/4/21.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "CoverHeaderView.h"

@interface
CoverHeaderView ()
@property (strong, nonatomic) IBOutlet UIImageView* coverImageView;
@property (strong, nonatomic) IBOutlet UIButton* avatarButton;
@property (strong, nonatomic) IBOutlet UILabel* nameLabel;

@end

@implementation CoverHeaderView
#pragma mark - init
+ (instancetype)coverHeader
{
  return [[[NSBundle mainBundle] loadNibNamed:@"CoverHeaderView"
                                        owner:nil
                                      options:nil] lastObject];
}

@end
