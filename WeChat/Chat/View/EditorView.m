//
//  EditorView.m
//  WeChat
//
//  Created by Siegrain on 16/4/3.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "EditorView.h"

@interface
EditorView ()
@property (strong, nonatomic) IBOutlet UIButton* voiceButton;
@property (strong, nonatomic) IBOutlet UIButton* emotionButton;
@property (strong, nonatomic) IBOutlet UIButton* additionalButton;
@property (strong, nonatomic) IBOutlet UITextView* textView;

@end

@implementation EditorView
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
}
+ (instancetype)editor
{
  return
    [[[NSBundle mainBundle] loadNibNamed:@"EditorView" owner:nil options:nil]
      lastObject];
}
@end