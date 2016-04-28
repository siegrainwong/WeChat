//
//  MomentTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Comment.h"
#import "CommentTableViewController.h"
#import "Moment.h"
#import "MomentTableViewCell.h"
#import "PhotosCollectionViewController.h"
#import "SDAutoLayout/SDAutoLayoutDemo/SDAutoLayout/UIView+SDAutoLayout.h"
#import "TTTAttributedLabel/TTTAttributedLabel/TTTAttributedLabel.h"
#import "WeChatHelper.h"
/*
 Mark:
 之前用的Masonry+FDTemplateLayout算高，频出Bug。
 也不知道是约束插件出了问题还是算高插件的问题。
 这破问题从项目开始折腾我到项目结束，至少延长了我一半的开发时间，真™操蛋。
 换了SD的约束和算高插件就好了，约束逻辑也完全是正常逻辑，非常感谢作者。
 */
static NSString* const kBlogLink = @"http://siegrain.wang";
static NSString* const kGithubLink = @"https://github.com/Seanwong933";

static NSUInteger const kAvatarSize = 40;
static NSInteger const kContentLineCount = 6;

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

@property (strong, nonatomic) UIButton* fullTextButton;

@property (strong, nonatomic) Moment* model;
@end

@implementation MomentTableViewCell
#pragma mark - accessors
- (void)dealloc
{
    //    NSLog(@"MomentTableView Cell已释放。");
}
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildCell];
        [self bindConstraintsSD];
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
    self.timeLabel.text = @"1分钟前";
    self.commentsController.comments = model.comments;

    __weak typeof(self) weakSelf = self;
    //高亮链接
    if ([model.name isEqualToString:@"Siegrain Wong"]) {
        NSRange blogRange = [model.content rangeOfString:kBlogLink];
        NSRange githubRange = [model.content rangeOfString:kGithubLink];

        if (blogRange.location != NSNotFound)
            [weakSelf.contentLabel addLinkToURL:[NSURL URLWithString:kBlogLink] withRange:blogRange];
        if (githubRange.location != NSNotFound)
            [weakSelf.contentLabel addLinkToURL:[NSURL URLWithString:kGithubLink] withRange:githubRange];
    }

    /*
	 Mark:这里必须直接调用该方法，不能setNeedsUpdateConstraints然后updateConstraintsIfNeeded..
	 有时候真就不调用
	 */
    [self updateConstraints];
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

    self.fullTextButton = [[UIButton alloc] init];
    self.fullTextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.fullTextButton setTitleColor:[WeChatHelper wechatFontColor] forState:UIControlStateNormal];
    [self.fullTextButton setBackgroundImage:[WeChatHelper imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    self.fullTextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.fullTextButton addTarget:self action:@selector(toggleTextExpand:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.fullTextButton];

    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc] init];
    self.photosController = [[PhotosCollectionViewController alloc] initWithCollectionViewLayout:flow];
    [self.contentView addSubview:self.photosController.collectionView];

    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
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
}
- (void)bindConstraintsSD
{
    UIView* contentView = self.contentView;
    self.avatarImageView.sd_layout
      .topSpaceToView(contentView, 10)
      .leftSpaceToView(contentView, 10)
      .widthIs(kAvatarSize)
      .heightIs(kAvatarSize);

    self.nameLabel.sd_layout
      .leftSpaceToView(self.avatarImageView, 10)
      .rightSpaceToView(contentView, 10)
      .topEqualToView(self.avatarImageView)
      .heightIs(18);

    self.contentLabel.sd_layout
      .leftEqualToView(self.nameLabel)
      .topSpaceToView(self.nameLabel, 5)
      .rightSpaceToView(contentView, 10)
      .autoHeightRatio(0);

    self.fullTextButton.sd_layout
      .leftEqualToView(self.contentLabel)
      .topSpaceToView(self.contentLabel, 5)
      .widthIs(30)
      .heightIs(18);

    self.photosController.collectionView.sd_layout
      .leftEqualToView(self.nameLabel)
      .topSpaceToView(self.fullTextButton, 5);

    self.timeLabel.sd_layout
      .topSpaceToView(self.photosController.collectionView, 5)
      .leftEqualToView(self.nameLabel)
      .heightIs(15)
      .autoHeightRatio(0);

    self.likeCommentLogoView.sd_layout
      .rightSpaceToView(contentView, 10)
      .centerYEqualToView(self.timeLabel)
      .heightIs(25)
      .widthIs(25);

    self.commentsBubbleView.sd_layout
      .topSpaceToView(self.timeLabel, 5)
      .leftEqualToView(self.nameLabel)
      .rightSpaceToView(contentView, 10);

    self.commentsController.tableView.sd_layout
      .spaceToSuperView(UIEdgeInsetsMake(9, 3, 0, 5));
}
- (void)updateConstraints
{
    //评论框约束
    UIView* bottomView;
    UITableView* commentView = self.commentsController.tableView;
    if (!self.model.comments.count) {
        self.commentsBubbleView.fixedWidth = @0;
        self.commentsBubbleView.fixedHeight = @0;
        bottomView = self.timeLabel;
    } else {
        self.commentsBubbleView.fixedWidth = nil;
        self.commentsBubbleView.fixedHeight = @(commentView.contentSize.height + 15);
        bottomView = self.commentsBubbleView;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];

    //文字展开
    if (!self.model.contentLineCount) {
        self.model.contentLabelHeight = [self calculateContentLabelHeight];
        self.model.contentLineCount = self.model.contentLabelHeight / self.contentLabel.font.lineHeight;
    }
    if (self.model.contentLineCount > kContentLineCount) {
        self.fullTextButton.sd_layout.heightIs(18);
        self.fullTextButton.hidden = false;
        if (self.model.isContentExpanded) {
            self.contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [self.fullTextButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            self.contentLabel.sd_layout.maxHeightIs(self.contentLabel.font.lineHeight * kContentLineCount);
            [self.fullTextButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        self.fullTextButton.sd_layout.heightIs(0);
        self.fullTextButton.hidden = true;
    }

    [super updateConstraints];
}
#pragma mark - expand contentLabel text
- (void)toggleTextExpand:(UIButton*)sender
{
    MomentTableViewCell* cell = (MomentTableViewCell*)sender.superview.superview;
    if (self.toggleTextExpand) {
        self.toggleTextExpand(cell.model.indexPath);
    }
}
#pragma mark - attributed label delegate
- (void)attributedLabel:(TTTAttributedLabel*)label didSelectLinkWithURL:(NSURL*)url
{
    [[UIApplication sharedApplication] openURL:url];
}
#pragma mark -
- (CGFloat)calculateContentLabelHeight
{
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width - kAvatarSize - 3 * 10;
    CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
    NSDictionary* textAttrs = @{ NSFontAttributeName : self.contentLabel.font };
    return [self.contentLabel.text
             boundingRectWithSize:maxSize
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                       attributes:textAttrs
                          context:nil]
      .size.height;
}
@end
