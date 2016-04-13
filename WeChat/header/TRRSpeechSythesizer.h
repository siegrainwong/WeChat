//
//  TRRSpeechSythesizer.h
//  TRRSpeechSythesizer
//
//  Created by Turing on 15/8/24.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

/*!
 @header
 @abstract 图灵语音合成开放接口
 @author Turing
 @version 1.00 2015/09/06 Creation
 */

#import <Foundation/Foundation.h>

/*!
 @class TRRSpeechSythesizer
 @abstract 用来完成语音合成功能的类
 */

@interface TRRSpeechSythesizer : NSObject

/*!
 @method
 @abstract 完成TRRSpeechSythesizer实例变量的初始化，需要用户传入Baidu语音合成SDK的APIKey和SecretKey参数。
 @param apikey Baidu SDK的APIKey
 @param secretkey Baidu SDK的Secret Key
 @discussion
 @result TRRSpeechSythesizer对象实例
 */

- (instancetype)initWithAPIKey:(NSString *)apikey secretKey:(NSString *)secretkey;

/*!
 @method
 @abstract 设置语音合成功能的参数。
 @param key 语音合成配置项名称，具体取值参见 BDSSpeechSynthesizer.h
 @param value 语音合成配置项的设置值
 @discussion
 @result 错误码
 */
- (int)setParamForKey:(NSString *)key value:(NSString *)value;

/*!
 @method
 @abstract 启动语音合成操作。
 @param text 需要合成语音的文字
 @discussion
 @result 启动操作的结果。返回值为0，表示启动成功；返回值不等于0，表示启动合成出错，具体的错误值请参考BDSSpeechSynthesizer.h
 */

- (int)start:(NSString *)text;

/*!
 @method
 @abstract 暂停语音合成操作。
 @discussion
 @result 暂停操作的结果。返回值为0，表示暂停成功；返回值不等于0，表示暂停合成出错，具体的错误值请参考BDSSpeechSynthesizer.h
 */

- (int)pause;

/*!
 @method
 @abstract 用于恢复已暂停的语音合成操作。
 @discussion
 @result 恢复操作的结果。返回值为0，表示恢复成功；返回值不等于0，表示恢复合成出错，具体的错误值请参考BDSSpeechSynthesizer.h
 */
- (int)resume;

/*!
 @method
 @abstract 停止语音合成操作。
 @discussion
 */
- (void)stop;
@end
