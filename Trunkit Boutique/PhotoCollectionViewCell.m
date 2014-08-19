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
        // Initialization code
    }
    return self;
}

- (void) setAsset:(ALAsset *)asset
{
    _asset = asset;
    if ([self.imageFormatIdentifier isEqualToString:@"thumbnail"])
    {
        self.photoImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
        return;
    }
//    self.photoImageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];


//    CGImageRef iref = [asset aspectRatioThumbnail];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
////        UIImage itemImage = [[UIImageView alloc] initWithFrame:CGRectMake([arrayIndex intValue]*320, 0, 320, 320)];
//        UIImage *itemImage = [UIImage imageWithCGImage:iref];
//        self.photoImageView.image = itemImage;
//        
//    });//end block

    
//    UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
////    image.size = CGSizeMake(100, 100);
////    NSData *imgData= UIImageJPEGRepresentation(image,50 /*compressionQuality*/);
////    UIImage *compImage = [image imageScaledToQuarter];
//    self.photoImageView.image = compImage;
//    
////    ALAssetRepresentation *representation = [asset defaultRepresentation];
////    self.photoImageView.image = [UIImage imageWithCGImage:representation.fullResolutionImage
////                               scale:.1
////                         orientation:(UIImageOrientation)[representation orientation]];
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

