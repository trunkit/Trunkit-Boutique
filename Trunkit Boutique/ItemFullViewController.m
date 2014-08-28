//
//  ItemFullViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/6/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "ItemFullViewController.h"
#import "UILabel+UILabel_TKExtensions.h"
#import "PhotoPagesViewController.h"

@interface ItemFullViewController ()

@property (strong, nonatomic) PhotoPagesViewController *photoPagesViewController;

@end

@implementation ItemFullViewController

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

    [self applyThemeToBlackButton:self.editButton withFontSize:15.0];
    [self applyTitleThemeToLabel:self.itemNameLabel withFontSize:18.0];
    [self applyThemeToLabel:self.styleNumberLabel withFontSize:14.0];
    [self applyThemeToLabel:self.designedByLabel withFontSize:14.0];
    [self applyThemeToLabel:self.suppliedByLabel withFontSize:14.0];
    [self applyThemeToLabel:self.supplierLabel withFontSize:14.0];
    [self applyThemeToLabel:self.priceLabel withFontSize:14.0];
    
    [self applyThemeToTextView:self.descriptionTextView withFontSize:14.0];
    self.descriptionTextView.layer.borderWidth = 0.0;
    
    self.priceButton.layer.borderWidth = 2.0;
    self.priceButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIFont *font = [UIFont fontWithName:@"BebasNeue" size:16.0];
    self.priceButton.titleLabel.font = font;
    self.priceButton.contentEdgeInsets = UIEdgeInsetsMake(4.0, 2.0, 0.0, 0.0);
    self.editButton.contentEdgeInsets = UIEdgeInsetsMake(2.0, 2.0, 0.0, 0.0);
    
    [self initDataInUI];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
    [tapRecognizer setDelegate:self];
    //    [tapRecognizer setDelaysTouchesBegan:YES];
	[self.photoPagesViewController.view addGestureRecognizer:tapRecognizer];
    

}

- (void)handleImageTap:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)initDataInUI
{
    self.itemNameLabel.text = self.merchandiseItem.itemName;
    [self.itemNameLabel applyThemeAttribute];
    
    self.styleNumberLabel.text = self.merchandiseItem.styleNumber;
    self.designedByLabel.text = [NSString stringWithFormat:@"Designed By %@", self.merchandiseItem.designerName];
    self.supplierLabel.text = self.merchandiseItem.supplierName;
    
    NSString *string = [NSString stringWithFormat:@"$%.02f", self.merchandiseItem.unitPrice];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];

    [self.priceButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    self.descriptionTextView.text = [NSString stringWithFormat:@"ABOUT THE CLOTHES:\n%@\n\nHOW DO THEY FIT?\n%@\n\nWHAT ARE THE CLOTHES MADE OF?\n%@"
                                     , self.merchandiseItem.itemLongDescription
                                     , self.merchandiseItem.fitDescription
                                     , self.merchandiseItem.materialsDescription];
    

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoPagesViewController *vc2 = [sb instantiateViewControllerWithIdentifier:@"PhotoPagesViewControllerIdentifier"];
    [vc2 setUsesMerchandiseProductPhotos:YES];
    vc2.merchandiseItem = self.merchandiseItem;
    //    [self addChildViewController:vc2];
    self.photoPagesViewController = vc2;
    vc2.view.frame = self.itemPhotosContainerView.bounds;
    [self.itemPhotosContainerView addSubview:vc2.view];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyThemeToLabel:(UILabel *)label withFontSize:(CGFloat)fontSize
{
    UIFont *font = nil;
    if (label == self.itemNameLabel)
    {
        font = [UIFont fontWithName:@"LucidaGrande" size:fontSize];
    }
    else
    {
        font = [UIFont fontWithName:@"HelveticaLTStd-LightCond" size:fontSize];
    }
	
	label.font = font;
}

- (IBAction)closeButtonTapped:(id)sender
{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    NSLog(@"SCROLL VIEW FRAME = (%f, %f, %f, %f), ", self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
}

@end
