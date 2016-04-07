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

    [self buildCell];
    [self bindConstraints];
  }
  return self;
}
- (void)setModel:(ChatModel*)model
{
  [super setModel:model];

  self.messageTextView.text = (NSString*)model.message;
}

- (void)buildCell
{
  [super buildCell];

  self.messageTextView = [[UITextView alloc] init];
  self.messageTextView.backgroundColor = [UIColor clearColor];
  self.messageTextView.font = [UIFont systemFontOfSize:16];
  self.messageTextView.editable = false;
  self.messageTextView.scrollEnabled = false;
  [super.bubbleView addSubview:self.messageTextView];
}

- (void)bindConstraints
{
  [super bindConstraints];

  [self.messageTextView mas_makeConstraints:^(MASConstraintMaker* make) {
    make.edges.insets(UIEdgeInsetsMake(5, 15, 10, 10));
  }];
}
#pragma mark -
@end
