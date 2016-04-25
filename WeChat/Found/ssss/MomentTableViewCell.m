//
//  MomentTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "CommentTableViewController.h"
#import "Masonry/Masonry/Masonry.h"
#import "Moment.h"
#import "MomentTableViewCell.h"
#import "PhotosCollectionViewController.h"
#import "TTTAttributedLabel/TTTAttributedLabel/TTTAttributedLabel.h"
#import "WeChatHelper.h"

static NSString* const kBlogLink = @"http://siegrain.wang";
static NSString* const kGithubLink = @"https://github.com/Seanwong933";

@interface
MomentTableViewCell ()<TTTAttributedLabelDelegate>
@property (strong, nonatomic) UIImageView* avatarImageView;
@property (strong, nonatomic) TTTAttributedLabel* nameLabel;
@property (strong, nonatomic) TTTAttributedLabel* contentLabel;
@property (strong, nonatomic) PhotosCollectionViewController* photosController;
@property (strong, nonatomic) UILabel* timeLabel;
@property (strong, nonatomic) UIImageView* likeCommentLogoView;

@property (strong, nonatomic) UIImageView* commentsBubbleView;
@property (strong, nonatomic) CommentTableViewController* commentsController;
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
    self.photosController.photosArray = model.pictures;
    self.photosController.parentCellIndexPath = model.indexPath;
    self.timeLabel.text = @"1分钟前";
    self.commentsController.comments = model.comments;

    //高亮链接
    if ([model.name isEqualToString:@"Siegrain Wong"]) {
        NSRange blogRange = [model.content rangeOfString:kBlogLink];
        NSRange githubRange = [model.content rangeOfString:kGithubLink];

        if (blogRange.location != NSNotFound)
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kBlogLink] withRange:blogRange];
        if (githubRange.location != NSNotFound)
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kGithubLink] withRange:githubRange];
    }

    //获取CollectionView的高度
    [self.photosController.collectionView mas_updateConstraints:^(MASConstraintMaker* make) {
        CGSize size = self.photosController.collectionView.collectionViewLayout.collectionViewContentSize;
        make.height.offset(size.height);
    }];

    if (model.comments.count > 0) {
        [self.commentsBubbleView mas_updateConstraints:^(MASConstraintMaker* make) {
            CGSize size = self.commentsController.tableView.contentSize;
            make.height.offset(size.height + 15);
        }];
    } else {
        [self.commentsBubbleView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.offset(0);
        }];
        //        [self.commentsController.tableView mas_updateConstraints:^(MASConstraintMaker* make) {
        //            make.height.offset(0);
        //        }];
    }

    [self.contentLabel sizeToFit];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - build
- (void)buildCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.avatarImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avatarImageView];

    self.nameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textColor = [WeChatHelper wechatFontColor];
    self.nameLabel.font = [UIFont systemFontOfSize:15 weight:0.2];
    self.nameLabel.verticalAlignment = UIControlContentVerticalAlignmentTop;
    [self.contentView addSubview:self.nameLabel];

    self.contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.delegate = self;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.linkAttributes = @{ (NSString*)kCTForegroundColorAttributeName : [WeChatHelper wechatFontColor] };
    [self.contentView addSubview:self.contentLabel];

    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc] init];
    self.photosController = [[PhotosCollectionViewController alloc] initWithCollectionViewLayout:flow];
    [self.contentView addSubview:self.photosController.collectionView];

    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
    self.timeLabel.numberOfLines = 0;
    [self.contentView addSubview:self.timeLabel];

    self.likeCommentLogoView = [[UIImageView alloc] init];
    self.likeCommentLogoView.image = [UIImage imageNamed:@"AlbumOperateMore"];
    [self.contentView addSubview:self.likeCommentLogoView];

    self.commentsBubbleView = [[UIImageView alloc] init];
    self.commentsBubbleView.userInteractionEnabled = true;
    UIImage* bubbleImage = [UIImage imageNamed:@"LikeCmtBg"];
    self.commentsBubbleView.image = [bubbleImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    [self.contentView addSubview:self.commentsBubbleView];

    self.commentsController = [[CommentTableViewController alloc] init];
    [self.commentsBubbleView addSubview:self.commentsController.tableView];

    MASAttachKeys(self.avatarImageView, self.nameLabel, self.contentLabel, self.photosController.collectionView, self.timeLabel, self.likeCommentLogoView, self.commentsBubbleView, self.commentsController.tableView);
}

- (void)bindConstraints
{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.offset(10);
        make.width.height.offset(40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.height.offset(20);
        make.top.equalTo(self.avatarImageView);
        make.right.offset(-10);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.nameLabel);
        make.height.lessThanOrEqualTo(self.contentView);
    }];
    [self.photosController.collectionView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        CGFloat maxWidth = 3 * (kPhotoSize + kCellSpacing);
        make.width.greaterThanOrEqualTo(@(maxWidth));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.photosController.collectionView.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        make.width.lessThanOrEqualTo(self.contentView);
        make.height.offset(20);
    }];
    [self.likeCommentLogoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.timeLabel);
        make.right.equalTo(self.nameLabel).offset(4);
        make.width.height.offset(25);
    }];
    [self.commentsBubbleView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.nameLabel);
        //self-sizing cell的bottom约束必须要比其他约束的优先级低，不然约束要报错
        make.bottom.offset(-10).priorityLow();
    }];
    [self.commentsController.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.offset(7);
        make.left.offset(3);
        make.right.offset(-5);
        make.bottom.offset(0).priorityLow();
    }];
}
#pragma mark - attributed label delegate
- (void)attributedLabel:(TTTAttributedLabel*)label didSelectLinkWithURL:(NSURL*)url
{
    [[UIApplication sharedApplication] openURL:url];
}
@end
