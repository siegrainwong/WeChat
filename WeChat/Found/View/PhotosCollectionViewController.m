//
//  PhotosCollectionViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "PhotosCollectionViewController.h"

@interface
PhotosCollectionViewController ()

@end

@implementation PhotosCollectionViewController
static NSString* const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];

    _photosArray = [NSArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionview
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.photosArray.count / 3;
}
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count / 3;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UICollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    UIImage* image = self.photosArray[indexPath.row];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:cell.frame];
}
@end
