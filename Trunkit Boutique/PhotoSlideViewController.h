//
//  PhotoSlideViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/3/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "TKEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoSlideViewController : TKEditViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (readwrite) NSInteger slideIndex;
@property (strong, nonatomic) id image;

@end
