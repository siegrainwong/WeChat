//
//  TRRTuringRequestManager.h
//  TuringSDK
//
//  Created by   Turing on 15/8/30.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRRTuringAPI.h"
#import "TRRTuringAPIConfig.h"

/*!
 @header
 @abstract 图灵语义分析API请求接口
 @author Turing
 @version 1.00 2015/09/06 Creation
 */

/*!
 @class
 @abstract 图灵语义分析API请求接口类
 */

@interface TRRTuringRequestManager : NSObject

/*!
 @method
 @abstract 完成TRRTuringRequestManager实例变量的初始化。
 @param config TRRTuringAPIConfig对象实例
 @discussion 需要用户传入已完成初始化的TRRTuringAPIConfig实例对象（具有正确取值的API Key和UserID）
 @result TRRTuringRequestManager对象实例
 */

- (instancetype)initWithConfig:(TRRTuringAPIConfig *)config;

/*!
 @method
 @abstract 图灵语义分析API的操作接口。该接口会发起异步网络请求进行语义分析，用户通过注册Block方式处理网络请求的结果
 @param info 需要进行语义分析的字符串
 @param success 成功获取语义分析结果的处理Block，返回的语义分析结果是字典（Dictionary）类型
 @param failed 语义分析失败时的处理Block
 @result
 */
- (void)request_OpenAPIWithInfo:(NSString *)info successBlock:(SuccessDictBlock)success failBlock:(FailBlock)failed;

/*!
 @method
 @abstract 取消语义分析请求
 */
- (void)cancelRequest;

@end
