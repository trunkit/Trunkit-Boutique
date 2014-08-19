//
//  SignInViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/11/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "TKEditViewController.h"

@interface SignInViewController : TKEditViewController

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)signinButtonTapped:(id)sender;

@end
