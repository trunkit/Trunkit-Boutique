//
//  PhotoSelectionViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/12/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SupplyAnItemPageViewController.h"
#import "PhotoCollectionViewController.h"
#import "PhotoPagesViewController.h"

@interface PhotoSelectionViewController : SupplyAnItemPageViewController <PhotoCollectionDelegate>

@property (strong, nonatomic) IBOutlet UIButton *takeButton;
@property (strong, nonatomic) IBOutlet UIView *collectionContainerView;
@property (strong, nonatomic) IBOutlet UIView *itemPhotosContainerView;

- (IBAction)takeButtonTapped:(id)sender;
- (IBAction)takeButtonFromReviewTapped:(id)sender;

@end
