//
//  PersonModel.h
//  WeChat
//
//  Created by Siegrain on 16/3/28.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString* avatar;

/**
 *  用户名称
 */
@property (nonatomic, copy) NSString* name;

/**
 *  微信号
 */
@property (nonatomic, copy) NSString* wechatId;
@end
