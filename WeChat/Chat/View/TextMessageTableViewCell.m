//
//  ChatroomTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "DateUtil.h"
#import "InsetsTextField.h"
#import "Masonry/Masonry/Masonry.h"
#import "Messages.h"
#import "TTTAttributedLabel/TTTAttributedLabel/TTTAttributedLabel.h"
#import "TextMessageTableViewCell.h"

static UIFont* textFont;

@interface
TextMessageTableViewCell ()
/*
 不能用textView，就算关了用户交互和编辑滚动也还是比UILabel卡。
 当初不用Label就是因为它没有垂直对齐的方式才放弃的，现在只有用第三方了。
 */
//@property (strong, nonatomic) UITextView* messageTextView;
@property (strong, nonatomic) TTTAttributedLabel* messageLabel;
@end

@implementation TextMessageTableViewCell
#pragma mark - init
+ (void)initialize
{
  textFont = [UIFont systemFontOfSize:16];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString*)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  }
  return self;
}
- (void)setModel:(Messages*)model
{
  self.messageLabel.text = (NSString*)model.message;

  [super setModel:model];
}

- (void)buildCell
{
  [super buildCell];

  self.messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
  self.messageLabel.backgroundColor = [UIColor clearColor];
  self.messageLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
  self.messageLabel.font = textFont;
  self.messageLabel.numberOfLines = 0;
  [super.bubbleView addSubview:self.messageLabel];
}

- (void)bindConstraints
{
  [super bindConstraints];

  [self.messageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
    make.top.offset(13);
    make.left.offset(20);
    make.right.offset(-20);
    make.bottom.greaterThanOrEqualTo(super.bubbleView).offset(20);
    /*下边距不能定死，定死要报错*/
    // make.edges.insets(UIEdgeInsetsMake(13, 20, 20, 20));
  }];
}
#pragma mark - longpress on bubble
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
  [UIPasteboard generalPasteboard].string = self.messageLabel.text;
}

- (void)menuRemove:(id)sender
{
}
@end
