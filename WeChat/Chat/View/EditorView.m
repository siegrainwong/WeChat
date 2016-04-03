//
//  EditorView.m
//  WeChat
//
//  Created by Siegrain on 16/4/3.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "EditorView.h"

@interface
EditorView ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton* voiceButton;
@property (strong, nonatomic) IBOutlet UIButton* emotionButton;
@property (strong, nonatomic) IBOutlet UIButton* additionalButton;
@property (strong, nonatomic) IBOutlet UITextView* textView;
@end

@implementation EditorView
#pragma mark - dealloc
- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - init
+ (instancetype)editor
{
  return
    [[[NSBundle mainBundle] loadNibNamed:@"EditorView" owner:nil options:nil]
      lastObject];
}
- (void)awakeFromNib
{
  self.backgroundColor = [UIColor colorWithRed:250 / 255.0
                                         green:250 / 255.0
                                          blue:250 / 255.0
                                         alpha:1];
  self.layer.borderWidth = 0.5;
  self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;

  self.textView.layer.borderWidth = 1;
  self.textView.layer.cornerRadius = 3;
  self.textView.layer.borderColor =
    [UIColor colorWithWhite:0 alpha:0.1].CGColor;

  [self appendKeyboardNotifications];
}

#pragma mark - textview delegate
- (BOOL)textView:(UITextView*)textView
  shouldChangeTextInRange:(NSRange)range
          replacementText:(NSString*)text
{
  if ([text isEqualToString:@"\n"])
    if (self.messageWasSend)
      self.messageWasSend(text, ChatMessageTypeText);

  return false;
}

#pragma mark - keyboard notifications
- (void)appendKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter]
    addObserver:self

       selector:@selector(keyboardWasShown:)
           name:UIKeyboardWillShowNotification
         object:nil];

  [[NSNotificationCenter defaultCenter]
    addObserver:self

       selector:@selector(keyboardWillBeHidden:)

           name:UIKeyboardWillHideNotification
         object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];

  CGSize keyboardSize =
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

  CGFloat duration =
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

  NSInteger animCurveKey =
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

  if (self.keyboardWasShown)
    self.keyboardWasShown(animCurveKey, duration, keyboardSize);
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];

  CGSize keyboardSize =
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

  CGFloat duration =
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

  NSInteger animCurveKey =
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

  if (self.keyboardWillBeHidden)
    self.keyboardWillBeHidden(animCurveKey, duration, keyboardSize);
}
@end