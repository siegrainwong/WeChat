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

typedef NS_ENUM(NSUInteger, ChatroomCellAlignement) {
  ChatroomCellAlignementUndefined,
  ChatroomCellAlignementLeft,
  ChatroomCellAlignementRight
};

static NSInteger const kAvatarSize = 40;
static NSInteger const kAvatarMarginH = 10;

@interface
ChatroomTableViewCell ()
@property (assign, nonatomic) ChatroomCellAlignement alignement;

@property (strong, nonatomic) UIImageView* bubbleView;
@property (strong, nonatomic) UIImageView* avatarImageView;
@property (strong, nonatomic) UITextView* messageTextView;
@property (strong, nonatomic) UILabel* messageLabel;
@end

@implementation ChatroomTableViewCell
#pragma mark - init
- (ChatroomCellAlignement)alignement
{
  if (_alignement == ChatroomCellAlignementUndefined) {
    _alignement = arc4random() % 2 == 0 ? ChatroomCellAlignementLeft
                                        : ChatroomCellAlignementRight;
  }
  return _alignement;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString*)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    [self buildCell];
    [self bindConstraints];
  }
  return self;
}
- (void)setModel:(ChatModel*)model
{
  /*
   NMB啊，在setModel的时候才调用buildCell或bindConstraints的话
   尼玛systemFittingSize是算不出大小的
   尼玛啊。
   你麻痹吧。。。

         还有啊，尼玛不能在这里判断model !=
   nil就return，那样只能算出第一行的高度
         卧槽尼玛。
   */
  _model = model;
  self.messageTextView.text = (NSString*)model.message;
  self.messageLabel.text = (NSString*)model.message;

  self.avatarImageView.image = self.alignement == ChatroomCellAlignementRight
                                 ? [UIImage imageNamed:@"siegrain_avatar"]
                                 : [UIImage imageNamed:@"robot"];

  UIImage* bubbleImage = self.alignement == ChatroomCellAlignementRight
                           ? [UIImage imageNamed:@"SenderTextNodeBkg"]
                           : [UIImage imageNamed:@"ReceiverTextNodeBkgHL"];
  //设置图片有哪些地方是不能被拉伸的，以像素为单位
  UIEdgeInsets insets = UIEdgeInsetsMake(30, 15, 30, 15);
  bubbleImage = [bubbleImage resizableImageWithCapInsets:insets];
  self.bubbleView.image = bubbleImage;
}

- (void)buildCell
{
  self.avatarImageView = [[UIImageView alloc] init];
  [self.contentView addSubview:self.avatarImageView];

  self.bubbleView = [[UIImageView alloc] init];
  self.bubbleView.userInteractionEnabled = true;
  [self.contentView addSubview:self.bubbleView];

  self.messageTextView = [[UITextView alloc] init];
  self.messageTextView.backgroundColor = [UIColor clearColor];
  self.messageTextView.font = [UIFont systemFontOfSize:16];
  self.messageTextView.editable = false;
  self.messageTextView.scrollEnabled = false;
  [self.bubbleView addSubview:self.messageTextView];
}
- (void)bindConstraints
{
  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.top.offset(5);
    make.width.height.offset(kAvatarSize);
    if (self.alignement == ChatroomCellAlignementLeft) {
      make.left.offset(kAvatarMarginH);
    } else {
      make.right.offset(-kAvatarMarginH);
    }
  }];
  [self.bubbleView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.top.offset(3);
    make.bottom.offset(-5);
    if (self.alignement == ChatroomCellAlignementLeft) {
      //指view的左边在avatar的右边，边距为5
      make.left.equalTo(self.avatarImageView.mas_right).offset(5);
      make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-100);
    } else {
      make.right.equalTo(self.avatarImageView.mas_left).offset(-5);
      make.left.greaterThanOrEqualTo(self.contentView.mas_left).offset(100);
    }
  }];
  [self.messageTextView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.edges.insets(UIEdgeInsetsMake(5, 15, 10, 10));
  }];
}
@end
