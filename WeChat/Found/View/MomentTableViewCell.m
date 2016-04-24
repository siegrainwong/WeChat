//
//  MomentTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "IDMPhotoBrowser/Classes/IDMPhotoBrowser.h"
#import "Masonry/Masonry/Masonry.h"
#import "Moment.h"
#import "MomentTableViewCell.h"
#import "TTTAttributedLabel/TTTAttributedLabel/TTTAttributedLabel.h"

@interface
MomentTableViewCell ()
@property (strong, nonatomic) UIImageView* avatarImageView;
@property (strong, nonatomic) TTTAttributedLabel* nameLabel;
@property (strong, nonatomic) TTTAttributedLabel* contentLabel;
@property (strong, nonatomic) IDMPhotoBrowser* photoBrowser;
@end

@implementation MomentTableViewCell
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildCell];
        [self bindConstraints];
    }
    return self;
}
- (void)setModel:(Moment*)model
{
    _model = model;

    self.avatarImageView.image = model.avatar;
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.content;

    //    __block NSMutableArray* idmPhotos = [NSMutableArray array];
    //    [model.pictures enumerateObjectsUsingBlock:^(UIImage* obj, NSUInteger idx, BOOL* _Nonnull stop) {
    //      [idmPhotos addObject:[IDMPhoto photoWithImage:obj]];
    //    }];
}

#pragma mark - build
- (void)buildCell
{
    self.avatarImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avatarImageView];

    self.nameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:1];
    self.nameLabel.font = [UIFont systemFontOfSize:15 weight:0.2];
    self.nameLabel.verticalAlignment = UIControlContentVerticalAlignmentTop;
    [self.contentView addSubview:self.nameLabel];

    self.contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.contentLabel];
}

- (void)bindConstraints
{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.offset(10);
        make.width.height.offset(40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        //        make.height.offset(30);

        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.avatarImageView);
        make.right.offset(-10);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.nameLabel);
        make.bottom.offset(-10);
    }];
}
@end
