//
//  ChatroomTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/4.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "BaseMessageTableViewCell.h"
#import "DateUtil.h"
#import "InsetsTextField.h"
#import "Masonry/Masonry/Masonry.h"
#import "Messages.h"

static NSInteger const kAvatarSize = 40;
static NSInteger const kAvatarMarginH = 10;

@interface
BaseMessageTableViewCell ()
@property (strong, nonatomic) InsetsTextField* sendTimeField;
@property (strong, nonatomic) UIImageView* avatarImageView;
@end

@implementation BaseMessageTableViewCell
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.alignement = [reuseIdentifier isEqualToString:kCellIdentifierLeft]
                            ? MessageAlignementLeft
                            : MessageAlignementRight;

        [self buildCell];
        [self bindConstraints];
        [self bindGestureRecognizer];
    }
    return self;
}
- (void)setModel:(Messages*)model
{
    /*
   NMB啊，在setModel的时候才调用buildCell或bindConstraints的话
   尼玛systemFittingSize是算不出大小的
   */
    _model = model;

    [self updateConstraints];
}

- (void)buildCell
{
    self.sendTimeField = [[InsetsTextField alloc] init];
    self.sendTimeField.backgroundColor = [UIColor colorWithWhite:.83 alpha:1];
    self.sendTimeField.opaque = true;
    self.sendTimeField.textColor = [UIColor whiteColor];
    self.sendTimeField.font = [UIFont systemFontOfSize:12];
    self.sendTimeField.textAlignment = NSTextAlignmentCenter;
    self.sendTimeField.layer.cornerRadius = 5;
    self.sendTimeField.textFieldInset = CGPointMake(3, 3);
    self.sendTimeField.userInteractionEnabled = false;
    [self.contentView addSubview:self.sendTimeField];

    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = self.alignement == MessageAlignementRight
                                   ? [UIImage imageNamed:@"siegrain_avatar"]
                                   : [UIImage imageNamed:@"robot"];
    [self.contentView addSubview:self.avatarImageView];

    self.bubbleView = [[UIImageView alloc] init];
    self.bubbleView.userInteractionEnabled = true;
    UIImage* bubbleImage = self.alignement == MessageAlignementRight
                             ? [UIImage imageNamed:@"SenderTextNodeBkg"]
                             : [UIImage imageNamed:@"ReceiverTextNodeBkgHL"];

    //设置图片哪里是不能被拉伸的
    self.bubbleView.image =
      [bubbleImage stretchableImageWithLeftCapWidth:30
                                       topCapHeight:30];
    [self.contentView addSubview:self.bubbleView];
}

- (void)bindConstraints
{
    __weak typeof(self) weakSelf = self;
    [self.sendTimeField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(weakSelf.avatarImageView.mas_top).offset(-10);
        make.centerX.offset(0);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.offset(0);
        make.width.height.offset(kAvatarSize);
        if (weakSelf.alignement == MessageAlignementLeft)
            make.leading.offset(kAvatarMarginH);
        else
            make.trailing.offset(-kAvatarMarginH);
    }];
    [self.bubbleView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.avatarImageView).offset(-2);
        make.width.lessThanOrEqualTo(weakSelf.contentView);

        if (self.alignement == MessageAlignementLeft) {
            //指view的左边在avatar的右边，边距为5
            make.left.equalTo(weakSelf.avatarImageView.mas_right).offset(5);
            make.right.lessThanOrEqualTo(weakSelf.contentView).offset(-50);
        } else {
            make.right.equalTo(weakSelf.avatarImageView.mas_left).offset(-5);
            make.left.greaterThanOrEqualTo(weakSelf.contentView).offset(50);
        }

        /*惯例*/
        make.bottom.offset(-5).priorityLow();
    }];
}
- (void)updateConstraints
{
    /*
	 一定要两个判断都修改约束，不然就要多弄几个标识符...
	 */
    if (self.model.showSendTime) {
        self.sendTimeField.text =
          [DateUtil localizedShortDateStringFromInterval:self.model.sendTime];
        self.sendTimeField.hidden = false;
        [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.top.offset(40);
        }];
    } else {
        self.sendTimeField.hidden = true;
        [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.top.offset(5);
        }];
    }

    [super updateConstraints];
}
#pragma mark - gesture
- (void)bindGestureRecognizer
{
    UILongPressGestureRecognizer* bubblelongPress =
      [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(longPressOnBubble:)];
    [self.bubbleView addGestureRecognizer:bubblelongPress];
}

- (void)longPressOnBubble:(UILongPressGestureRecognizer*)press
{
}
#pragma mark -
- (BOOL)canBecomeFirstResponder
{
    return true;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return false;
}
@end
