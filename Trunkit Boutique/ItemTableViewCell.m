//
//  ItemTableViewCell.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/21/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "ALAssetsLibrary+TKSingleton.h"

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleItemPhotoTap:)];
    [self.productPhotoImageView addGestureRecognizer:tap];
    self.productPhotoImageView.userInteractionEnabled = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)countButtonTapped:(id)sender
{
    if ([_delegate respondsToSelector:@selector(itemTableViewCellCountButtonTapped:)])
    {
        [_delegate itemTableViewCellCountButtonTapped:self];
    }
}

- (IBAction)productImageTapped:(id)sender
{
    if ([_delegate respondsToSelector:@selector(itemTableViewCellProductImageTapped:)])
    {
        [_delegate itemTableViewCellProductImageTapped:self];
    }
}

- (void)handleItemPhotoTap:(UITapGestureRecognizer *)recognizer
{
    if ([_delegate respondsToSelector:@selector(itemTableViewCellProductImageTapped:)])
    {
        [_delegate itemTableViewCellProductImageTapped:self];
    }
}

@end
