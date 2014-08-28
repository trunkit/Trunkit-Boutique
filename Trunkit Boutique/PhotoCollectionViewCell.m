//
//  PhotoCollectionViewCell.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "PhotoCollectionViewCell.h"



@interface PhotoCollectionViewCell ()

@property(nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIView *selectionView;
@property (strong, nonatomic) IBOutlet UILabel *selectionOrderLabel;

@end

@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void) setAsset:(ALAsset *)asset
{
    _asset = asset;
    self.photoImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];

    UIFont *countFont = [UIFont fontWithName:@"BebasNeue" size:15.0];
    self.selectionOrderLabel.font = countFont;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.photoImageView.image = image;
    
    UIFont *countFont = [UIFont fontWithName:@"BebasNeue" size:15.0];
    self.selectionOrderLabel.font = countFont;
}

- (void)setSelectionOrder:(NSInteger)selectionOrder
{
    if (selectionOrder < 1)
    {
        self.selectionView.hidden = YES;
        self.photoImageView.layer.borderWidth = 0.0f;
//        self.photoImageView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    else
    {
        self.selectionView.hidden = NO;
        self.selectionOrderLabel.text = [NSString stringWithFormat:@"%ld", (long)selectionOrder];
        self.photoImageView.layer.borderWidth = 1.5f;
        self.photoImageView.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s - %@", __PRETTY_FUNCTION__, event);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end

