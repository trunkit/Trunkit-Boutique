//
//  SignInViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/11/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

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
    [self applyThemeToTextField:self.emailTextField];
    [self applyThemeToTextField:self.passwordTextField];
    [self applyThemeToBlackButton:self.loginButton];
    
    [self checkUserIsCached];
}

- (void)checkUserIsCached
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.passwordTextField)
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
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

- (IBAction)signinButtonTapped:(id)sender
{
//    [self performSegueWithIdentifier:@"SignInControllerToSuppliedItemsSegueIdentifier" sender:sender];
    [self performSegueWithIdentifier:@"SignInToMainMenuSegueIdentifier" sender:sender];
}

@end
