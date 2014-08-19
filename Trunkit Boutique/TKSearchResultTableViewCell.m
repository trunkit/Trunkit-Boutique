//
//  TKSearchResultTableViewCell.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/7/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "TKSearchResultTableViewCell.h"

@implementation TKSearchResultTableViewCell

@synthesize nameLabel = nameLabel;
@synthesize mainLabel = mainLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        reuseID = reuseIdentifier;
        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:nameLabel];
        
        mainLabel = [[UILabel alloc] init];
        [mainLabel setTextColor:[UIColor blackColor]];
        [mainLabel setBackgroundColor:[UIColor colorWithHue:66 saturation:100 brightness:63 alpha:1]];
        [mainLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
        [mainLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:mainLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(nameLabel, mainLabel);
        if (reuseID == kCellIDTitle) {
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nameLabel]|"
                                                                           options: 0
                                                                           metrics:nil
                                                                             views:views];
            [self.contentView addConstraints:constraints];
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel]|"
                                                                  options: 0
                                                                  metrics:nil
                                                                    views:views];
            [self.contentView addConstraints:constraints];
        }
        if (reuseID == kCellIDTitleMain) {
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nameLabel]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
            [self.contentView addConstraints:constraints];
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mainLabel]|"
                                                                  options: 0
                                                                  metrics:nil
                                                                    views:views];
            [self.contentView addConstraints:constraints];
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel][mainLabel(==nameLabel)]|"
                                                                  options: 0
                                                                  metrics:nil
                                                                    views:views];
            [self.contentView addConstraints:constraints];
            
        }
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
