//
//  PhotoCollectionViewCell.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALAssetsLibrary+TKSingleton.h"

@interface PhotoCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) ALAsset *asset;
@property (strong, nonatomic) NSURL *image;
@property(readwrite, nonatomic) NSInteger selectionOrder;
@property(strong, nonatomic) NSString *imageFormatIdentifier;

@end
