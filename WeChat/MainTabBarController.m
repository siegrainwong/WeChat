//
//  MainTabBarController.m
//  WeChat
//
//  Created by Siegrain on 16/3/28.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "ChatViewController.h"
#import "ContactsViewController.h"
#import "DiscoverViewController.h"
#import "MainTabBarController.h"
#import "MeViewController.h"
@implementation MainTabBarController
- (void)viewDidLoad
{
  [super viewDidLoad];

  ChatViewController* chatVC = [[ChatViewController alloc] init];
  chatVC.title = @"微信";

  ContactsViewController* addbkVC = [[ContactsViewController alloc] init];
  addbkVC.title = @"通讯录";

  DiscoverViewController* foundVC = [[DiscoverViewController alloc] init];
  foundVC.title = @"发现";

  MeViewController* meVC = [[MeViewController alloc] init];
  meVC.title = @"我";

  self.viewControllers = @[
    [self giveMeNavWithVC:chatVC
               andImgName:@"tabbar_mainframe"
         andSelectImgName:@"tabbar_mainframeHL"],
    [self giveMeNavWithVC:addbkVC
               andImgName:@"tabbar_contacts"
         andSelectImgName:@"tabbar_contactsHL"],
    [self giveMeNavWithVC:foundVC
               andImgName:@"tabbar_discover"
         andSelectImgName:@"tabbar_discoverHL"],
    [self giveMeNavWithVC:meVC
               andImgName:@"tabbar_me"
         andSelectImgName:@"tabbar_meHL"]
  ];

  self.tabBar.tintColor =
    [UIColor colorWithRed:9 / 255.0 green:187 / 255.0 blue:7 / 255.0 alpha:1];
}

/**
 *  返回取消渲染的image
 */
- (UIImage*)removeRendering:(NSString*)imageName
{
  UIImage* image = [UIImage imageNamed:imageName];
  return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 *  快速创建Nav
 */
- (UINavigationController*)giveMeNavWithVC:(UIViewController*)VC
                                andImgName:(NSString*)imgName
                          andSelectImgName:(NSString*)selectImgName
{
  UINavigationController* nav =
    [[UINavigationController alloc] initWithRootViewController:VC];
  nav.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:VC.title
                                  image:[self removeRendering:imgName]
                          selectedImage:[self removeRendering:selectImgName]];

  return nav;
}
- (void)viewWillLayoutSubviews
{
}
@end
