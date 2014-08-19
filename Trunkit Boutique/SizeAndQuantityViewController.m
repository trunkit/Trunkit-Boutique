//
//  SizeAndQuantityViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/5/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SizeAndQuantityViewController.h"

@interface SizeAndQuantityViewController ()

@end

@implementation SizeAndQuantityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _hasMinusButton = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	SizeAndQuantityTableViewController *tableViewController = [sb instantiateViewControllerWithIdentifier:@"SizeAndQuantityTableViewControllerIdentifier"];
	[self addChildViewController:tableViewController];
    tableViewController.merchandiseItem = self.merchandiseItem;
    tableViewController.hasMinusButton = _hasMinusButton;
    tableViewController.view.frame = self.view.frame;
    [self.view addSubview:tableViewController.view];
    [tableViewController.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
