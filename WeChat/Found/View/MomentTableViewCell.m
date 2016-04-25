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

static NSUInteger const kAvatarSize = 40;

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

@property (strong, nonatomic) Moment* model;
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

    //    self.avatarImageView.image = model.avatar;
    //    self.nameLabel.text = model.name;
    //    self.contentLabel.text = model.content;
    //    self.photosController.photosArray = model.pictures;
    //    self.photosController.parentCellIndexPath = model.indexPath;
    //    self.timeLabel.text = @"1分钟前";
    self.commentsController.comments = model.comments;

    __weak typeof(self) weakSelf = self;
    //    //高亮链接
    //    if ([model.name isEqualToString:@"Siegrain Wong"]) {
    //        NSRange blogRange = [model.content rangeOfString:kBlogLink];
    //        NSRange githubRange = [model.content rangeOfString:kGithubLink];
    //
    //        if (blogRange.location != NSNotFound)
    //            [weakSelf.contentLabel addLinkToURL:[NSURL URLWithString:kBlogLink] withRange:blogRange];
    //        if (githubRange.location != NSNotFound)
    //            [weakSelf.contentLabel addLinkToURL:[NSURL URLWithString:kGithubLink] withRange:githubRange];
    //    }
    //
    //    [self setNeedsLayout];
    //    [self layoutIfNeeded];
}

#pragma mark - build
- (void)buildCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    //    self.avatarImageView = [[UIImageView alloc] init];
    //    [self.contentView addSubview:self.avatarImageView];
    //
    //    self.nameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    //    self.nameLabel.textColor = [WeChatHelper wechatFontColor];
    //    self.nameLabel.font = [UIFont systemFontOfSize:15 weight:0.2];
    //    self.nameLabel.verticalAlignment = UIControlContentVerticalAlignmentTop;
    //    [self.contentView addSubview:self.nameLabel];
    //
    //    self.contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    //    self.contentLabel.delegate = self;
    //    self.contentLabel.numberOfLines = 0;
    //    self.contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    //    self.contentLabel.font = [UIFont systemFontOfSize:15];
    //    self.contentLabel.linkAttributes = @{ (NSString*)kCTForegroundColorAttributeName : [WeChatHelper wechatFontColor] };
    //    [self.contentView addSubview:self.contentLabel];
    //
    //    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc] init];
    //    self.photosController = [[PhotosCollectionViewController alloc] initWithCollectionViewLayout:flow];
    //    [self.contentView addSubview:self.photosController.collectionView];
    //
    //    self.timeLabel = [[UILabel alloc] init];
    //    self.timeLabel.font = [UIFont systemFontOfSize:12];
    //    self.timeLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
    //    [self.contentView addSubview:self.timeLabel];
    //
    //    self.likeCommentLogoView = [[UIImageView alloc] init];
    //    self.likeCommentLogoView.image = [UIImage imageNamed:@"AlbumOperateMore"];
    //    [self.contentView addSubview:self.likeCommentLogoView];

    self.commentsBubbleView = [[UIImageView alloc] init];
    self.commentsBubbleView.userInteractionEnabled = true;
    UIImage* bubbleImage = [UIImage imageNamed:@"LikeCmtBg"];
    self.commentsBubbleView.image = [bubbleImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    [self.contentView addSubview:self.commentsBubbleView];

    self.commentsController = [[CommentTableViewController alloc] init];
    [self.commentsBubbleView addSubview:self.commentsController.tableView];
}
- (void)bindConstraints
{
    //    MASAttachKeys(self.avatarImageView, self.nameLabel, self.contentLabel, self.photosController.collectionView,
    //                  self.timeLabel, self.likeCommentLogoView, self.commentsBubbleView, self.commentsController.tableView);

    __weak typeof(self) weakSelf = self;
    //    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker* make) {
    //        make.top.left.offset(10);
    //        make.width.height.offset(kAvatarSize);
    //    }];
    //    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
    //        make.left.equalTo(weakSelf.avatarImageView.mas_right).offset(10);
    //        make.top.equalTo(weakSelf.avatarImageView);
    //        make.right.offset(-10);
    //        make.height.offset(22);
    //    }];
    //    self.contentLabel.preferredMaxLayoutWidth = self.frame.size.width - kAvatarSize - 3 * 10;
    //    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
    //        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(5);
    //        make.left.right.equalTo(weakSelf.nameLabel);
    //    }];
    //    [self.contentLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
    //
    //    int pictureRows = [[self.reuseIdentifier stringByReplacingOccurrencesOfString:@"Identifier" withString:@""] intValue];
    //    [self.photosController.collectionView mas_makeConstraints:^(MASConstraintMaker* make) {
    //        make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(5);
    //        make.left.equalTo(weakSelf.nameLabel);
    //        CGFloat rowSize = kPhotoSize + kCellSpacing;
    //        make.width.offset(rowSize * 3);
    //        make.height.offset(rowSize * pictureRows);
    //    }];
    //    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
    //        make.top.equalTo(weakSelf.photosController.collectionView.mas_bottom).offset(5);
    //        make.left.equalTo(weakSelf.nameLabel);
    //        make.width.lessThanOrEqualTo(weakSelf.contentView);
    //        make.height.offset(22);
    //    }];
    //    [self.likeCommentLogoView mas_makeConstraints:^(MASConstraintMaker* make) {
    //        make.top.equalTo(weakSelf.timeLabel);
    //        make.right.equalTo(weakSelf.nameLabel).offset(4);
    //        make.width.height.offset(25);
    //    }];
    [self.commentsBubbleView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.offset(5);
        make.left.offset(5);
        make.right.offset(-5);
        //        make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(5);
        //        make.left.right.equalTo(weakSelf.nameLabel);
        //self-sizing cell的bottom约束必须要比其他约束的优先级低，不然约束要报错
        make.bottom.offset(-10).priorityLow();
    }];
    [self.commentsController.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.offset(7);
        make.left.offset(3);
        make.right.offset(-5);
        make.bottom.offset(-5).priorityLow();
    }];
    [self.commentsController.tableView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
}
- (void)updateConstraints
{
    [super updateConstraints];

    __weak typeof(self) weakSelf = self;
    //    if (self.model.comments.count > 0) {
    //        [self.commentsBubbleView mas_updateConstraints:^(MASConstraintMaker* make) {
    //            CGSize size = weakSelf.commentsController.tableView.contentSize;
    //            make.height.offset(size.height + 15);
    //        }];
    //    } else {
    //        [self.commentsBubbleView mas_updateConstraints:^(MASConstraintMaker* make) {
    //            make.height.offset(0);
    //        }];
    //    }
}
#pragma mark - attributed label delegate
- (void)attributedLabel:(TTTAttributedLabel*)label didSelectLinkWithURL:(NSURL*)url
{
    [[UIApplication sharedApplication] openURL:url];
}
@end
