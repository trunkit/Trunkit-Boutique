//
//  ReviewItemViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/6/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SupplyAnItemPageViewController.h"

@interface ReviewItemViewController : SupplyAnItemPageViewController

@property (strong, nonatomic) IBOutlet UIButton *supplyButton;

@property (strong, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *styleNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UITextField *brandTextField;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) IBOutlet UITextField *subCategoryTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextField *fitTextField;
@property (strong, nonatomic) IBOutlet UITextField *materialsTextField;
//@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIView *itemPhotosContainerView;

@property (strong, nonatomic) IBOutlet UIButton *editPhotosButton;
@property (strong, nonatomic) IBOutlet UIButton *editSizesButton;

- (IBAction)supplyButtonTapped:(id)sender;

@end
