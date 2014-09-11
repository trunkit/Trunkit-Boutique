//
//  TKSwipeToExpandViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKEditViewController.h"

typedef enum
{
    TKSwipeToExpandViewPositionCollapsed,
    TKSwipeToExpandViewPositionExpanded,
} TKSwipeToExpandViewPosition;


@interface TKSwipeToExpandViewController : TKEditViewController

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionContainerHeightCon;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *pagesContainerView;

@property (strong, nonatomic) UICollectionView *collectionView;

@end
