//
//  LeftMenuViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UILabel+UILabel_TKExtensions.h"

@interface LeftMenuViewController ()

@property (strong, nonatomic) UITableView *myTableView;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *boldFont = [UIFont fontWithName:@"BebasNeue" size:18.0];
    self.suppliedLabel.font = boldFont;
    [self.suppliedLabel applyThemeAttribute];
    
    self.helpLabel.font = boldFont;
    [self.helpLabel applyThemeAttribute];
    
    self.termsLabel.font = boldFont;
    [self.termsLabel applyThemeAttribute];
    
    self.signoutLabel.font = boldFont;
    [self.signoutLabel applyThemeAttribute];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // The device is an iPhone or iPod touch.
        [self setFixedStatusBar];
    }
}

- (void)setFixedStatusBar
{
    self.myTableView = self.tableView;
    
    self.view = [[UIView alloc] initWithFrame:self.view.bounds];
    self.view.backgroundColor = self.myTableView.backgroundColor;
    [self.view addSubview:self.myTableView];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(self.view.frame.size.width,self.view.frame.size.height), 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarView];
}

@end
