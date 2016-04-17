//
//  ChatroomTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ChatModel.h"
#import "DateUtil.h"
#import "InsetsTextField.h"
#import "Masonry/Masonry/Masonry.h"
#import "TextMessageTableViewCell.h"

@interface
TextMessageTableViewCell ()
@property (strong, nonatomic) UITextView* messageTextView;
@end

@implementation TextMessageTableViewCell
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString*)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  }
  return self;
}
- (void)setModel:(ChatModel*)model
{
  self.messageTextView.text = (NSString*)model.message;

  [super setModel:model];
}

- (void)buildCell
{
  [super buildCell];

  self.messageTextView = [[UITextView alloc] init];
  self.messageTextView.backgroundColor = [UIColor clearColor];
  self.messageTextView.font = [UIFont systemFontOfSize:16];
  self.messageTextView.editable = false;
  self.messageTextView.scrollEnabled = false;
  self.messageTextView.selectable = false;
  [super.bubbleView addSubview:self.messageTextView];
}

- (void)bindConstraints
{
  [super bindConstraints];

  [self.messageTextView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.edges.insets(UIEdgeInsetsMake(5, 13, 10, 15));
  }];
}
#pragma mark - longpress menu
- (void)longPressOnBubble:(UILongPressGestureRecognizer*)press
{
  if (press.state == UIGestureRecognizerStateBegan) {
    [self becomeFirstResponder];

    super.bubbleView.highlighted = YES;

    UIMenuItem* copy =
      [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopy:)];
    UIMenuItem* remove =
      [[UIMenuItem alloc] initWithTitle:@"删除"
                                 action:@selector(menuRemove:)];

    UIMenuController* menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[ copy, remove ]];
    [menu setTargetRect:super.bubbleView.frame inView:self];
    [menu setMenuVisible:YES animated:YES];

    [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(UIMenuControllerWillHideMenu)
             name:UIMenuControllerWillHideMenuNotification
           object:nil];
  }
}

- (void)UIMenuControllerWillHideMenu
{
  super.bubbleView.highlighted = NO;

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
  return (action == @selector(menuCopy:) || action == @selector(menuRemove:));
}

- (void)menuCopy:(id)sender
{
  [UIPasteboard generalPasteboard].string = self.messageTextView.text;
}

- (void)menuRemove:(id)sender
{
}
@end
