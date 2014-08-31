//
//  PhotoPagesViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/3/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseItem.h"

@interface PhotoPagesViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) MerchandiseItem *merchandiseItem;
@property (readwrite, nonatomic) BOOL usesMerchandiseProductPhotos;
@property (strong, nonatomic) IBOutlet UIView *controlView;

- (void)addPhoto:(id)photo;
- (void)removePhoto:(id)photo;

@end
