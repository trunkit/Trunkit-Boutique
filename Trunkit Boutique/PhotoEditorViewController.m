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

@interface PhotoEditorViewController ()

//@property (strong, nonatomic) PhotoAdjustViewController *photoAdjustController;
@property (strong, nonatomic) PhotoAdjustViewController *photoCropController;
@property (nonatomic) CGFloat filterSliderValue;

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
        _editedPhoto = nil;
        _filterSliderValue = 1;
    }
    return self;
}

- (void)setEditedPhoto:(UIImage *)editedPhoto
{
    _editedPhoto = editedPhoto;
    self.imageView.image = editedPhoto;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self applyThemeToBlackButton:self.retakeButton withFontSize:14.0];
    [self applyThemeToBlackButton:self.useButton withFontSize:14.0];
    self.imageView.image = [UIImage imageWithCGImage:[[self.photo defaultRepresentation] fullScreenImage]];
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
//    self.photoAdjustController = nil;
    self.photoCropController = nil;
    self.editedPhoto = nil;
    self.photo = nil;
    [super backButtonTapped:sender];
}

- (IBAction)adjustButtonTapped:(id)sender
{
    PhotoAdjustViewController *vc = nil;
//    if (!self.photoAdjustController)
//    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAdjustViewControllerIdentifier"];
//        [self addChildViewController:vc];
        vc.image = self.photo;
        vc.setEditedPhotoOnParentController = ^void(UIImage *image, CGFloat filterSliderValue) {
            self.editedPhoto = image;
            self.filterSliderValue = filterSliderValue;
        };
//        self.photoAdjustController = vc;
//    }
    if (self.photoCropController)
    {
        vc.image = [self.photoCropController.cropViewController imageCroppedWithImage:self.photo];
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)cropButtonTapped:(id)sender
{
//    if (!self.photoCropController)
//    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PhotoAdjustViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAdjustViewControllerIdentifier"];
        [self addChildViewController:vc];
        vc.image = self.photo;
        vc.setEditedPhotoOnParentController = ^void(UIImage *image, CGFloat filterSliderValue) {
            self.editedPhoto = image;
        };
        [vc setAdjustMode:TKPhotoAdjustCropMode];
//        self.photoCropController = vc;
//    }
//    if (self.photoAdjustController)
//    {
        vc.loadSliderValue = self.filterSliderValue;
//    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
