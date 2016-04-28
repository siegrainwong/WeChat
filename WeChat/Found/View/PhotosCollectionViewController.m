//
//  PhotosCollectionViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "IDMPhotoBrowser/Classes/IDMPhotoBrowser.h"
#import "PhotoCollectionViewCell.h"
#import "PhotosCollectionViewController.h"
#import "SDAutoLayout/SDAutoLayoutDemo/SDAutoLayout/UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"

static NSString* const kIdentifier = @"Identifier";

@interface
PhotosCollectionViewController ()<SDPhotoBrowserDelegate>
@end

@implementation PhotosCollectionViewController
@synthesize photosArray = _photosArray;

- (void)dealloc
{
    //    NSLog(@"PhotosCollectionView Controller已释放。");
}
- (void)viewDidDisappear:(BOOL)animated
{
    self.photosArray = nil;

    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
}
#pragma mark - accessors
- (NSArray<UIImage*>*)photosArray
{
    if (_photosArray == nil) {
        _photosArray = [NSArray array];
    }
    return _photosArray;
}
- (void)setPhotosArray:(NSArray<UIImage*>*)photosArray
{
    _photosArray = photosArray;

    [self configureViewSize];
    [self.collectionView reloadData];
}
#pragma mark - init
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.collectionView.scrollEnabled = false;
        self.collectionView.showsVerticalScrollIndicator = false;
        self.collectionView.showsHorizontalScrollIndicator = false;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];

        UICollectionViewFlowLayout* flow = (UICollectionViewFlowLayout*)layout;
        flow.itemSize = CGSizeMake(kPhotoSize, kPhotoSize);
        flow.minimumLineSpacing = kCellSpacing;
        flow.minimumInteritemSpacing = 2.5;
    }
    return self;
}
#pragma mark - collectionview
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(PhotoCollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.imageView.image = self.photosArray[indexPath.row];
    cell.imageView.tag = indexPath.row;
}
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    SDPhotoBrowser* browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.collectionView;
    browser.imageCount = self.photosArray.count;
    browser.currentImageIndex = indexPath.row;
    browser.delegate = self;
    [browser show];
}
#pragma mark -
- (void)configureViewSize
{
    if (self.calculatedSize) return;

    UICollectionViewFlowLayout* flow = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    NSInteger count = self.photosArray.count;
    NSInteger itemsPerRow = [self itemsPerRow];
    CGSize size = CGSizeZero;
    if (count == 0)
        size = CGSizeZero;
    else if (count == 1) {
        flow.itemSize = CGSizeMake(kPhotoSizeSingle, kPhotoSizeSingle);
        size = CGSizeMake(kPhotoSizeSingle, kPhotoSizeSingle);
    } else {
        flow.itemSize = CGSizeMake(kPhotoSize, kPhotoSize);
        CGFloat width = itemsPerRow * (kPhotoSize + kCellSpacing);
        CGFloat height = ceilf((float)count / (float)itemsPerRow) * (kPhotoSize + kCellSpacing);
        size = CGSizeMake(width, height);
    }

    self.collectionView.fixedWidth = @(size.width);
    self.collectionView.width = size.width;
    self.collectionView.fixedHeight = @(size.height);
    self.collectionView.height = size.height;
}
- (NSInteger)itemsPerRow
{
    NSInteger count = self.photosArray.count;
    if (count < 3) {
        return count;
    } else if (count <= 4) {
        return 2;
    } else {
        return 3;
    }
}
#pragma mark - SDPhotoBrowserDelegate
- (UIImage*)photoBrowser:(SDPhotoBrowser*)browser placeholderImageForIndex:(NSInteger)index
{
    return self.photosArray[index];
}
@end
