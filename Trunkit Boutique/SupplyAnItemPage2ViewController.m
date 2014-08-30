//
//  SupplyAnItemPage2ViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/2/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SupplyAnItemPage2ViewController.h"

@interface SupplyAnItemPage2ViewController ()

@end

@implementation SupplyAnItemPage2ViewController

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
    self.navigationItem.backBarButtonItem = nil;

    [self applyThemeToTextField:self.subCategoryTextField];
    [self applyThemeToTextField:self.categoryTextField];
    [self applyThemeToTextField:self.itemNameTextField];
    [self applyThemeToTextField:self.priceTextField];
    
    self.categoryTextField.text = self.merchandiseItem.itemCategory;
    self.subCategoryTextField.text = self.merchandiseItem.itemSubCategory;
    self.itemNameTextField.text = self.merchandiseItem.itemName;
//    self.priceTextField.text = (self.merchandiseItem.unitPrice == 0) ? @"" : [NSString stringWithFormat:@"$%0.2f", self.merchandiseItem.unitPrice];
    self.priceTextField.text = [NSString stringWithFormat:@"$%0.2f", self.merchandiseItem.unitPrice];
    [self formatCurrencyField:self.priceTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)navigationItemTitle
{
    return @"Supply a new Item";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.itemNameTextField)
    {
        [self.priceTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.priceTextField)
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
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldHasCurrencyFormat:(UITextField *)textField
{
    return (textField == self.priceTextField);
}

- (TKReferenceValueType)referenceValueTypeForTextField:(UITextField *)textField
{
    if (textField == self.categoryTextField)
        return TKReferenceValueCategoryType;
    else if (textField == self.subCategoryTextField)
        return TKReferenceValueSubCategoryType;
    
    return TKReferenceValueNoneType;
}

- (IBAction)continueButtonTapped:(id)sender
{
    //TODO: Fields validation
    
    self.merchandiseItem.itemName = self.itemNameTextField.text;
    self.merchandiseItem.unitPrice = [self.priceTextField.text floatValue];
    self.merchandiseItem.itemCategory = self.categoryTextField.text;
    self.merchandiseItem.itemSubCategory = self.subCategoryTextField.text;
    
    [self performSegueWithIdentifier:@"NewItemPage2ToPage3SegueIdentifier" sender:sender];
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
