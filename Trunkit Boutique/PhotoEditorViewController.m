//
//  PhotoEditorViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/12/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "PhotoEditorViewController.h"
#import "PhotoAdjustViewController.h"
#import "PhotoSelectionViewController.h"
#import "UIImage+TKImageScale.h"

@interface PhotoEditorViewController ()

@property (strong, nonatomic) PhotoAdjustViewController *photoAdjustController;
@property (strong, nonatomic) PhotoAdjustViewController *photoCropController;

@end

@implementation PhotoEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        _editedPhoto = nil;
    }
    return self;
}

//- (void)setEditedPhoto:(TKImage *)editedPhoto
//{
//    _editedPhoto = editedPhoto;
//    self.imageView.image = editedPhoto;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self applyThemeToBlackButton:self.retakeButton withFontSize:14.0];
    [self applyThemeToBlackButton:self.useButton withFontSize:14.0];
    self.imageView.image = self.photo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)useButtonTapped:(id)sender
{
//    self.photoAdjustController = nil;
//    self.photoCropController = nil;
    
    // FIXME
    // TEMP
    UIImage *_editedPhoto = _photo;
    //
    //
    
    if (![self.merchandiseItem.productPhotosTaken containsObject:self.photo]
          || ![self.merchandiseItem.productPhotosTaken containsObject:_editedPhoto])
    {
        [self.merchandiseItem.productPhotosTaken addObject:(_editedPhoto) ? _editedPhoto : self.photo];
    }
    if (_popToControllerOnAccept)
    {
//        PhotoSelectionViewController *vc = (PhotoSelectionViewController *)_popToControllerOnAccept;
//        vc.
        [self.navigationController popToViewController:_popToControllerOnAccept animated:YES];
    }
    else
    {
        [self performSegueWithIdentifier:@"PhotoEditorUsePhotoToPhotosSelectionSegueIdentifier" sender:sender];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
}

- (IBAction)backButtonTapped:(id)sender
{
    self.photoAdjustController = nil;
    self.photoCropController = nil;
//    self.editedPhoto = nil;
    self.photo = nil;
    [super backButtonTapped:sender];
}

- (IBAction)adjustButtonTapped:(id)sender
{
    PhotoAdjustViewController *vc = nil;
    if (!self.photoAdjustController)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAdjustViewControllerIdentifier"];
        self.photoAdjustController = vc;
//        [self addChildViewController:vc];
        vc.image = self.photo;
        vc.setEditedPhotoOnParentController = ^void(UIImage *image, CGFloat brightness, CGFloat contrast) {
            self.imageView.image = [self editedPhotoScaledToScreen];
//            self.editedPhoto = (TKImage *)image;
//            self.brightnessAdjustment = brightness;
//            self.contrastAdjustment = contrast;
        };
    }
    if (self.photoCropController)
    {
        self.photoAdjustController.image = (TKImage *)[self.photoCropController.cropViewController imageCroppedWithImage:self.photo];
    }
    [self.navigationController pushViewController:self.photoAdjustController animated:YES];
    
}

- (IBAction)cropButtonTapped:(id)sender
{
    if (!self.photoCropController)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PhotoAdjustViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAdjustViewControllerIdentifier"];
        self.photoCropController = vc;
        [self addChildViewController:vc];
        vc.image = self.photo;
        vc.setEditedPhotoOnParentController = ^void(UIImage *image, CGFloat brightness, CGFloat contrast) {
//            self.editedPhoto = (TKImage *)image;
//            self.imageView.image = [[self.photoCropController.cropViewController imageCroppedWithImage:self.photo] scaledToScreenSize];
            self.imageView.image = [self editedPhotoScaledToScreen];
        };
        [vc setAdjustMode:TKPhotoAdjustCropMode];
    }
    if (self.photoAdjustController)
    {
        self.photoCropController.image = (TKImage *)[self.photoAdjustController filteredImageForImage:_photo];
    }
    [self.navigationController pushViewController:self.photoCropController animated:YES];
}

- (UIImage *)editedPhoto
{
    UIImage *edited = _photo;
    if (self.photoCropController)
    {
        edited = [self.photoCropController.cropViewController imageCroppedWithImage:edited];
    }
    
    if (self.photoAdjustController)
    {
        edited = [self.photoAdjustController filteredImageForImage:edited];
    }
    return edited;
}

- (UIImage *)editedPhotoScaledToScreen
{
    return [[self editedPhoto] scaledToScreenSize];
}

@end
