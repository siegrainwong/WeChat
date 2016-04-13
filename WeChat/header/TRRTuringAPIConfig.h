//
//  TRRTuringAPIConfig.h
//  TuringSDK
//
//  Created by   Turing on 15/8/28.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRRTuringAPI.h"

/*!
 @header
 @abstract 图灵语义分析API配置接口
 @author Turing
 @version 1.00 2015/09/06 Creation
 */

/*!
 @class
 @abstract 图灵语音分析API配置接口类
 */

@interface TRRTuringAPIConfig : NSObject

/*!
 @property
 @abstract 图灵语音分析API的UserID。
 @discussion 该数值为nil，SDK应该调用 -request_UserIDwithSuccessBlock:failBlock: 接口获取UserID。
 */
@property (nonatomic, readonly) NSString *userID;

/*!
 @property
 @abstract 图灵语音分析API的API Key。
 */
@property (nonatomic, copy) NSString *APIKey;

/*!
 @method
 @abstract 完成TRRTuringAPIConfig实例变量的初始化，需要用户传入Turing API的API Key。
 @param apikey 图灵SDK的API Key
 @discussion
 @result TRRTuringAPIConfig对象实例
 */

- (instancetype)initWithAPIKey:(NSString *)apikey;

/*!
 @method
 @abstract 获取图灵SDK的User ID的接口。该接口会发起异步网络请求获取UserID，用户通过注册Block方式处理网络请求的结果
 @param success 成功获取UserID时的处理Block
 @param failed 获取UserID失败时的处理Block
 @discussion    该接口用于获取图灵SDK的User ID，只有获得User ID后才能调用图灵SDK的语义分析等接口。
 @result
 */
- (void)request_UserIDwithSuccessBlock:(SuccessStringBlock)success failBlock:(FailBlock)failed;

/*!
 @method
 @abstract 取消获取UserID请求
 */
- (void)cancelRequest;

@end
