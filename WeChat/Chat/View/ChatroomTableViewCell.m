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

static NSInteger const kAvatarSize = 36;
static NSInteger const kAvatarMarginH = 10;

typedef NS_ENUM(NSUInteger, ChatroomCellAlignement) {
  ChatroomCellAlignementLeft,
  ChatroomCellAlignementRight
};

@interface
ChatroomTableViewCell ()
@property (strong, nonatomic) UIImageView* avatarImageView;
@property (assign, nonatomic) ChatroomCellAlignement alignement;
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
}
@end
