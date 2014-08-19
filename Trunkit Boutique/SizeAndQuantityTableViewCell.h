//
//  SizeAndQuantityTableViewCell.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/22/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseItem.h"

@interface SizeAndQuantityTableViewCell : UITableViewCell

@property (strong, nonatomic) MerchandiseItem *merchandiseItem;
@property (readwrite) NSInteger sizeIndex;

@property (strong, nonatomic) IBOutlet UITextField *sizeTextField;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;

- (IBAction)sizeTextFieldDidChange:(id)sender;
- (IBAction)quantityTextFieldDidChange:(id)sender;
- (IBAction)minusButtonTapped:(id)sender;

@end
