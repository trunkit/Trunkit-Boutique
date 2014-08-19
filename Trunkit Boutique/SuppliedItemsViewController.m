//
//  SuppliedItemsViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/26/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SuppliedItemsViewController.h"
#import "ItemsTableViewController.h"

@interface SuppliedItemsViewController ()

@property (strong, nonatomic) ItemsTableViewController *itemsTableViewController;

@end

@implementation SuppliedItemsViewController

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
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData
{
    [self.itemsTableViewController.tableView reloadData];
}

- (void)addMerchandiseItem:(MerchandiseItem *)item
{
    [self.itemsTableViewController addMerchandiseItem:item];
//    [self reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[ItemsTableViewController class]])
    {
        self.itemsTableViewController = (ItemsTableViewController *)vc;
    }
}

- (IBAction)menuButtonTapped:(id)sender
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"TK_SHOW_MENU" object:nil];
}

@end
