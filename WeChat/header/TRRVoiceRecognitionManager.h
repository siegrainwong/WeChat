//
//  TRRVoiceRecognitionManager.h
//  TuringSDK
//
//  Created by   Turing on 15/9/1.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

/*!
 @header
 @abstract 图灵语音识别开放接口
 @author Turing
 @version 1.00 2015/09/06 Creation
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "BDVoiceRecognitionClient.h"

/*!
 @protocol TRRVoiceRecognitionManagerDelegate
 @abstract 语音识别功能管理器的代理
 */

@protocol TRRVoiceRecognitionManagerDelegate <MVoiceRecognitionClientDelegate>
/*!
 @method
 @abstract 接收语音识别结果的代理函数。
 @param result 语音识别结果字符串
 */
- (void)onRecognitionResult:(NSString *)result;

/*!
 @method
 @abstract 接收语音识别错误信息的代理函数。
 @param errStr 语音识别错误信息x字符串
 */
- (void)onRecognitionError:(NSString *)errStr;

/*!
 @method
 @abstract 已启动语音识别的事件处理函数。
 */
- (void)onStartRecognize;

/*!
 @method
 @abstract 检测到用户已说话的事件处理函数。
 */
- (void)onSpeechStart;

/*!
 @method
 @abstract 检测到用户已停止说话的事件代理函数。
 */
- (void)onSpeechEnd;

@end

/*!
 @class TRRVoiceRecognitionManager
 @abstract 用来完成语音识别功能的类
 @discussion 该类为单例形式，用户需要使用sharedInstance函数获得句柄
 */

@interface TRRVoiceRecognitionManager : NSObject

/*!
 @method
 @abstract 获取TRRVoiceRecognitionManager的单例句柄
 @result TRRVoiceRecognitionManager对象实例
 */

+ (TRRVoiceRecognitionManager *)sharedInstance;

/*!
 @method
 @abstract 设置语音识别需要的Baidu SDK的API Key和SecretKey
 @param apiKey Baidu SDK的APIKey
 @param secretKey Baidu SDK的Secret Key
 */

- (void)setApiKey:(NSString *)apiKey secretKey:(NSString *)secretKey;

/*!
 @method
 @abstract 启动语音识别功能
 @result 返回值参考BDVoiceRecognitionClient.h中TVoiceRecognitionStartWorkResult

 */
- (int)startVoiceRecognition;

/*!
 @method
 @abstract 停止语音识别功能，代表手动触发用户发音结束事件
 */
- (void)stopRecognize;

/*!
 @method
 @abstract 取消语音识别功能
 */
- (void)cancleRecognize;

/*!
 @method
 @abstract 获取采样速率信息
 */

- (int)getCurrentSampleRate;

/*!
 @method
 @abstract 获取当前音量级别
 */

- (int)getCurrentDBLevelMeter;

/*!
 @property
 @abstract 当前识别类型数组，参见BDVoiceRecognitionClient.h
 */

@property (nonatomic, strong) NSArray *recognitionPropertyList;

/*!
 @method
 @abstract 设置城市信息
 */
// cityID仅对EVoiceRecognitionPropertyMap识别类型有效
- (void)setCityID: (NSInteger)cityID;

//- - - - - - - - - - - - - - - -功能设置- - - - - - - - - - - - - - - - - - - -
// 定制功能
// 定制语义解析功能请传入key=BDVR_CONFIG_KEY_NEED_NLU，如果开启此功能，将返回带语义的json串，含义详见开发文档说明
#define TRR_CONFIG_KEY_NEED_NLU @"nlu"
// 定制通讯录识别功能请传入key=BDVR_CONFIG_KEY_ENABLE_CONTACTS，如果开启此功能，将优先返回通讯录识别结果
#define TRR_CONFIG_KEY_ENABLE_CONTACTS @"enable_contacts"
// 定制SDK是否对AudioSession进行操作，如果外部需要操作AudioSession，应当通过此接口禁止SDK对AudioSession进行操作
#define TRR_CONFIG_KEY_DISABLE_AUDIO_SESSION_CONTROL @"disable_audio_session_control"
/*!
 @method
 @abstract 进行功能设置，具体参数及取值参考BDVoiceRecognitionClient.h
 */
- (void)setConfig:(NSString *)key withFlag:(BOOL)flag;

/*!
 @method
 @abstract 设置识别语言，具体参数及取值参考BDVoiceRecognitionClient.h
 */

// 设置识别语言，有效值参见枚举类型TVoiceRecognitionLanguage
- (void)setLanguage:(int)language;

/*!
 @method
 @abstract 关闭标点
 */
// 关闭标点
- (void)disablePuncs:(BOOL)flag;

/*!
 @method
 @abstract 设置是否需要对录音数据进行端点检测
 */
// 设置是否需要对录音数据进行端点检测
- (void)setNeedVadFlag: (BOOL)flag;

/*!
 @method
 @abstract 设置是否需要对录音数据进行压缩
 */
// 设置是否需要对录音数据进行压缩
- (void)setNeedCompressFlag: (BOOL)flag;

/*!
 @property
 @abstract 语音识别管理器代理
 */
@property (nonatomic, weak) id <TRRVoiceRecognitionManagerDelegate> delegate;

@end
