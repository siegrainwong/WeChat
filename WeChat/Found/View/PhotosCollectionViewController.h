//
//  PhotosCollectionViewController.h
//  WeChat
//
//  Created by Siegrain on 16/4/23.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSUInteger const kPhotoSize = 90;
static NSUInteger const kCellSpacing = 5;

@interface PhotosCollectionViewController : UICollectionViewController
@property (copy, nonatomic) NSArray<UIImage*>* photosArray;
@property (strong, nonatomic) NSIndexPath* parentCellIndexPath;
@end
