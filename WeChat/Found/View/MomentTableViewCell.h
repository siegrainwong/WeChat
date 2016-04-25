//
//  MomentTableViewCell.h
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Moment;

@interface MomentTableViewCell : UITableViewCell

- (void)setModel:(Moment*)model;
@end
