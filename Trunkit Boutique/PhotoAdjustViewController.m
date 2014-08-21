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
#import "UIImage+TKImageScale.h"

@interface PhotoAdjustViewController ()

@property (strong, nonatomic) GPUImagePicture *imageSource;
@property (strong, nonatomic) GPUImageFilterGroup *filterGroup;
@property (strong , nonatomic) GPUImageGammaFilter *gammaFilter;
@property (strong, nonatomic) GPUImageWhiteBalanceFilter *whiteBalanceFilter;

@property (strong, nonatomic) TKImage *workImage;

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
    
    [self resetViewForToggleEditState:(_adjustMode == TKPhotoAdjustCropMode)];
    
    [self applyThemeToLabel:self.squareLabel withFontSize:13.0];
    [self applyThemeToLabel:self.portraitLabel withFontSize:13.0];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"SliderControlImage"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"SliderControlImage"] forState:UIControlStateHighlighted];
    


    if (_adjustMode == TKPhotoAdjustCropMode)
    {
        UIImage *image = _image;
//        if (_loadSliderValue != 0)
//        {
//            self.slider.value = _loadSliderValue;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self sliderDragged:self.slider];
//            });
//            image = [self filteredImage];
//        }
        [self loadCropControllerWithImage:image];
    }
    else
    {
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
    return [self filteredImageForImage:_image];
}

- (UIImage *)filteredImageForImage:(UIImage *)image
{
    UIImage *filtered = [self.filterGroup imageByFilteringImage:image];
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
    return filtered;
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

- (void)setImage:(TKImage *)image
{
    _image = image;
    
    
    
    if (_adjustMode == TKPhotoAdjustBrightnessContrastMode)
    {
//        CGFloat screenScale = [[UIScreen mainScreen] scale];
//        CGRect screenBounds = [[UIScreen mainScreen] bounds];
//        CGFloat width = screenBounds.size.width * screenScale;
//        CGFloat height = image.size.height * (width / image.size.width);
//        self.workImage = (TKImage *)[_image scaledToSize:CGSizeMake(width, height)];
        self.workImage = (TKImage *)[_image scaledToScreenSize];
        
        if (self.workImage && self.filterGroup)
        {
            GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.workImage];
            [stillImageSource addTarget:self.filterGroup];
            
            self.imageSource = stillImageSource;
            [self.imageSource processImage];
        }
    }
    else
    {
        self.cropViewController.image = _image;
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
        self.workImage = (TKImage *)croppedImage;
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
    UIImage *image = nil;
    
//    if (_adjustMode == TKPhotoAdjustCropMode)
//    {
//        image = self.cropViewController.cropView.croppedImage;
//    }
//    else
//    {
//        image = [self filteredImage];
//    }
    
    self.setEditedPhotoOnParentController(image, 0, 0);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetViewForToggleEditState:(BOOL)selected
{
    self.toggleImageEditButton.hidden = selected;
    self.cropButton.hidden = !selected;
    self.slider.hidden = selected;
    self.sliderLine.hidden = selected;
    self.sliderDot.hidden = selected;
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

@end
