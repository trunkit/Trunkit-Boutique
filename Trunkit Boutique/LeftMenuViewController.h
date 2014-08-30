//
//  LeftMenuViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"

@interface LeftMenuViewController : AMSlideMenuLeftTableViewController

@property (strong, nonatomic) IBOutlet UILabel *suppliedLabel;
@property (strong, nonatomic) IBOutlet UILabel *helpLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;
@property (strong, nonatomic) IBOutlet UILabel *signoutLabel;

@property (strong, nonatomic) IBOutlet UIImageView *suppliedMenuImageView;
@property (strong, nonatomic) IBOutlet UIImageView *helpMenuImageView;
@property (strong, nonatomic) IBOutlet UIImageView *termsMenuImageView;
@property (strong, nonatomic) IBOutlet UIImageView *signoutMenuImageView;

@property (strong, nonatomic) IBOutlet UIView *suppliedMenuFrameView;
@property (strong, nonatomic) IBOutlet UIView *helpMenuFrameView;
@property (strong, nonatomic) IBOutlet UIView *termsMenuFrameView;
@property (strong, nonatomic) IBOutlet UIView *signoutMenuFrameView;

@end
