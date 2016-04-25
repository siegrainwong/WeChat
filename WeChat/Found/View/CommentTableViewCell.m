//
//  CommentTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/25.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "Masonry/Masonry/Masonry.h"
#import "TTTAttributedLabel/TTTAttributedLabel/TTTAttributedLabel.h"
#import "WeChatHelper.h"

@interface
CommentTableViewCell ()
@property (strong, nonatomic) TTTAttributedLabel* label;

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

    NSString* namePart = [NSString stringWithFormat:@"%@: ", name];
    self.label.text = [NSString stringWithFormat:@"%@%@", namePart, content];
    NSRange nameRange = [self.label.text rangeOfString:namePart];
    if (nameRange.location != NSNotFound)
        [self.label addLinkToURL:[NSURL URLWithString:name] withRange:nameRange];

    [self.label sizeToFit];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)buildCell
{
    self.label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = kCTLineBreakByCharWrapping;
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.linkAttributes = @{ (NSString*)kCTForegroundColorAttributeName : [WeChatHelper wechatFontColor] };
    [self.contentView addSubview:self.label];
}
- (void)bindConstraints
{
    [self.label mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(1, 5, 1, 5));
    }];
}
@end
