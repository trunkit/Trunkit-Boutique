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

@end
