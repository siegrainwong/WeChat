//
//  ContactsTableViewCell.h
//  WeChat
//
//  Created by Siegrain on 16/3/29.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ContactsTableViewCellStyle) {
  ContactsTableViewCellStyleDefault = 0,
  ContactsTableViewCellStyleSubtitle
};

@interface ContactsTableViewCell : UITableViewCell
@property (assign, nonatomic) ContactsTableViewCellStyle style;
@property (assign, nonatomic) CGFloat avatarCornerRadius;

/*请按照以下顺序设值*/
@property (strong, nonatomic) UIImage* avatar;
@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* descriptionText;

@end
