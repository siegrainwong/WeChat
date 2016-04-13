//
//  TRRTuringAPI.h
//  TuringSDK
//
//  Created by   Turing on 15/8/30.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

#ifndef TuringSDK_TRRTuringAPI_h
#define TuringSDK_TRRTuringAPI_h

/*!
 @header
 @abstract 图灵语义分析API通用头文件
 @author Turing
 @version 1.00 2015/09/06 Creation
 */

/*!
 @typedef
 @abstract API错误类型枚举值
 @constant TRRAPIErrorBusy 网络请求API正忙，可以稍后再做尝试
 @constant TRRAPIErrorTimeout 网络请求超时
 @constant TRRAPIErrorResponseStatus 网络请求返回的StatusCode值异常
 @constant TRRAPIErrorGeneral 网络操作错误，具体信息需要参考返回的错误字符串
 @constant TRRAPIErrorResult 接口返回结果错误，
 */

typedef enum {
    TRRAPIErrorBusy,
    TRRAPIErrorTimeout,
    TRRAPIErrorResponseStatus,
    TRRAPIErrorGeneral,
    TRRAPIErrorResult
}TRRAPIErrorType;

/*!
 @typedef
 @abstract  网络请求成功的处理Block类型，输入参数为NSString
 */
typedef void(^SuccessStringBlock)(NSString *) ;

/*!
 @typedef
 @abstract  网络请求成功的处理Block类型，输入参数为NSDictionary
 */
typedef void(^SuccessDictBlock)(NSDictionary *) ;

/*!
 @typedef
 @abstract  网络请求失败的处理Block类型
 @param errorType TRRAPIErrorType类型的错误值
 @param infoStr 错误描述字符串
 */
typedef void(^FailBlock)(TRRAPIErrorType errorType, NSString *infoStr);

#endif
