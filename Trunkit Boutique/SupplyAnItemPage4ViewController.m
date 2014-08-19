//
//  SupplyAnItemPage4ViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/5/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SupplyAnItemPage4ViewController.h"
#import "SizeAndQuantityViewController.h"

@interface SupplyAnItemPage4ViewController ()

@end

@implementation SupplyAnItemPage4ViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)navigationItemTitle
{
    return @"Sizing & Quantity";
}

- (IBAction)continueButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"NewItemPage4ToPage5SegueIdentifier" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"SupplyAnItemPage4ToSizeAndQuantitySegue"])
    {
        SizeAndQuantityViewController *vc = segue.destinationViewController;
        vc.hasMinusButton = NO;
    }
}

@end
