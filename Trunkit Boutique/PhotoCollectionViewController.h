//
//  PhotoCollectionViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCollectionViewCell.h"
#import "TKCollectionView.h"

@class PhotoCollectionViewController;

@protocol PhotoCollectionDelegate <NSObject>

- (void)photoCollectionViewController:(PhotoCollectionViewController *)controller didSelectItem:(id)item;
- (void)photoCollectionViewController:(PhotoCollectionViewController *)controller didDeSelectItem:(id)item;
- (void)photoCollectionViewController:(PhotoCollectionViewController *)controller didChangeSelection:(NSArray *)selectedAssets;

@end

@interface PhotoCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *selectedAssets;
@property (weak, nonatomic) id<PhotoCollectionDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *sessionPhotos;

- (void)addPhoto:(id)aPhoto;
- (void)removePhoto:(id)aPhoto;

@end
