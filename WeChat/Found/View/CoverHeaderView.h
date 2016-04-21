//
//  CoverHeaderView.h
//  WeChat
//
//  Created by Siegrain on 16/4/21.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverHeaderView : UIView
+ (instancetype)coverHeaderWithCover:(UIImage*)cover
                              avatar:(UIImage*)image
                                name:(NSString*)name;
@end
