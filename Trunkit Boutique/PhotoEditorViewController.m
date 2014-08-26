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
#import "ALAssetsLibrary+TKSingleton.h"
#import "MBProgressHUD.h"

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
    }
    return self;
}

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
    [self.useButton setEnabled:NO];
    [self savePhotoAndContinue];
}

- (void)savePhotoAndContinue
{
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHUD];
    
    // Set determinate mode
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.labelText = @"Saving Photo to Trunkit Album.";
    [progressHUD show:YES];

    UIImage *editedPhoto = [self editedPhoto];
    

    self.photoAdjustController = nil;
    self.photoCropController = nil;
    self.photo = nil;

    ALAssetsLibrary *library = [ALAssetsLibrary defaultAssetsLibrary];
    [library saveImage:editedPhoto
               toAlbum:TK_PHOTO_ALBUM_NAME
   withCompletionBlock:^(NSURL *assetURL, NSError *error) {
       [progressHUD hide:YES];
       
       if (!error && assetURL)
       {
           dispatch_queue_t queue = dispatch_queue_create("PHOTO_EDIT_LOAD_SAVED_ASSET", 0);
           dispatch_async(queue, ^{
               ALAssetsLibrary *library = [ALAssetsLibrary defaultAssetsLibrary];
               [library assetForURL:assetURL
                        resultBlock:^(ALAsset *asset) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (asset) // (![self.merchandiseItem.productPhotosTaken containsObject:asset])
                                {
                                    [self.merchandiseItem.productPhotos addObject:asset];
                                }
                                
                                NSLog(@"IMAGE LOADED FROM PHOTO ALBUM");
                                
                                if (_popToControllerOnAccept)
                                {
                                    [self.navigationController popToViewController:_popToControllerOnAccept animated:YES];
                                }
                                else
                                {
                                    [self performSegueWithIdentifier:@"PhotoEditorUsePhotoToPhotosSelectionSegueIdentifier" sender:self];
                                }
                            });
                        }
                       failureBlock:^(NSError *error)
                {
                    NSLog(@"ERROR %s: %@", __PRETTY_FUNCTION__, error);
                }];
           });

           
       }
       else
       {
           if (!assetURL)
           {
               NSLog(@"ERROR: writeImage return a nil assetURL.");
           }
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving Photo"
                                                           message:@"A system error occurred while trying to save your photo."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
           NSLog(@"Error saving asset: %@", error);
           
       }
   }];
    
    
//    [library writeImageToSavedPhotosAlbum:editedPhoto.CGImage orientation:(ALAssetOrientation)editedPhoto.imageOrientation
//                          completionBlock:^(NSURL *assetURL, NSError *error)
//     {
//         
////         [library assetForURL:assetURL
////                  resultBlock:^(ALAsset *asset) {
////          }
////                 failureBlock:^(NSError *error )
////          {
////          }];
//     }];

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
            self.imageView.image = [self editedPhotoScaledToScreen];
        };
        [vc setAdjustMode:TKPhotoAdjustCropMode];
    }
    
    // FIXME - We're commenting this out for now because of the huge memory hog it is, which
    // causes frequent crashes.
//    if (self.photoAdjustController)
//    {
//        self.photoCropController.image = (TKImage *)[self.photoAdjustController filteredImageForImage:_photo];
//    }
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
