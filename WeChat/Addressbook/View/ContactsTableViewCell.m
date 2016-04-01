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
@property (strong, nonatomic) UILabel* descriptionLabel;
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

  if (self.style == ContactsTableViewCellStyleSubtitle)
    [label sizeToFit];

  [self addSubview:label];
}
- (void)setDescriptionText:(NSString*)descriptionText
{
  if (self.style == ContactsTableViewCellStyleDefault)
    return;

  _descriptionText = descriptionText;

  CGFloat marginX = self.nameLabel.frame.origin.x;
  CGFloat marginY = CGRectGetMaxY(self.nameLabel.frame) + 3;
  UILabel* label = [[UILabel alloc]
    initWithFrame:CGRectMake(marginX, marginY, self.bounds.size.width - marginX,
                             20)];
  label.text = descriptionText;
  label.font = [UIFont systemFontOfSize:15];
  label.textColor = [UIColor colorWithWhite:.2 alpha:1];

  [label sizeToFit];

  [self addSubview:label];
}
@end
