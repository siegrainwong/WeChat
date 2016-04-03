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
  if (avatar == _avatar)
    return;

  [self.avatarImageView removeFromSuperview];

  _avatar = avatar;
  CGFloat size = self.bounds.size.height - kContentInsetV * 2;
  self.avatarImageView = [[UIImageView alloc]
    initWithFrame:CGRectMake(kContentInsetH, kContentInsetV, size, size)];
  self.avatarImageView.image = avatar;

  [self addSubview:self.avatarImageView];
}
- (void)setName:(NSString*)name
{
  if ([name isEqualToString:_name])
    return;

  [self.nameLabel removeFromSuperview];

  _name = name;
  CGRect imageRect = self.avatarImageView.frame;
  CGFloat marginX = CGRectGetMaxX(imageRect) + kContentInsetH;
  CGFloat marginY =
    self.style == ContactsTableViewCellStyleSubtitle ? kContentInsetV + 5 : 0;
  self.nameLabel = [[UILabel alloc]
    initWithFrame:CGRectMake(marginX, marginY, self.bounds.size.width - marginX,
                             self.bounds.size.height)];
  self.nameLabel.text = name;
  self.nameLabel.font = [UIFont systemFontOfSize:16];

  if (self.style == ContactsTableViewCellStyleSubtitle)
    [self.nameLabel sizeToFit];

  [self addSubview:self.nameLabel];
}
- (void)setDescriptionText:(NSString*)descriptionText
{
  if ([descriptionText isEqualToString:_descriptionText])
    return;

  if (self.style == ContactsTableViewCellStyleDefault)
    return;

  [self.descriptionLabel removeFromSuperview];

  _descriptionText = descriptionText;
  CGFloat marginX = self.nameLabel.frame.origin.x;
  CGFloat marginY = CGRectGetMaxY(self.nameLabel.frame) + 5;
  self.descriptionLabel = [[UILabel alloc]
    initWithFrame:CGRectMake(marginX, marginY, self.bounds.size.width - marginX,
                             20)];
  self.descriptionLabel.text = descriptionText;
  self.descriptionLabel.font = [UIFont systemFontOfSize:14];
  self.descriptionLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];

  [self.descriptionLabel sizeToFit];

  [self addSubview:self.descriptionLabel];
}
@end
