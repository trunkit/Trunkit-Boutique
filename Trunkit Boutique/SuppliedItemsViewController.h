//
//  SuppliedItemsViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/26/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "TKEditViewController.h"
#import "MerchandiseItem.h"

@interface SuppliedItemsViewController : TKEditViewController

- (void)reloadData;
- (void)addMerchandiseItem:(MerchandiseItem *)item;

- (IBAction)menuButtonTapped:(id)sender;

@end
