//
//  SupplyAnItemPageViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/2/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SupplyAnItemPageViewController.h"
#import "UILabel+UILabel_TKExtensions.h"

@interface SupplyAnItemPageViewController ()

@end

@implementation SupplyAnItemPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self applyThemeToBlackButton:self.continueButton];
    [self applyTitleThemeToLabel:self.pageNumberLabel withFontSize:18.0];
    [self.pageNumberLabel applyThemeAttribute];
    
//    self.continueButton.contentEdgeInsets = UIEdgeInsetsMake(2.0, 0.0, 0.0, 0.0);
}

- (NSString *)navigationItemTitle
{
    return @"Supply an Item";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueButtonTapped:(id)sender
{
    
}

@end
