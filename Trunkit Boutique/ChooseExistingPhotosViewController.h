//
//  ChooseExistingPhotosViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/5/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupplyAnItemPageViewController.h"
#import "PhotoPagesViewController.h"

@interface ChooseExistingPhotosViewController : SupplyAnItemPageViewController

@property (strong, nonatomic) IBOutlet UITextField *chooseBrandTextField;
@property (strong, nonatomic) IBOutlet UITextField *styleNumberTextField;
@property (strong, nonatomic) IBOutlet UIView *photoPagesContainerView;

@property (strong, nonatomic) PhotoPagesViewController *photoPagesController;

@end
