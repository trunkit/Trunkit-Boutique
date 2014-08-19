//
//  UIImage+TKCrop.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/15/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//


#import "UIImage+TKCrop.h"

@implementation UIImage (TKCrop)

- (UIImage *)rotatedImageWithtransform:(CGAffineTransform)rotation
                         croppedToRect:(CGRect)rect
{
    UIImage *rotatedImage = [self pe_rotatedImageWithtransform:rotation];
    
    CGFloat scale = rotatedImage.scale;
    CGRect cropRect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(scale, scale));
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect(rotatedImage.CGImage, cropRect);
    UIImage *image = [UIImage imageWithCGImage:croppedImage scale:self.scale orientation:rotatedImage.imageOrientation];
    CGImageRelease(croppedImage);
    
    return image;
}

- (UIImage *)pe_rotatedImageWithtransform:(CGAffineTransform)transform
{
    CGSize size = self.size;
    
    UIGraphicsBeginImageContextWithOptions(size,
                                           YES,                     // Opaque
                                           self.scale);             // Use image scale
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, size.width / 2, size.height / 2);
    CGContextConcatCTM(context, transform);
    CGContextTranslateCTM(context, size.width / -2, size.height / -2);
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return rotatedImage;
}

@end
