//
//  ItemFullViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/6/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "TKEditViewController.h"

@interface ItemFullViewController : TKEditViewController

//@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *itemPhotosContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *itemMainPhotoImageView;
@property (strong, nonatomic) IBOutlet UIButton *priceButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;

@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *styleNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *designedByLabel;
@property (strong, nonatomic) IBOutlet UILabel *suppliedByLabel;
@property (strong, nonatomic) IBOutlet UILabel *supplierLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutTheClothesLabel;

@property (strong, nonatomic) IBOutlet UIImageView *supplierImageView;

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

- (IBAction)closeButtonTapped:(id)sender;

@end
