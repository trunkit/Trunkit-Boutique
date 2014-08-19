//
//  PhotoAdjustViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/19/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "PhotoAdjustViewController.h"
//#import "PhotoEditorViewController.h"
//#import "UIImage+AutoLevels.h"
//#import "UIImage+Brightness.h"
//#import "UIImage+Contrast.h"
#import "UIImage+TKImageScale.h"
#import "UIImage+TKCrop.h"
#import "TKCropView.h"

@interface PhotoAdjustViewController ()

@property (strong, nonatomic) GPUImagePicture *imageSource;
@property (strong, nonatomic) GPUImageFilterGroup *filterGroup;
@property (strong , nonatomic) GPUImageGammaFilter *gammaFilter;
@property (strong, nonatomic) GPUImageWhiteBalanceFilter *whiteBalanceFilter;

@property (strong, nonatomic) UIImage *workImage;

@end

@implementation PhotoAdjustViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loadSliderValue = 0.0f;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _loadSliderValue = 0.0f;
        _imageSource = nil;
        _gammaFilter = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self applyThemeToLabel:self.squareLabel withFontSize:13.0];
    [self applyThemeToLabel:self.portraitLabel withFontSize:13.0];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"SliderControlImage"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"SliderControlImage"] forState:UIControlStateHighlighted];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    GPUImageGammaFilter *theGammaFilter = [[GPUImageGammaFilter alloc] init];
    GPUImageWhiteBalanceFilter *theWhiteBalanceFilter = [[GPUImageWhiteBalanceFilter alloc] init];
    
    [theGammaFilter setGamma:1.0f];
    [theWhiteBalanceFilter setTemperature:5000];
    
    [group addFilter:theGammaFilter];
    [group addFilter:theWhiteBalanceFilter];
    
    [theGammaFilter addTarget:theWhiteBalanceFilter];
    
    [group setInitialFilters:@[theGammaFilter]];
    [group setTerminalFilter:theWhiteBalanceFilter];
    
    
    self.filterGroup = group;
    self.gammaFilter = theGammaFilter;
    self.whiteBalanceFilter = theWhiteBalanceFilter;
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.workImage];
    [stillImageSource addTarget:self.filterGroup];
    
    self.imageSource = stillImageSource;
    
    [self.filterGroup addTarget:self.gpuImageView];
    //    [self.filterGroup useNextFrameForImageCapture];
    [self.imageSource processImage];


    if (_adjustMode == TKPhotoAdjustCropMode)
    {
        //FIXME Dup code
        
        UIImage *image = _image;
        if (_loadSliderValue != 0)
        {
            self.slider.value = _loadSliderValue;
            [self sliderDragged:nil];
            image = [self filteredImage];
        }
        [self resetViewForToggleEditState:YES];
        [self loadCropControllerWithImage:image];
    }
    else
    {
        @autoreleasepool {
        }
        [self resetViewForToggleEditState:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.image = nil;
//    
//    self.imageSource = nil;
//    self.filterGroup = nil;
//    self.gammaFilter = nil;
//    self.whiteBalanceFilter = nil;
}

- (UIImage *)filteredImage
{
    UIImage *image = [self.filterGroup imageByFilteringImage:_image];
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
    return image;
}

- (void)setGPUImageViewForSliderValue:(CGFloat)sliderValue
{
    CGFloat filterValue = 0.0f;
    
    
    if (sliderValue > 0)
    {
//        if (sliderValue > .2)
//        {
//            sliderValue = .2 + ((sliderValue - .2) / 2);
//        }
        
        filterValue = sliderValue + 1;
        
        [self.gammaFilter setGamma:filterValue];
        [self.imageSource processImage];
    }
    else if (sliderValue < 0)
    {
        filterValue = 5000 + ABS(sliderValue * 2500);
        [self.whiteBalanceFilter setTemperature:filterValue];
        [self.imageSource processImage];
    }
}

- (void)setLoadSliderValue:(CGFloat)loadSliderValue
{
    _loadSliderValue = loadSliderValue;
    
    if (loadSliderValue != 0)
    {
        self.slider.value = _loadSliderValue;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    CGFloat width = 320.0f;
    CGFloat height = image.size.height * (320 / image.size.width);
    self.workImage = [self image:_image scaledToSize:CGSizeMake(width, height)];
    
    if (self.workImage && self.filterGroup)
    {
        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.workImage];
        [stillImageSource addTarget:self.filterGroup];
        
        self.imageSource = stillImageSource;
        [self.imageSource processImage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
}

- (IBAction)toggleImageEditButtonTapped:(id)sender
{
    self.toggleImageEditButton.selected = !self.toggleImageEditButton.selected;
    [self resetViewForToggleEditState:self.toggleImageEditButton.selected];
    
    if (self.toggleImageEditButton.selected)
    {
//        UIImage *image = [self.image imageWithContrast:(self.slider.value + 1) brightness:self.slider.value];
        if (!self.cropViewController)
        {
            [self loadCropControllerWithImage:[self filteredImage]];
        }
        self.cropViewController.image = [self filteredImage];
    }
    else
    {
        UIImage *croppedImage = [self.image rotatedImageWithtransform:((TKCropView *)self.cropViewController.cropView).rotation
                                                        croppedToRect:self.cropViewController.cropView.zoomedCropRect];
        croppedImage = [croppedImage imageScaledToQuarter];
        self.workImage = croppedImage;
        [self sliderDragged:self];
    }
}

- (void)loadCropControllerWithImage:(UIImage *)image
{
    TKCropViewController *vc = [[TKCropViewController alloc] init];
    vc.delegate = self;
    vc.view.frame = self.cropContainerView.bounds;
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    vc.imageCropRect = CGRectMake((width - length) / 2,
                                  (height - length) / 2,
                                  length,
                                  length);
    
    [self.cropContainerView addSubview:vc.view];
    self.cropViewController = vc;
    self.cropViewController.image = image;
}

- (IBAction)cancelEditButtonTapped:(id)sender
{
    [self.navigationController popToViewController:self animated:YES];
}

- (IBAction)acceptEditButtonTapped:(id)sender
{
//    CGFloat contrast = (self.slider.value + 1);
//    CGFloat brightness = self.slider.value;
//    
//    //FIXME: We're forced to scale the image, the contrast method has a bug that resizes very large images...
//    UIImage *image = [[_image imageScaledToHalf] imageWithContrast:contrast brightness:brightness];
    
    UIImage *image = [self filteredImage];
    
    
    //FIXME: Add crop
    if (_adjustMode == TKPhotoAdjustCropMode)
    {
        image = self.cropViewController.cropView.croppedImage;
    }
    
    self.setEditedPhotoOnParentController(image, 0, 0);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetViewForToggleEditState:(BOOL)selected
{
    self.toggleImageEditButton.hidden = selected;
    self.cropButton.hidden = !selected;
    self.slider.hidden = selected;
//    self.imageView.hidden = selected;
    self.gpuImageView.hidden = selected;
    self.cropContainerView.hidden = !selected;
    self.cropButtonBarView.hidden = !selected;
}

- (IBAction)sliderDragged:(id)sender
{
    CGPoint center = self.slider.center;
    CGFloat length = (self.slider.value == 0) ? 0 : ABS(self.slider.value * ((self.slider.frame.size.width - 16) / 2)) - 8;
    if (length < 0)
        length = 0;
    
    CGRect lineFrame = CGRectMake(center.x, center.y - 0, length, 1.5f);
    
    if (self.slider.value < 0)
    {
        lineFrame.origin.x -= length;
    }
    self.sliderLine.frame = lineFrame;
    
    [self setGPUImageViewForSliderValue:self.slider.value];
}

- (IBAction)squareButtonTapped:(id)sender
{
    [self.cropViewController setCropAspectRatio:1.0];
}

- (IBAction)portraitButtonTapped:(id)sender
{
    [self.cropViewController setCropAspectRatio:(80.0/97.9)];
}

- (IBAction)TEMPconstraintButtonTapped:(id)sender
{
    [self.cropViewController constrain:sender];
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(TKCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
}

- (void)cropViewControllerDidCancel:(TKCropViewController *)controller
{
}

#pragma mark Convenience

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

@end
