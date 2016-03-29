//
//  ContactsTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/3/29.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ContactsTableViewCell.h"

static NSInteger const kContentInsetH = 10;
static NSInteger const kContentInsetV = 6;

@interface
ContactsTableViewCell ()
@property (strong, nonatomic) UIImageView* avatarImageView;
@property (strong, nonatomic) UILabel* nameLabel;
@end

@implementation ContactsTableViewCell

- (void)setAvatar:(UIImage*)avatar
{
  _avatar = avatar;

  CGFloat size = self.bounds.size.height - kContentInsetV * 2;
  self.avatarImageView = [[UIImageView alloc]
    initWithFrame:CGRectMake(kContentInsetH, kContentInsetV, size, size)];
  self.avatarImageView.image = avatar;

  [self addSubview:self.avatarImageView];
}
- (void)setName:(NSString*)name
{
  _name = name;

  CGRect imageRect = self.avatarImageView.frame;
  CGFloat marginX = CGRectGetMaxX(imageRect) + kContentInsetH;
  UILabel* label = [[UILabel alloc]
    initWithFrame:CGRectMake(marginX, 0, self.bounds.size.width - marginX,
                             self.bounds.size.height)];
  label.text = name;
  [self addSubview:label];
}
@end
