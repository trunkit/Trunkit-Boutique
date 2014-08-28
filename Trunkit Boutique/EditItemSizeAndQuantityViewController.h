//
//  EditItemSizeAndQuantityViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/27/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "TKEditViewController.h"

@interface EditItemSizeAndQuantityViewController : TKEditViewController

@property (strong, nonatomic) IBOutlet UIButton *editItemButton;

- (IBAction)editItemButtonTapped:(id)sender;

@end
