//
//  ItemTableViewCell.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/21/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseItem.h"

@class ItemTableViewCell;
@protocol ItemTableViewCellDelegate <NSObject>

- (void)itemTableViewCellCountButtonTapped:(ItemTableViewCell *)cell;
- (void)itemTableViewCellProductImageTapped:(ItemTableViewCell *)cell;

@end

@interface ItemTableViewCell : UITableViewCell

@property (strong, nonatomic) MerchandiseItem *merchandiseItem;

@property (strong, nonatomic) id image;
@property (strong, nonatomic) IBOutlet UIImageView *productPhotoImageView;

@property (weak, nonatomic) id<ItemTableViewCellDelegate> delegate;

- (IBAction)countButtonTapped:(id)sender;
- (IBAction)productImageTapped:(id)sender;

@end

