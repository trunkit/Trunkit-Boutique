//
//  SupplyAnItemPage3ViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/3/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SupplyAnItemPage3ViewController.h"

@interface SupplyAnItemPage3ViewController ()

@end

@implementation SupplyAnItemPage3ViewController

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
    
    [self applyThemeToTextField:self.fitTextField];
    [self applyThemeToTextField:self.materialsTextField];
    
    [self applyThemeToTextView:self.descriptionTextView];
    
    self.descriptionTextView.text = self.merchandiseItem.itemLongDescription;
    self.fitTextField.text = self.merchandiseItem.fitDescription;
    self.materialsTextField.text = self.merchandiseItem.materialsDescription;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)navigationItemTitle
{
    return @"About the Item";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.fitTextField)
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

//- (BOOL)textFieldShowsMatches:(UITextField *)textField
//{
//    return (textField == _categoryTextField
//            || textField == _subCategoryTextField);
//}

- (TKReferenceValueType)referenceValueTypeForTextField:(UITextField *)textField
{
    return TKReferenceValueNoneType;
}

- (IBAction)continueButtonTapped:(id)sender
{
    //TODO: Fields validation
    
    self.merchandiseItem.fitDescription = self.fitTextField.text;
    self.merchandiseItem.materialsDescription = self.materialsTextField.text;
    self.merchandiseItem.itemLongDescription = self.descriptionTextView.text;
    
    [self performSegueWithIdentifier:@"NewItemPage3ToPage4SegueIdentifier" sender:sender];
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


@end
