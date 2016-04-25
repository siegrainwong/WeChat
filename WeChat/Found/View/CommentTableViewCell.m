//
//  CommentTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/25.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Comment.h"
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
    }
    return self;
}
- (void)setModel:(Comment*)model
{
    _model = model;

    NSString* str = [NSString stringWithFormat:@"%@: %@", model.name, model.content];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[WeChatHelper wechatFontColor]
                    range:NSMakeRange(0, model.name.length)];
    self.label.attributedText = attrStr;

    CGSize size = [self.label sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    self.label.frame = CGRectMake(2, 1, size.width, size.height);
}
- (void)buildCell
{
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByCharWrapping;
    self.label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.label];
}
- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = self.label.frame.size.height;
    return CGSizeMake(self.frame.size.width, height);
}
@end
