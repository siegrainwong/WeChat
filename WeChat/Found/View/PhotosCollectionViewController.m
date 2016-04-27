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

static NSString* const kIdentifier = @"Identifier";

@interface
PhotosCollectionViewController ()<IDMPhotoBrowserDelegate>
@property (strong, nonatomic) IDMPhotoBrowser* photoBrowser;
@property (strong, nonatomic) NSMutableArray* idmPhotosArray;
@property (weak, nonatomic) UIViewController* topController;
@end

@implementation PhotosCollectionViewController
@synthesize photosArray = _photosArray;

#pragma mark - accessors
- (UIViewController*)topController
{
    if (_topController == nil) {
        _topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (_topController.presentedViewController) {
            _topController = _topController.presentedViewController;
        }
    }
    return _topController;
}
- (NSMutableArray*)idmPhotosArray
{
    if (_idmPhotosArray == nil) {
        _idmPhotosArray = [NSMutableArray array];
        [self.photosArray enumerateObjectsUsingBlock:^(UIImage* obj, NSUInteger idx, BOOL* _Nonnull stop) {
            [_idmPhotosArray addObject:[IDMPhoto photoWithImage:obj]];
        }];
    }
    return _idmPhotosArray;
}
- (IDMPhotoBrowser*)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[IDMPhotoBrowser alloc] initWithPhotos:self.idmPhotosArray];
        _photoBrowser.delegate = self;
    }
    return _photoBrowser;
}
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
    cell.image = self.photosArray[indexPath.row];
    cell.tag = [self cellTagAtIndexPath:indexPath];
}
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger tag = [self cellTagAtIndexPath:indexPath];
    //    [self.photoBrowser setInitialPageIndex:tag];
    //由于PhotosCollectionViewController只是Cell种的一个子控制器，所以需要找到当前的presentedController进行present操作
    [self.topController presentViewController:self.photoBrowser animated:YES completion:nil];
}
#pragma mark -
- (NSInteger)cellTagAtIndexPath:(NSIndexPath*)indexPath
{
    return [[NSString stringWithFormat:@"%ld%ld", self.parentCellIndexPath.row + 1, indexPath.row + 1] integerValue];
}
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
@end
