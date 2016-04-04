//
//  ChatroomTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ChatModel.h"
#import "ChatroomTableViewCell.h"
#import "Masonry/Masonry/Masonry.h"

static NSInteger const kAvatarSize = 60;
static NSInteger const kAvatarMarginH = 10;
static NSInteger const kBubbleCompensateWidth = 35;
static NSInteger const kBubbleCompensateHeight = 25;

typedef NS_ENUM(NSUInteger, ChatroomCellAlignement) {
  ChatroomCellAlignementLeft,
  ChatroomCellAlignementRight
};

@interface
ChatroomTableViewCell ()
@property (assign, nonatomic) ChatroomCellAlignement alignement;

@property (strong, nonatomic) UIImageView* bubbleView;
@property (strong, nonatomic) UIImageView* avatarImageView;
@property (strong, nonatomic) UITextView* messageTextView;
@end

@implementation ChatroomTableViewCell
#pragma mark - accessors
- (ChatroomCellAlignement)alignement
{
  return self.model.identifier == 1 ? ChatroomCellAlignementRight
                                    : ChatroomCellAlignementLeft;
}
- (void)setModel:(ChatModel*)model
{
  if (_model != nil)
    return;

  _model = model;

  [self buildCell];
  [self bindConstraints];
}
#pragma mark - init
+ (instancetype)chatCellWithModel:(ChatModel*)model
{
  ChatroomTableViewCell* cell = [[self alloc] init];
  cell.model = model;

  return cell;
}

- (void)buildCell
{
  self.avatarImageView = [[UIImageView alloc] init];
  self.avatarImageView.image = self.alignement == ChatroomCellAlignementRight
                                 ? [UIImage imageNamed:@"siegrain_avatar"]
                                 : [UIImage imageNamed:@"robot"];
  [self addSubview:self.avatarImageView];

  self.bubbleView = [[UIImageView alloc] init];
  UIImage* bubbleImage = self.alignement == ChatroomCellAlignementRight
                           ? [UIImage imageNamed:@"SenderTextNodeBkg"]
                           : [UIImage imageNamed:@"ReceiverTextNodeBkgHL"];
  //设置图片有哪些地方是不能被拉伸的，以像素为单位
  UIEdgeInsets insets = UIEdgeInsetsMake(30, 15, 30, 15);
  bubbleImage = [bubbleImage resizableImageWithCapInsets:insets];
  self.bubbleView.image = bubbleImage;
  self.bubbleView.userInteractionEnabled = true;
  [self addSubview:self.bubbleView];

  self.messageTextView = [[UITextView alloc] init];
  self.messageTextView.backgroundColor = [UIColor clearColor];
  self.messageTextView.text = self.model.message;
  self.messageTextView.font = [UIFont systemFontOfSize:15];
  self.messageTextView.editable = false;
  self.messageTextView.scrollEnabled = false;
  [self.bubbleView addSubview:self.messageTextView];
}
- (void)bindConstraints
{
  __weak typeof(self) weakSelf = self;
  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.top.offset(5);
    make.width.height.offset(kAvatarSize);
    if (weakSelf.alignement == ChatroomCellAlignementLeft) {
      make.leading.offset(kAvatarMarginH);
    } else {
      make.trailing.offset(kAvatarMarginH);
    }
  }];
  [self.bubbleView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.top.offset(4);
    if (weakSelf.alignement == ChatroomCellAlignementLeft) {
      //指view的左边在avatar的右边，边距为5
      make.leading.equalTo(weakSelf.avatarImageView.mas_right).offset(5);
    } else {
      make.trailing.equalTo(weakSelf.avatarImageView.mas_left).offset(5);
    }

    CGRect textRect = [weakSelf.messageTextView.text
      boundingRectWithSize:CGSizeMake(300, MAXFLOAT)
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:@{
                  NSFontAttributeName : weakSelf.messageTextView.font
                }
                   context:nil];

    make.width.offset(textRect.size.width + kBubbleCompensateWidth);
    make.height.offset(textRect.size.height + kBubbleCompensateHeight);
  }];
  [self.messageTextView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.size.equalTo(weakSelf.bubbleView);
    make.top.offset(0);
    make.left.offset(10);
  }];
}
@end
