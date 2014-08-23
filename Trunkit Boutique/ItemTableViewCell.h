//
//  ItemTableViewCell.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/21/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseItem.h"

@interface ItemTableViewCell : UITableViewCell

@property (strong, nonatomic) MerchandiseItem *merchandiseItem;

@property (strong, nonatomic) id image;
@property (strong, nonatomic) IBOutlet UIImageView *productPhotoImageView;

@end
