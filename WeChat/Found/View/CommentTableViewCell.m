//
//  CommentTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/25.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "Masonry/Masonry/Masonry.h"
#import "WeChatHelper.h"

@interface
CommentTableViewCell ()
/*
 TTTAttributedLabel的lineBreakMode有Bug
 设置为NSLineBreakByCharWrapping无效
 */
@property (strong, nonatomic) UILabel* label;

@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* content;
@end

@implementation CommentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        [self buildCell];
        [self bindConstraints];
    }
    return self;
}
- (void)cellDataWithName:(NSString*)name andContent:(NSString*)content
{
    if (_name != nil) return;

    _name = name;
    _content = content;

    NSString* str = [NSString stringWithFormat:@"%@: %@", name, content];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[WeChatHelper wechatFontColor] range:NSMakeRange(0, name.length)];
    self.label.attributedText = attrStr;

    [self.label sizeToFit];
}
- (void)buildCell
{
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByCharWrapping;
    self.label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.label];
}
- (void)bindConstraints
{
    self.label.preferredMaxLayoutWidth = self.frame.size.width;
    [self.label mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(1, 5, 1, 5));
    }];

    [self.label setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
}
@end
