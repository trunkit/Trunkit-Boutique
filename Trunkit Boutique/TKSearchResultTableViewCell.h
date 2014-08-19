//
//  TKSearchResultTableViewCell.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/7/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kCellIDTitle = @"CellWithTitle";
static NSString * const kCellIDTitleMain = @"CellWithTitleMain";

@interface TKSearchResultTableViewCell : UITableViewCell
{
    NSString *reuseID;
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mainLabel;

@end
