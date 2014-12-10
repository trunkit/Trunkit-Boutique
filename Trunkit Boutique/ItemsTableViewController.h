//
//  ItemsTableViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/1/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseItem.h"
#import "ItemTableViewCell.h"
#import "TrunkitService.h"
#import "MBProgressHUD.h"

@interface ItemsTableViewController : UITableViewController <ItemTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *merchandiseItems;

- (void)addMerchandiseItem:(MerchandiseItem *)item;

@end
