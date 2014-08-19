//
//  ChooseExistingPhotosViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/5/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "ChooseExistingPhotosViewController.h"

@interface ChooseExistingPhotosViewController ()

@end

@implementation ChooseExistingPhotosViewController

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
    
    [self applyThemeToTextField:self.chooseBrandTextField];
    [self applyThemeToTextField:self.styleNumberTextField];

    self.chooseBrandTextField.text = self.merchandiseItem.designerName;
    self.styleNumberTextField.text = self.merchandiseItem.styleNumber;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)navigationItemTitle
{
    return @"Choose Existing Photos";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.chooseBrandTextField)
    {
        [self.styleNumberTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.chooseBrandTextField)
    {
        [self.styleNumberTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.styleNumberTextField)
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (TKReferenceValueType)referenceValueTypeForTextField:(UITextField *)textField
{
    if (textField == self.chooseBrandTextField)
        return TKReferenceValueBrandType;
    
    return TKReferenceValueNoneType;
}

- (IBAction)continueButtonTapped:(id)sender
{
    //TODO: Fields validation
    
    //TODO: Lookup existing photos and branch navigation
    
    self.merchandiseItem.styleNumber = self.styleNumberTextField.text;
    self.merchandiseItem.designerName = self.chooseBrandTextField.text;
    
    [self performSegueWithIdentifier:@"ChooseExistingPhotosToSupplyItemPage2SegueIdentifier" sender:sender];
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
