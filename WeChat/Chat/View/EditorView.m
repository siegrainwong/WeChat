//
//  EditorView.m
//  WeChat
//
//  Created by Siegrain on 16/4/3.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ChatroomViewController.h"
#import "EditorView.h"
#import "Masonry/Masonry/Masonry.h"

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
  self.textView.delegate = self;

  [self appendKeyboardNotifications];
}

#pragma mark - textview delegate
/*根据textView的行数调整视图高度*/
- (void)textViewDidChange:(UITextView*)textView
{
  NSInteger lineHeight = self.textView.font.lineHeight;
  NSInteger lineCount = (NSInteger)(textView.contentSize.height / lineHeight);
  if (lineCount > 5)
    return;

  NSInteger increase = (lineCount - 1) * lineHeight;
  [self mas_updateConstraints:^(MASConstraintMaker* make) {
    make.height.offset([ChatroomViewController EditorHeight] + increase);
  }];
  [UIView animateWithDuration:.3
                   animations:^{
                     [self.superview layoutIfNeeded];
                   }];
}
- (BOOL)textView:(UITextView*)textView
  shouldChangeTextInRange:(NSRange)range
          replacementText:(NSString*)text
{
  //点击发送
  if ([text isEqualToString:@"\n"])
    if (self.messageWasSend) {
      self.messageWasSend(text, ChatMessageTypeText);
			self.textView.text = @"";
      return false;
    }

  return true;
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