//
//  SupplyAnItemPage1ViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/2/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SupplyAnItemPage1ViewController.h"
#import "CameraViewController.h"
#import "ChooseExistingPhotosViewController.h"

@interface SupplyAnItemPage1ViewController ()

@end

@implementation SupplyAnItemPage1ViewController

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
    [self applyThemeToTextField:self.styleNumberTextField];
    [self applyThemeToTextField:self.brandTextField];
    
    self.merchandiseItem = [[MerchandiseItem alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.styleNumberTextField)
    {
        [self.brandTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.brandTextField)
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//- (BOOL)textFieldShowsMatches:(UITextField *)textField
//{
//    return (textField == _brandTextField);
//}

- (TKReferenceValueType)referenceValueTypeForTextField:(UITextField *)textField
{
    if (textField == self.brandTextField)
        return TKReferenceValueBrandType;
    
    return TKReferenceValueNoneType;
}

- (IBAction)continueButtonTapped:(id)sender
{
    //TODO: Fields validation
    
    //TODO: Lookup existing photos and branch navigation
    
    self.merchandiseItem.styleNumber = self.styleNumberTextField.text;
    self.merchandiseItem.designerName = self.brandTextField.text;
    
    UIViewController *popToVC = nil;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (![self.merchandiseItem.styleNumber hasSuffix:@"123"])
    {
        CameraViewController *cameraVC = [sb instantiateViewControllerWithIdentifier:@"CameraViewControllerIdentifier"];
        cameraVC.merchandiseItem = self.merchandiseItem;
        popToVC = cameraVC;
    }
    else
    {
        ChooseExistingPhotosViewController *existingPhotosVC = [sb instantiateViewControllerWithIdentifier:@"ChooseExistingPhotosViewControllerIdentifier"];
        existingPhotosVC.merchandiseItem = self.merchandiseItem;
        popToVC = existingPhotosVC;
    }
    
    [self.navigationController pushViewController:popToVC animated:YES];
    
//    [self performSegueWithIdentifier:@"NewItemFirstPageToNextControllerSegueIdentifier" sender:sender];
}

/*
#pragma mark - NavigationItem

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
