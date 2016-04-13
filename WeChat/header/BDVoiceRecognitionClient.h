//
//  BDVoiceRecognitionClient.h
//  BDVoiceRecognitionClient
//
//  Created by liujunqi on 12-4-1.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// 枚举 - 语音识别状态
enum TVoiceRecognitionClientWorkStatus
{
    EVoiceRecognitionClientWorkStatusNone = 0,               // 空闲
    EVoiceRecognitionClientWorkPlayStartTone,                // 播放开始提示音
    EVoiceRecognitionClientWorkPlayStartToneFinish,          // 播放开始提示音完成
    EVoiceRecognitionClientWorkStatusStartWorkIng,           // 识别工作开始，开始采集及处理数据
    EVoiceRecognitionClientWorkStatusStart,                  // 检测到用户开始说话
    EVoiceRecognitionClientWorkStatusSentenceEnd,            // 输入模式下检测到语音说话完成
    EVoiceRecognitionClientWorkStatusEnd,                    // 本地声音采集结束结束，等待识别结果返回并结束录音
    EVoiceRecognitionClientWorkPlayEndTone,                  // 播放结束提示音
    EVoiceRecognitionClientWorkPlayEndToneFinish,            // 播放结束提示音完成
    
    EVoiceRecognitionClientWorkStatusNewRecordData,          // 录音数据回调
    EVoiceRecognitionClientWorkStatusFlushData,              // 连续上屏
    EVoiceRecognitionClientWorkStatusReceiveData,            // 输入模式下有识别结果返回
    EVoiceRecognitionClientWorkStatusFinish,                 // 语音识别功能完成，服务器返回正确结果
    
    EVoiceRecognitionClientWorkStatusCancel,                 // 用户取消
    EVoiceRecognitionClientWorkStatusError                   // 发生错误，详情见VoiceRecognitionClientErrorStatus接口通知
};

// 枚举 - 网络工作状态
enum TVoiceRecognitionClientNetWorkStatus
{
    EVoiceRecognitionClientNetWorkStatusStart = 1000,        // 网络开始工作
    EVoiceRecognitionClientNetWorkStatusEnd,                 // 网络工作完成
};

// 枚举 - 语音识别错误通知状态分类
enum TVoiceRecognitionClientErrorStatusClass
{
    EVoiceRecognitionClientErrorStatusClassVDP = 1100,        // 语音数据处理过程出错
    EVoiceRecognitionClientErrorStatusClassRecord = 1200,     // 录音出错
    EVoiceRecognitionClientErrorStatusClassLocalNet = 1300,   // 本地网络联接出错
    EVoiceRecognitionClientErrorStatusClassServerNet = 3000,  // 服务器返回网络错误
};

// 枚举 - 语音识别错误通知状态
enum TVoiceRecognitionClientErrorStatus
{
    //以下状态为错误通知，出现错语后，会自动结束本次识别
    EVoiceRecognitionClientErrorStatusUnKnow = EVoiceRecognitionClientErrorStatusClassVDP+1,          // 未知错误(异常)
    EVoiceRecognitionClientErrorStatusNoSpeech,               // 用户未说话
    EVoiceRecognitionClientErrorStatusShort,                  // 用户说话声音太短
    EVoiceRecognitionClientErrorStatusException,              // 语音前端库检测异常
    
    
    EVoiceRecognitionClientErrorStatusChangeNotAvailable = EVoiceRecognitionClientErrorStatusClassRecord+1,     // 录音设备不可用
    EVoiceRecognitionClientErrorStatusIntrerruption,          // 录音中断
    
    
    EVoiceRecognitionClientErrorNetWorkStatusUnusable = EVoiceRecognitionClientErrorStatusClassLocalNet+1,            // 网络不可用
    EVoiceRecognitionClientErrorNetWorkStatusError,               // 网络发生错误
    EVoiceRecognitionClientErrorNetWorkStatusTimeOut,             // 网络本次请求超时
    EVoiceRecognitionClientErrorNetWorkStatusParseError,          // 解析失败
    
    
    //服务器返回错误
    EVoiceRecognitionClientErrorNetWorkStatusServerParamError = EVoiceRecognitionClientErrorStatusClassServerNet+1,       // 协议参数错误
    EVoiceRecognitionClientErrorNetWorkStatusServerRecognError,      // 识别过程出错
    EVoiceRecognitionClientErrorNetWorkStatusServerNoFindResult,     // 没有找到匹配结果
    EVoiceRecognitionClientErrorNetWorkStatusServerAppNameUnknownError,     // AppnameUnkown错误
    EVoiceRecognitionClientErrorNetWorkStatusServerSpeechQualityProblem,    // 声音不符合识别要求
    EVoiceRecognitionClientErrorNetWorkStatusServerSpeechTooLong,           // 语音过长
    EVoiceRecognitionClientErrorNetWorkStatusServerUnknownError,            // 未知错误
};

// 枚举 - 语音识别类型
typedef enum TBDVoiceRecognitionProperty
{
    EVoiceRecognitionPropertyMusic = 10001, // 音乐
    EVoiceRecognitionPropertyVideo = 10002, // 视频
    EVoiceRecognitionPropertyApp = 10003, // 应用
    EVoiceRecognitionPropertyWeb = 10004, // web
    EVoiceRecognitionPropertySearch = 10005, // 热词
    EVoiceRecognitionPropertyEShopping = 10006, // 电商&购物
    EVoiceRecognitionPropertyHealth = 10007, // 健康&母婴
    EVoiceRecognitionPropertyCall = 10008, // 打电话
    EVoiceRecognitionPropertySong = 10009, // 录歌识别
    EVoiceRecognitionPropertyMedicalCare = 10052, // 医疗
    EVoiceRecognitionPropertyCar = 10053, // 汽车
    EVoiceRecognitionPropertyCatering = 10054, // 娱乐餐饮
    EVoiceRecognitionPropertyFinanceAndEconomics = 10055, // 财经
    EVoiceRecognitionPropertyGame = 10056, // 游戏
    EVoiceRecognitionPropertyCookbook = 10057, // 菜谱
    EVoiceRecognitionPropertyAssistant = 10058, // 助手
    EVoiceRecognitionPropertyRecharge = 10059, // 话费充值
    EVoiceRecognitionPropertyMap = 10060,  // 地图
    EVoiceRecognitionPropertyInput = 20000, // 输入
} TBDVoiceRecognitionProperty;

// 枚举 - 播放录音提示音
enum TVoiceRecognitionPlayTones
{
    EVoiceRecognitionPlayTonesRecStart = 1,                 // 录音开始提示音
    EVoiceRecognitionPlayTonesRecEnd = 2,                   // 录音结束提示音
    //所有日志打开
    EVoiceRecognitionPlayTonesAll = (EVoiceRecognitionPlayTonesRecStart | EVoiceRecognitionPlayTonesRecEnd )
};

// 枚举 - 调用启动语音识别，返回结果（startVoiceRecognition）
enum TVoiceRecognitionStartWorkResult
{
    EVoiceRecognitionStartWorking = 2000,                    // 开始工作
    EVoiceRecognitionStartWorkNOMicrophonePermission,        // 没有麦克风权限
    EVoiceRecognitionStartWorkNoAPIKEY,                      // 没有设定应用API KEY
    EVoiceRecognitionStartWorkGetAccessTokenFailed,          // 获取accessToken失败
    EVoiceRecognitionStartWorkNetUnusable,                   // 当前网络不可用
    EVoiceRecognitionStartWorkDelegateInvaild,               // 没有实现MVoiceRecognitionClientDelegate中VoiceRecognitionClientWorkStatus方法,或传入的对像为空
    EVoiceRecognitionStartWorkRecorderUnusable,              // 录音设备不可用
    EVoiceRecognitionStartWorkPreModelError,                 // 启动预处理模块出错
    EVoiceRecognitionStartWorkPropertyInvalid,               // 设置的识别属性无效
};

// 枚举 - 设置识别语言
enum TVoiceRecognitionLanguage
{
    EVoiceRecognitionLanguageChinese = 0,
    EVoiceRecognitionLanguageCantonese,
    EVoiceRecognitionLanguageEnglish,
};

// @protocol - MVoiceRecognitionClientDelegate
// @brief - 语音识别工作状态通知
@protocol MVoiceRecognitionClientDelegate<NSObject>
@optional

- (void)VoiceRecognitionClientWorkStatus:(int) aStatus obj:(id)aObj;              //aStatus TVoiceRecognitionClientWorkStatus

- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus;//aStatus TVoiceRecognitionClientErrorStatusClass;aSubStatus TVoiceRecognitionClientErrorStatus

- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus;                        //aStatus TVoiceRecognitionClientNetWorkStatus

@end // MVoiceRecognitionClientDelegate

@interface BDVoiceRecognitionClient : NSObject
//－－－－－－－－－－－－－－－－－－－类方法－－－－－－－－－－－－－－－－－－－－－－－－
// 创建语音识别客户对像，该对像是个单例
+ (BDVoiceRecognitionClient *)sharedInstance;

// 释放语音识别客户端对像
+ (void)releaseInstance;


//－－－－－－－－－－－－－－－－－－－识别方法－－－－－－－－－－－－－－－－－－－－－－－
// 判断是否可以录音
- (BOOL)isCanRecorder;

// 开始语音识别，需要实现MVoiceRecognitionClientDelegate代理方法，并传入实现对像监听事件
// 返回值参考 TVoiceRecognitionStartWorkResult
- (int)startVoiceRecognition:(id<MVoiceRecognitionClientDelegate>)aDelegate;

// 说完了，用户主动完成录音时调用
- (void)speakFinish;

// 结束本次语音识别
- (void)stopVoiceRecognition;

/**
 * @brief 获取当前识别的采样率
 *
 * @return 采样率(16000/8000)
 */
- (int)getCurrentSampleRate;

/**
 * @brief 得到当前识别模式(deprecated)
 *
 * @return 当前识别模式
 */
- (int)getCurrentVoiceRecognitionMode __attribute__((deprecated));

/**
 * @brief 设置当前识别模式(deprecated)，请使用-(void)setProperty:(TBDVoiceRecognitionProperty)property;
 *
 * @param 识别模式
 *
 * @return 是否设置成功
 */
- (void)setCurrentVoiceRecognitionMode:(int)aMode __attribute__((deprecated));

// 设置识别类型
- (void)setProperty:(TBDVoiceRecognitionProperty)property __attribute__((deprecated));

// 获取当前识别类型
- (int)getRecognitionProperty __attribute__((deprecated));

// 设置识别类型列表, 除EVoiceRecognitionPropertyInput和EVoiceRecognitionPropertySong外
// 可以识别类型复合
- (void)setPropertyList: (NSArray*)prop_list;

// cityID仅对EVoiceRecognitionPropertyMap识别类型有效
- (void)setCityID: (NSInteger)cityID;

// 获取当前识别类型列表
- (NSArray*)getRecognitionPropertyList;

//－－－－－－－－－－－－－－－－－－－提示音－－－－－－－－－－－－－－－－－－－－－－－
// 播放提示音，默认为播放,录音开始，录音结束提示音
// BDVoiceRecognitionClientResources/Tone
// record_start.caf   录音开始声音文件
// record_end.caf     录音结束声音文件
// 声音资源需要加到项目工程里，用户可替换资源文件，文件名不可以变，建音提示音不宜过长，0。5秒左右。
// aTone 取值参考 TVoiceRecognitionPlayTones，如没有找到文件，则返回ＮＯ
- (BOOL)setPlayTone:(int)aTone isPlay:(BOOL)aIsPlay;


//－－－－－－－－－－－－－－－－－－－音源信息－－－－－－－－－－－－－－－－－－－－－－－
// 监听当前音量级别，如果在工作状态设定，返回结果为ＮＯ ，且本次调用无效
- (BOOL)listenCurrentDBLevelMeter;

// 获取当前音量级别，取值需要考虑全平台
- (int)getCurrentDBLevelMeter;

// 取消监听音量级别
- (void)cancelListenCurrentDBLevelMeter;


//－－－－－－－－－－－－－－－－－－－产品相关－－－－－－－－－－－－－－－－－－－－－－－
// 如果与百度语音技术部有直接合作关系，才需要考虑此方法，否则请使用setApiKey:withSecretKey:方法
- (void)setProductId:(NSString *)aProductId;

// 如果与百度语音技术部有直接合作关系，才需要考虑此方法，否则请勿随意设置服务器地址
// 根据识别类型选择mode，EVoiceRecognitionPropertyInput请传入EVoiceRecognitionPropertyInput
// 其余传入EVoiceRecognitionPropertySearch即可
// 从下一次识别开始生效
- (void)setServerURL:(NSString *)url withMode:(int)mode;

//- - - - - - - - - - - - - - - -功能设置- - - - - - - - - - - - - - - - - - - -
// 定制功能
// 定制语义解析功能请传入key=BDVR_CONFIG_KEY_NEED_NLU，如果开启此功能，将返回带语义的json串，含义详见开发文档说明
#define BDVR_CONFIG_KEY_NEED_NLU @"nlu"
// 定制通讯录识别功能请传入key=BDVR_CONFIG_KEY_ENABLE_CONTACTS，如果开启此功能，将优先返回通讯录识别结果
#define BDVR_CONFIG_KEY_ENABLE_CONTACTS @"enable_contacts"
// 定制SDK是否对AudioSession进行操作，如果外部需要操作AudioSession，应当通过此接口禁止SDK对AudioSession进行操作
#define BDVR_CONFIG_KEY_DISABLE_AUDIO_SESSION_CONTROL @"disable_audio_session_control"
- (void)setConfig:(NSString *)key withFlag:(BOOL)flag;

// 设置识别语言，有效值参见枚举类型TVoiceRecognitionLanguage
- (void)setLanguage:(int)language;

//－－－－－－－－－－－－－－－－－－－开发者身份验证－－－－－－－－－－－－－－－－－－－－
// 设置开发者申请的api key和secret key
- (void)setApiKey:(NSString *)apiKey withSecretKey:(NSString *)secretKey;

//－－－－－－－－－－－－－－－－－－－浏览器标识设置－－－－－－－－－－－－－－－－－－－－
// 设置浏览器标识，资源返回时会根据UA适配
// userAgent参数可通过[UIWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]获取
- (void)setBrowserUa:(NSString *)userAgent;

//－－－－－－－－－－－－－－－－－－－更新地理位置信息－－－－－－－－－－－－－－－－－－－－
// 更新当前地理位置信息，与地理位置相关的资源会优先返回附近资源信息
// 请传入通过GPS获取到的经纬度数据
- (void)updateLocation:(CLLocation *)location;

//- - - - - - - - - - - - - - - -其他参数设置- - - - - - - - - - - - - - - - - -
// 设置params，每次识别开始前都需要进行设置，目前支持如下参数：
#define BDVR_PARAM_KEY_TEXT @"txt" // 上传文本，如果设置了该字段，将略过语音输入和识别阶段
#define BDVR_PARAM_KEY_OTHER_PARAM @"pam" // 其他参数
#define BDVR_PARAM_KEY_STATISTICS @"stc" // 统计信息
#define BDVR_PARAM_KEY_LIGHT_APP_UID @"ltp" // 轻应用参数(uid)
#define BDVR_PARAM_KEY_USER_AGENT @"user-agent" // UA
- (void)setParamForKey:(NSString *)key withValue:(NSString *)value;

// 关闭标点
- (void)disablePuncs:(BOOL)flag;

// 枚举 - 语音识别请求资源类型
typedef enum TBDVoiceRecognitionResourceType
{
    RESOURCE_TYPE_DEFAULT = -1,
    RESOURCE_TYPE_NONE = 0,     // 纯语音识别结果
    RESOURCE_TYPE_NLU = 1,      // 语义解析结果
    RESOURCE_TYPE_WISE = 2,     // wise结果
    RESOURCE_TYPE_WISE_NLU = 3, // 语义和wise结果
    RESOURCE_TYPE_POST = 4,     // 后处理结果
    RESOURCE_TYPE_AUDIO_DA = 8, // audio_da
} TBDVoiceRecognitionResourceType;

- (void)setResourceType:(TBDVoiceRecognitionResourceType)resourceType;

// 设置是否需要对录音数据进行端点检测
- (void)setNeedVadFlag: (BOOL)flag;

// 设置是否需要对录音数据进行压缩
- (void)setNeedCompressFlag: (BOOL)flag;

//－－－－－－－－－－－－－－－－－－－版本号－－－－－－－－－－－－－－－－－－－－－－－－
// 获取版本号
- (NSString*)libVer;

@end
