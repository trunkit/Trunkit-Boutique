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

//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionContainerHeightCon;
@property (strong, nonatomic) PhotoCollectionViewController *photosCollectionController;
//@property (strong, nonatomic) PhotoScrollViewController *photoScrollViewController;
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
	TKSwipeToExpandViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TKSwipeToExpandViewControllerIdentifier"];
	[self addChildViewController:vc];
    self.photoCollectionExpanderController = vc;
    
    vc.view.frame = self.collectionContainerView.bounds;
    vc.itemPhotosContainerView = self.itemPhotosContainerView;
    [self.collectionContainerView addSubview:vc.view];
    
    
    PhotoCollectionViewController *vc3 = [sb instantiateViewControllerWithIdentifier:@"PhotoCollectionViewControllerIdentifier"];
    [vc addChildViewController:vc3];
    self.photosCollectionController = vc3;
    vc3.delegate = self;
    vc3.view.frame = vc.containerView.bounds;
    [vc.containerView addSubview:vc3.view];
//    [vc3 setPhotos:[self.merchandiseItem.productPhotosTaken mutableCopy]];
    vc3.sessionPhotos = self.merchandiseItem.productPhotosTaken;
    
    
//    PhotoScrollViewController *vc2 = [sb instantiateViewControllerWithIdentifier:@"PhotoScrollViewControllerIdentifier"];
//	[self addChildViewController:vc2];
//    self.photoScrollViewController = vc2;
//    vc2.view.frame = self.itemPhotosContainerView.bounds;
//    [self.itemPhotosContainerView addSubview:vc2.view];
    
    PhotoPagesViewController *vc2 = [sb instantiateViewControllerWithIdentifier:@"PhotoPagesViewControllerIdentifier"];
    vc2.merchandiseItem = self.merchandiseItem;
    [self addChildViewController:vc2];
    self.photoPagesViewController = vc2;
    vc2.view.frame = self.itemPhotosContainerView.bounds;
    [self.itemPhotosContainerView addSubview:vc2.view];
    
    //FIXME: TEMP CODE, we need to persist the selection
    [vc3 selectAllPhotos];
    
//    self.photoScrollViewController.photos = [self.merchandiseItem.productPhotos mutableCopy];
//    self.photoScrollViewController.photos = self.merchandiseItem.productPhotos;

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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.photoScrollViewController.view.frame = self.itemPhotosContainerView.bounds;
    self.photoPagesViewController.view.frame = self.itemPhotosContainerView.bounds;
    self.photoCollectionExpanderController.view.frame = self.collectionContainerView.bounds;
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
}

- (void)photoCollectionViewController:(PhotoCollectionViewController *)controller didDeSelectItem:(id)item
{
//    [self.photoScrollViewController removePhoto:item];
    [self.photoPagesViewController removePhoto:item];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"PhotoSelectionToPhotoCollectionEmbededSegueIdentifier"])
    {
        TKSwipeToExpandViewController *vc = (TKSwipeToExpandViewController *)segue.destinationViewController;
        vc.itemPhotosContainerView = self.itemPhotosContainerView;
    }
//    if ([segue.destinationViewController isKindOfClass:[TKSwipeToExpandViewController class]])
//    {
//        TKSwipeToExpandViewController *vc = (TKSwipeToExpandViewController *)segue.destinationViewController;
//        vc.itemPhotosContainerView = self.itemPhotosContainerView;
//    }
}

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
