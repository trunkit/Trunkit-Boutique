//
//  SizeAndQuantityTableViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/5/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseItem.h"

@interface SizeAndQuantityTableViewController : UITableViewController

@property (strong, nonatomic) MerchandiseItem *merchandiseItem;
@property (readwrite, nonatomic) BOOL hasMinusButton;

//@property (strong, nonatomic) NSMutableArray *sizesAndQuantities;

@end
