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
+ (instancetype)coverHeaderWithCover:(UIImage*)cover
                              avatar:(UIImage*)avatar
                                name:(NSString*)name
{
  CoverHeaderView* view =
    [[[NSBundle mainBundle] loadNibNamed:@"CoverHeaderView"
                                   owner:nil
                                 options:nil] lastObject];

  view.coverImageView.image = cover;
  view.nameLabel.text = name;

  view.avatarButton.layer.borderWidth = 1;
  view.avatarButton.layer.borderColor =
    [UIColor colorWithWhite:0.95 alpha:1].CGColor;
  [view.avatarButton setImage:avatar forState:UIControlStateNormal];

  return view;
}

@end
