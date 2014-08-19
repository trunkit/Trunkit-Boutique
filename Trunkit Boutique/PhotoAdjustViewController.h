//
//  PhotoAdjustViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/19/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//
// WARNING - This method contains some -still functional- legacy functionality:
// It was originally written to toggle between brightness/contrast and crop but is
// now loaded for either type of adjustment.

#import "TKEditViewController.h"
#import "TKCropViewController.h"
#import "GPUImage.h"
#import "ALAssetLibrary+Singleton.h"


typedef enum {
    TKPhotoAdjustBrightnessContrastMode,
    TKPhotoAdjustCropMode,
} TKPhotoAdjustMode;

@interface PhotoAdjustViewController : TKEditViewController <PECropViewControllerDelegate>

@property (strong, nonatomic) TKCropViewController *cropViewController;

@property (readwrite) TKPhotoAdjustMode adjustMode;
@property (readwrite, nonatomic) CGFloat loadSliderValue;

@property (strong, nonatomic) IBOutlet UIButton *toggleImageEditButton;
@property (strong, nonatomic) IBOutlet UIButton *cropButton;
@property (strong, nonatomic) IBOutlet GPUImageView *gpuImageView;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIView *sliderLine;
@property (strong, nonatomic) IBOutlet UIView *cropContainerView;
@property (strong, nonatomic) IBOutlet UIView *cropButtonBarView;

@property (strong, nonatomic) IBOutlet UILabel *squareLabel;
@property (strong, nonatomic) IBOutlet UILabel *portraitLabel;

@property (strong, nonatomic) ALAsset *image;

@property (nonatomic, copy) void (^setEditedPhotoOnParentController)(UIImage *, CGFloat);

//- (IBAction)toggleImageEditButtonTapped:(id)sender;
- (IBAction)sliderDragged:(id)sender;

- (IBAction)cancelEditButtonTapped:(id)sender;
- (IBAction)acceptEditButtonTapped:(id)sender;

- (IBAction)squareButtonTapped:(id)sender;
- (IBAction)portraitButtonTapped:(id)sender;

- (IBAction)TEMPconstraintButtonTapped:(id)sender;

@end
