//
//  MomentTableViewCell.m
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "Comment.h"
#import "CommentTableViewController.h"
#import "Masonry/Masonry/Masonry.h"
#import "Moment.h"
#import "MomentTableViewCell.h"
#import "PhotosCollectionViewController.h"
#import "SDAutoLayout/SDAutoLayoutDemo/SDAutoLayout/UIView+SDAutoLayout.h"
#import "TTTAttributedLabel/TTTAttributedLabel/TTTAttributedLabel.h"
#import "WeChatHelper.h"

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
    self.photosController.parentCellIndexPath = model.indexPath;
    self.timeLabel.text = @"1分钟前";
    self.commentsController.comments = model.comments;
    //    [self.fullTextButton setTitle:@"全文" forState:UIControlStateNormal];

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

    //    self.fullTextButton = [[UIButton alloc] init];
    //    self.fullTextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [self.fullTextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    self.fullTextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [self.contentView addSubview:self.fullTextButton];

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
    //
    //    self.commentsBubbleView = [[UIImageView alloc] init];
    //    self.commentsBubbleView.userInteractionEnabled = true;
    //    UIImage* bubbleImage = [UIImage imageNamed:@"LikeCmtBg"];
    //    self.commentsBubbleView.image = [bubbleImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    //    [self.contentView addSubview:self.commentsBubbleView];
    //
    //    self.commentsController = [[CommentTableViewController alloc] init];
    //    [self.commentsBubbleView addSubview:self.commentsController.tableView];
}
- (void)bindConstraints
{
    MASAttachKeys(self.avatarImageView, self.nameLabel, self.contentLabel,
                  self.photosController.collectionView, self.timeLabel, self.likeCommentLogoView,
                  self.commentsBubbleView, self.commentsController.tableView //, self.fullTextButton
                  );

    __weak typeof(self) weakSelf = self;
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.offset(kAvatarSize);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(weakSelf.avatarImageView.mas_right).offset(10);
        make.top.equalTo(weakSelf.avatarImageView);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.height.offset(22);
    }];
    self.contentLabel.preferredMaxLayoutWidth = self.contentView.frame.size.width;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(5);
        make.left.right.equalTo(weakSelf.nameLabel);
    }];
    [self.contentLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];

    //    [self.fullTextButton mas_makeConstraints:^(MASConstraintMaker* make) {
    //        make.left.equalTo(weakSelf.nameLabel);
    //        make.right.lessThanOrEqualTo(weakSelf.contentView);
    //        make.height.offset(22);
    //    }];

    int pictureRows = [[self.reuseIdentifier stringByReplacingOccurrencesOfString:@"Identifier" withString:@""] intValue];
    [self.photosController.collectionView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.nameLabel);
        CGFloat rowSize = kPhotoSize + kCellSpacing;
        make.width.offset(rowSize * 3);
        make.height.offset(rowSize * pictureRows);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.photosController.collectionView.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.nameLabel);
        make.width.lessThanOrEqualTo(weakSelf.contentView);
        make.height.offset(22);
    }];
    [self.likeCommentLogoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.timeLabel);
        make.right.equalTo(weakSelf.nameLabel).offset(4);
        make.width.height.offset(25);
    }];
    [self.commentsBubbleView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(5);
        make.left.right.equalTo(weakSelf.nameLabel);
        //self-sizing cell的bottom约束必须要比其他约束的优先级低，不然约束要报错
        make.bottom.equalTo(weakSelf.contentView).offset(-10).priorityLow();
    }];
    [self.commentsController.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.offset(9);
        make.left.offset(3);
        make.right.offset(-5);
        make.bottom.offset(0).priorityLow();
    }];
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

    self.photosController.collectionView.sd_layout
      .leftEqualToView(self.nameLabel)
      .topSpaceToView(self.contentLabel, 5);

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

    //    self.commentsBubbleView.sd_layout
    //      .topSpaceToView(self.timeLabel, 5)
    //      .leftEqualToView(self.nameLabel)
    //      .rightSpaceToView(contentView, 10);
}
- (void)updateConstraints
{
    //    __weak typeof(self) weakSelf = self;
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

    //    UIView* bottomView;
    UIView* bottomView = self.timeLabel;
    //    UIView* commentView = self.commentsController.tableView;
    //    if (!self.model.comments.count) {
    //        commentView.fixedWidth = @0;
    //        commentView.fixedHeight = @0;
    //        commentView.sd_layout.topSpaceToView(self.timeLabel, 0);
    //        bottomView = self.timeLabel;
    //    } else {
    //        commentView.fixedHeight = nil;
    //        commentView.fixedWidth = nil;
    //        commentView.sd_layout.topSpaceToView(self.timeLabel, 5);
    //        bottomView = commentView;
    //    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];

    /*
	 算高，算行数
	 */
    //    NSInteger lineCount = self.model.contentLineCount;
    //    if (!lineCount) {
    //        /*这里cell还没显示出来，默认frame宽度是320，所以要用screen来获取？*/
    //        CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width - kAvatarSize - 3 * 10;
    //        CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
    //        //        self.model.contentLabelSize = [self.contentLabel sizeThatFits:maxSize];
    //
    //        NSDictionary* textAttrs = @{ NSFontAttributeName : self.contentLabel.font };
    //        self.model.contentLabelHeight = [self.contentLabel.text
    //                                          boundingRectWithSize:maxSize
    //                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
    //                                                    attributes:textAttrs
    //                                                       context:nil]
    //                                          .size.height;
    //
    //        NSInteger lineCount = self.model.contentLabelHeight / self.contentLabel.font.lineHeight;
    //        //        NSLog(@"sizeThatFits:%f---%ld    boundingRectWithSize:%f---%ld", size.height, lineCount, textH, lineCount2);
    //
    //        self.model.contentLineCount = lineCount;
    //    }
    //    NSLog(@"%f---%ld", self.model.contentLabelHeight, self.model.contentLineCount);
    //    if (lineCount > kContentLineCount) {
    //        self.fullTextButton.hidden = false;
    //        [self.fullTextButton mas_updateConstraints:^(MASConstraintMaker* make) {
    //            make.top.offset(weakSelf.model.contentLabelHeight + 22 + 3 * 5 + 20);
    //        }];
    //        //        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker* make) {
    //        //            make.height.offset(self.model.contentLabelHeight + 22).priority(1000);
    //        //        }];
    //    } else {
    //        self.fullTextButton.hidden = true;
    //        [self.fullTextButton mas_updateConstraints:^(MASConstraintMaker* make) {
    //            make.top.offset(weakSelf.model.contentLabelHeight);
    //        }];
    //        //        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker* make) {
    //        //            make.height.offset(self.model.contentLabelHeight + 1).priority(1000);
    //        //        }];
    //    }

    [super updateConstraints];
}
#pragma mark - attributed label delegate
- (void)attributedLabel:(TTTAttributedLabel*)label didSelectLinkWithURL:(NSURL*)url
{
    [[UIApplication sharedApplication] openURL:url];
}
@end
