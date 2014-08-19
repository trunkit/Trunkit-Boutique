//
//  ItemTableViewCell.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/21/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
