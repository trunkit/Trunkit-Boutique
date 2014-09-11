//
//  PhotoSelectionViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/12/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "PhotoSelectionViewController.h"
#import "CameraViewController.h"
#import "TKSwipeToExpandViewController.h"
//#import "PhotoCollectionViewController.h"

@interface PhotoSelectionViewController ()

@property (strong, nonatomic) PhotoCollectionViewController *photosCollectionController;
@property (strong, nonatomic) PhotoPagesViewController  *photoPagesViewController;
@property (strong, nonatomic) TKSwipeToExpandViewController *photoCollectionExpanderController;

@end

@implementation PhotoSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self applyThemeToBlackButton:self.takeButton withFontSize:14.0];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	TKSwipeToExpandViewController *expander = [sb instantiateViewControllerWithIdentifier:@"TKSwipeToExpandViewControllerIdentifier"];
    self.photoCollectionExpanderController = expander;
    expander.view.frame = self.collectionContainerView.bounds;
    [self.collectionContainerView addSubview:expander.view];
    
    
    PhotoCollectionViewController *collection = [sb instantiateViewControllerWithIdentifier:@"PhotoCollectionViewControllerIdentifier"];
    self.photosCollectionController = collection;
    collection.delegate = self;
    collection.view.frame = expander.containerView.bounds;
    [expander.containerView addSubview:collection.view];
    expander.collectionView = collection.collectionView;
    
    // FIXME: Add persisted selected photos

    //FIXME Shitty property name,
    collection.sessionPhotos = self.merchandiseItem.productPhotos;
    
    
    

    PhotoPagesViewController *pages = [sb instantiateViewControllerWithIdentifier:@"PhotoPagesViewControllerIdentifier"];
    pages.merchandiseItem = self.merchandiseItem;
    self.photoPagesViewController = pages;
    pages.view.frame = expander.pagesContainerView.bounds;
    [expander.pagesContainerView addSubview:pages.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.photosCollectionController.sessionPhotos = self.merchandiseItem.productPhotosTaken;
}

- (BOOL)singleTapDiscardsKeyboard
{
    // Avoid messing up with the selection on the UICollectionView
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PhotoCollection Delegate

- (void)photoCollectionViewController:(PhotoCollectionViewController *)controller didChangeSelection:(NSArray *)selectedAssets
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    self.photoScrollViewController.photos = [selectedAssets mutableCopy];
}

- (void)photoCollectionViewController:(PhotoCollectionViewController *)controller didSelectItem:(id)item
{
//    [self.photoScrollViewController addPhoto:item];
    [self.photoPagesViewController addPhoto:item];
    self.merchandiseItem.productPhotos = [self.photosCollectionController.selectedAssets mutableCopy];
}

- (void)photoCollectionViewController:(PhotoCollectionViewController *)controller didDeSelectItem:(id)item
{
//    [self.photoScrollViewController removePhoto:item];
    [self.photoPagesViewController removePhoto:item];
    self.merchandiseItem.productPhotos = [self.photosCollectionController.selectedAssets mutableCopy];
}

#pragma mark - Navigation

- (IBAction)takeButtonTapped:(id)sender
{
    [self takeActionWithBackController:nil];
}

- (IBAction)takeButtonFromReviewTapped:(id)sender
{
    [self takeActionWithBackController:self];
}

- (void)takeActionWithBackController:(UIViewController *)viewController
{
    self.merchandiseItem.productPhotos = [self.photosCollectionController.selectedAssets mutableCopy];
    CameraViewController *cameraVC = nil;
    if (!viewController)
    {
        for (UIViewController *vc in self.navigationController.viewControllers)
        {
            if ([vc isKindOfClass:[CameraViewController class]])
            {
                cameraVC = (CameraViewController *)vc;
                cameraVC.popToControllerOnAccept = viewController;
            }
        }
        if (!cameraVC)
        {
            NSLog(@"WARNING: %s Could not find a CameraViewController to navigate back to.", __PRETTY_FUNCTION__);
            return;
        }
        [self.navigationController popToViewController:cameraVC animated:YES];
    }
    else
    {
        //CameraViewControllerIdentifier
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        cameraVC = [sb instantiateViewControllerWithIdentifier:@"CameraViewControllerIdentifier"];
        cameraVC.popToControllerOnAccept = viewController;
        cameraVC.merchandiseItem = self.merchandiseItem;
        [self.navigationController pushViewController:cameraVC animated:YES];
    }
}

- (void)continueButtonTapped:(id)sender
{
    self.merchandiseItem.productPhotos = [self.photosCollectionController.selectedAssets mutableCopy];
    [self performSegueWithIdentifier:@"PhotosSelectionControllerToNewItemPage2ControllerSegueIdentifier" sender:sender];
}

@end
