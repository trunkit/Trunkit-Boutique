//
//  EditItemSizeAndQuantityViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/27/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "EditItemSizeAndQuantityViewController.h"
#import "ReviewItemViewController.h"

@interface EditItemSizeAndQuantityViewController ()

@end

@implementation EditItemSizeAndQuantityViewController

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

    [self applyThemeToBlackButton:_editItemButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editItemButtonTapped:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReviewItemViewController *editVC = [sb instantiateViewControllerWithIdentifier:@"ReviewItemViewControllerIdentifier"];
    editVC.updateMode = YES;
    editVC.merchandiseItem = self.merchandiseItem;
    [self.navigationController pushViewController:editVC animated:YES];

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
