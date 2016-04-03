//
//  EditorView.h
//  WeChat
//
//  Created by Siegrain on 16/4/3.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChatMessageType) {
  /* 文本信息 */
  ChatMessageTypeText,
  /* 图片信息 */
  ChatMessageTypeImage,
  /* 语音信息 */
  ChatMessageTypeVoice
};

@interface EditorView : UIView
+ (instancetype)editor;

@property (nonatomic, copy) void (^keyboardWasShown)
  (NSInteger animCurveKey, CGFloat duration, CGSize keyboardSize);
@property (nonatomic, copy) void (^keyboardWillBeHidden)
  (NSInteger animCurveKey, CGFloat duration, CGSize keyboardSize);
@property (nonatomic, copy) void (^messageWasSend)
  (id message, ChatMessageType type);
@end
