//
//  PhotosCollectionViewController.m
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "IDMPhotoBrowser/Classes/IDMPhotoBrowser.h"
#import "PhotosCollectionViewController.h"

static NSUInteger const kPhotoSize = 65;
static NSString* const reuseIdentifier = @"Cell";

@interface
PhotosCollectionViewController ()
@property (strong, nonatomic) IDMPhotoBrowser* photoBrowser;
@end

@implementation PhotosCollectionViewController
#pragma mark - accessors
- (NSArray<UIImage*>*)photosArray
{
    if (_photosArray == nil) {
        _photosArray = [NSArray array];
    }
    return _photosArray;
}
#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        // 1.创建流水布局
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];

        // 2.设置每个格子的尺寸
        layout.itemSize = CGSizeMake(kPhotoSize, kPhotoSize);

        // 4.设置每一行之间的间距
        layout.minimumLineSpacing = 5;

        self = [self initWithCollectionViewLayout:layout];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    //    __block NSMutableArray* idmPhotos = [NSMutableArray array];
    //    [model.pictures enumerateObjectsUsingBlock:^(UIImage* obj, NSUInteger idx, BOOL* _Nonnull stop) {
    //      [idmPhotos addObject:[IDMPhoto photoWithImage:obj]];
    //    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - collectionview
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UICollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    imageView.image = self.photosArray[indexPath.row];

    [cell addSubview:imageView];
}
@end
