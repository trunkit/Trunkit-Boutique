//
//  ReviewItemViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/6/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "ReviewItemViewController.h"
#import "SuppliedItemsViewController.h"
#import "PhotoPagesViewController.h"
#import "ReferenceData.h"

@interface ReviewItemViewController ()

@property (strong, nonatomic) PhotoPagesViewController *photoPagesViewController;

@end

@implementation ReviewItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _updateMode = NO;
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _updateMode = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_updateMode)
    {
        [self.pageNumberLabel setHidden:YES];
        [self.pageProgressView setHidden:YES];
    }

    [self applyThemeToBlackButton:self.supplyButton];
    [self applyThemeToWhiteButton:self.editPhotosButton];
    [self applyThemeToWhiteButton:self.editSizesButton];
    
    [self applyThemeToTextField:self.itemNameTextField];
    [self applyThemeToTextField:self.styleNumberTextField];
    [self applyThemeToTextField:self.priceTextField];
    [self applyThemeToTextField:self.brandTextField];
    [self applyThemeToTextField:self.categoryTextField];
    [self applyThemeToTextField:self.subCategoryTextField];
    [self applyThemeToTextField:self.fitTextField];
    [self applyThemeToTextField:self.materialsTextField];
    [self applyThemeToTextView:self.descriptionTextView];
    
    self.itemNameTextField.text = self.merchandiseItem.itemName;
    self.styleNumberTextField.text = self.merchandiseItem.styleNumber;
    self.priceTextField.text = [NSString stringWithFormat:@"$%0.2f", self.merchandiseItem.unitPrice];
    self.brandTextField.text = self.merchandiseItem.designerName;
    self.categoryTextField.text = self.merchandiseItem.categoryName;
    self.subCategoryTextField.text = self.merchandiseItem.subCategoryName;
    self.descriptionTextView.text = self.merchandiseItem.itemLongDescription;
    self.fitTextField.text = self.merchandiseItem.fitDescription;
    self.materialsTextField.text = self.merchandiseItem.materialsDescription;
    [self formatCurrencyField:self.priceTextField];
    
    self.descriptionTextViewPlaceholder.hidden = ([self.descriptionTextView.text length] > 0);
    
    [self setupPhotoPages];
}


- (NSString *)navigationItemTitle
{
    return @"Review Item";
}

- (void)setupPhotoPages
{
    [self.photoPagesViewController.view removeFromSuperview];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoPagesViewController *photoPages = [sb instantiateViewControllerWithIdentifier:@"PhotoPagesViewControllerIdentifier"];
    photoPages.merchandiseItem = self.merchandiseItem;
    self.photoPagesViewController = photoPages;
    [photoPages setUsesMerchandiseProductPhotos:YES];
    photoPages.view.frame = self.itemPhotosContainerView.bounds;
    [self.itemPhotosContainerView addSubview:photoPages.view];
    
    // Acts buggy in iOS 8, so disabling for now
    self.itemPhotosContainerView.userInteractionEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupPhotoPages];
}

//- (void)viewDidLayoutSubviews
//{
//    self.scrollView.contentSize = self.detailsContainerView.frame.size;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    return [self textFieldShouldEndEditing:textField];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.itemNameTextField)
    {
        [self.styleNumberTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.styleNumberTextField)
    {
        [self.priceTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.priceTextField)
    {
        [self.brandTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.brandTextField)
    {
        [self.categoryTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.categoryTextField)
    {
        [self.subCategoryTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.subCategoryTextField)
    {
        [self.descriptionTextView becomeFirstResponder];
        return YES;
    }
    else if (textField == self.fitTextField)
    {
        [self.materialsTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.materialsTextField)
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldHasCurrencyFormat:(UITextField *)textField
{
    return (textField == self.priceTextField);
}

- (BOOL)validateBrand:(NSString *)brandText
{
    if (!brandText.length)
    {
        self.merchandiseItem.brandId = nil;
    }
    else
    {
        Brand *brand = [[ReferenceData sharedReferenceData] brandForName:brandText];
        if (!brand)
        {
            self.merchandiseItem.brandId = nil;
            return NO;
        }
        self.merchandiseItem.brandId = [NSString stringWithFormat:@"%lu", brand.id];
    }
    return YES;
}

- (BOOL)validateCategory:(NSString *)categoryText
{
    if (!categoryText.length)
    {
        self.merchandiseItem.itemCategoryId = nil;
    }
    else
    {
        ItemCategory *category = [[ReferenceData sharedReferenceData] categoryForName:categoryText];
        if (!category)
        {
            self.merchandiseItem.itemCategoryId = nil;
            return NO;
        }
        self.merchandiseItem.itemCategoryId = [NSString stringWithFormat:@"%lu", category.id];
    }
    return YES;
}

- (BOOL)validateSubCategory:(NSString *)categoryText
{
    if (!categoryText.length)
    {
        self.merchandiseItem.itemSubCategoryId = nil;
    }
    else
    {
        ItemCategory *category = [[ReferenceData sharedReferenceData] categoryForName:categoryText];
        if (!category)
        {
            self.merchandiseItem.itemSubCategoryId = nil;
            return NO;
        }
        self.merchandiseItem.itemSubCategoryId = [NSString stringWithFormat:@"%lu", category.id];
    }
    return YES;
}

- (TKReferenceValueType)referenceValueTypeForTextField:(UITextField *)textField
{
    if (textField == self.brandTextField)
        return TKReferenceValueBrandType;

    if (textField == self.categoryTextField)
        return TKReferenceValueCategoryType;
    
    if (textField == self.subCategoryTextField)
        return TKReferenceValueSubCategoryType;
    
    return TKReferenceValueNoneType;
}

- (NSUInteger)parentCategoryId
{
    return [self.merchandiseItem.itemCategoryId integerValue];
}

- (IBAction)supplyButtonTapped:(id)sender
{
    if (![self validateBrand:self.brandTextField.text])
    {
        NSLog(@"ERROR: Entered brand name failed validation.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Brand Name"
                                                        message:@"The brand name you entered is not a valid brand, please re-enter the brand by selecting one of the possible matches."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![self validateCategory:self.categoryTextField.text])
    {
        NSLog(@"ERROR: Entered category name failed validation.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Category Name"
                                                        message:@"The category name you entered is not a valid category, please re-enter the category by selecting one of the possible matches."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![self validateCategory:self.subCategoryTextField.text])
    {
        NSLog(@"ERROR: Entered subcategory name failed validation.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid SubCategory Name"
                                                        message:@"The sub-category name you entered is not a valid category, please re-enter the sub-category by selecting one of the possible matches."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSArray *controllers = self.navigationController.viewControllers;
    for (UIViewController *aController in controllers)
    {
        if ([aController isKindOfClass:[SuppliedItemsViewController class]])
        {
            [((SuppliedItemsViewController *)aController) addMerchandiseItem:self.merchandiseItem];
            [((SuppliedItemsViewController *)aController) reloadData];
            [self.navigationController popToViewController:aController animated:YES];
            break;
        }
    }
}

#pragma mark UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.descriptionTextViewPlaceholder.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.descriptionTextViewPlaceholder.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.descriptionTextViewPlaceholder.hidden = ([txtView.text length] > 0);
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
