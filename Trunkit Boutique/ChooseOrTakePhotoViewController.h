//
//  ChooseOrTakePhotoViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/5/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupplyAnItemPageViewController.h"

@interface ChooseOrTakePhotoViewController : SupplyAnItemPageViewController

@property (strong, nonatomic) IBOutlet UILabel *chooseExistingPhotosLabel;
@property (strong, nonatomic) IBOutlet UILabel *takeAPhotoLabel;

@end
