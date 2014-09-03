//
//  SizeAndQuantityTableViewCell.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/22/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SizeAndQuantityTableViewCell.h"

@implementation SizeAndQuantityTableViewCell

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

- (IBAction)sizeTextFieldDidChange:(id)sender
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.merchandiseItem.quantityPerSizes removeObjectForKey:_sizeKey];
    self.sizeKey = self.sizeTextField.text;
    if (self.sizeTextField.text.length)
    {
        [self.merchandiseItem.quantityPerSizes setObject:[NSNumber numberWithInt:[self.quantityTextField.text intValue]] forKey:self.sizeTextField.text];
    }
}

- (IBAction)quantityTextFieldDidChange:(id)sender
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.sizeTextField.text.length)
    {
        [self.merchandiseItem.quantityPerSizes setObject:[NSNumber numberWithInt:[self.quantityTextField.text intValue]] forKey:self.sizeTextField.text];
    }
}

- (IBAction)minusButtonTapped:(id)sender
{
    NSInteger qty = [self.quantityTextField.text integerValue];
    self.quantityTextField.text = [NSString stringWithFormat:@"%d", (qty == 0) ? 0 : (qty - 1)];
    [self quantityTextFieldDidChange:nil];
}

- (void)becomeFirstResponder
{
    [self.sizeTextField becomeFirstResponder];
}

@end
