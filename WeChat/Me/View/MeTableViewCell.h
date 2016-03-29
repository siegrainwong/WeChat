//
//  MeTableViewCell.h
//  WeChat
//
//  Created by Siegrain on 16/3/28.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonModel;

@interface MeTableViewCell : UITableViewCell
/**
 *  model
 */
@property (nonatomic, strong) PersonModel* model;

/**
 *  用户头像ImgView
 */
@property (nonatomic, strong) UIImageView* avatarImageView;

/**
 *  用户名Label
 */
@property (nonatomic, strong) UILabel* nameLabel;

/**
 *  微信号Label
 */
@property (nonatomic, strong) UILabel* wechatIdLabel;

/**
 *  二维码ImgView
 */
@property (nonatomic, strong) UIImageView* barcodeImageView;

- (void)setModel:(PersonModel*)model;
@end
