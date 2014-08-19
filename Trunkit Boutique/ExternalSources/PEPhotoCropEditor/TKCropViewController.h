//
//  PECropViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/15/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKCropView;

@protocol PECropViewControllerDelegate;

@interface TKCropViewController : UIViewController

@property (nonatomic, weak) id<PECropViewControllerDelegate> delegate;
@property (nonatomic) UIImage *image;

@property (nonatomic) TKCropView *cropView;

@property (nonatomic) BOOL keepingCropAspectRatio;
@property (nonatomic) CGFloat cropAspectRatio;

@property (nonatomic) CGRect cropRect;
@property (nonatomic) CGRect imageCropRect;

@property (nonatomic) BOOL toolbarHidden;

@property (nonatomic, assign, getter = isRotationEnabled) BOOL rotationEnabled;

@property (nonatomic, readonly) CGAffineTransform rotationTransform;

@property (nonatomic, readonly) CGRect zoomedCropRect;


- (void)resetCropRect;
- (void)resetCropRectAnimated:(BOOL)animated;

- (void)constrain:(id)sender;

- (UIImage *)imageCroppedWithImage:(UIImage *)image;

@end

@protocol PECropViewControllerDelegate <NSObject>

- (void)cropViewController:(TKCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage;
- (void)cropViewControllerDidCancel:(TKCropViewController *)controller;

@end
