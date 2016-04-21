//
//  CoverHeaderViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/21.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "CoverHeaderView.h"
#import "CoverHeaderViewController.h"
#import "Masonry/Masonry/Masonry.h"
#import "SpinningLoadingView.h"

@interface
CoverHeaderViewController ()
@property (strong, nonatomic) CoverHeaderView* coverView;
@property (strong, nonatomic) SpinningLoadingView* loadingView;

@end

@implementation CoverHeaderViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.loadingView = [SpinningLoadingView headerWithRefreshingBlock:^{

  }];

  self.coverView = [CoverHeaderView
    coverHeaderWithCover:[UIImage imageNamed:@"cover"]
                  avatar:[UIImage imageNamed:@"siegrain_avatar"]
                    name:@"Siegrain Wong"];

  [self.view addSubview:self.coverView];
  [self.loadingView addSubview:self.loadingView];
}

- (void)bindConstraints
{
  //  [self.coverView mas_makeConstraints:^(MASConstraintMaker* make) {
  //		make.ui
  //    make.top.right.left.bottom.offset(0);
  //  }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
@end
