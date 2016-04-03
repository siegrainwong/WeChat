//
//  MeTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/3/28.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "MeTableViewCell.h"
#import "PersonModel.h"

@implementation MeTableViewCell
- (void)setModel:(PersonModel*)model
{
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  self.avatarImageView.image = [UIImage imageNamed:model.avatar];

  self.nameLabel.text = model.name;

  self.wechatIdLabel.text =
    [NSString stringWithFormat:@"微信号: %@", model.wechatId];

  self.barcodeImageView.image = [UIImage imageNamed:@"ScanQRCode"];
  self.barcodeImageView.backgroundColor = [UIColor whiteColor];
}

- (UIImageView*)avatarImageView
{
  if (!_avatarImageView) {
    _avatarImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(12, 12, self.frame.size.height - 2 * 12,
                               self.frame.size.height - 2 * 12)];

    _avatarImageView.clipsToBounds = YES;
    //圆角
    _avatarImageView.layer.cornerRadius = 3;

    [self addSubview:_avatarImageView];
  }
  return _avatarImageView;
}

- (UILabel*)nameLabel
{
  if (!_nameLabel) {
    _nameLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(self.frame.size.height - 2 * 12 + 2 * 12, 19,
                               160, 22)];

    _nameLabel.font = [UIFont systemFontOfSize:15];

    [self addSubview:_nameLabel];
  }
  return _nameLabel;
}

- (UILabel*)wechatIdLabel
{
  if (!_wechatIdLabel) {
    _wechatIdLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(self.frame.size.height - 2 * 12 + 2 * 12,
                               self.nameLabel.frame.origin.y +
                                 self.nameLabel.frame.size.height + 5,
                               160, 20)];

    _wechatIdLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_wechatIdLabel];
  }
  return _wechatIdLabel;
}

- (UIImageView*)barcodeImageView
{
  if (!_barcodeImageView) {
    _barcodeImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(self.frame.size.width - 50,
                               ((self.frame.size.height - 35 / 2.0) / 2.0),
                               35 / 2.0, 35 / 2.0)];

    [self addSubview:_barcodeImageView];
  }
  return _barcodeImageView;
}
@end
