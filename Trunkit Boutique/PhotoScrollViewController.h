//
//  PhotoScrollViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/17/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCollectionViewCell.h"

@interface PhotoScrollViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *photos;
//@property (strong, nonatomic) NSMutableArray *assets;
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;

- (void)addPhoto:(id)aPhoto;
- (void)removePhoto:(id)aPhoto;

@end
