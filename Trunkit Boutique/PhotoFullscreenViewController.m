//
//  PhotoFullscreenViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 9/3/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "PhotoFullscreenViewController.h"
#import "PhotoPagesViewController.h"

@interface PhotoFullscreenViewController()

@property (strong, nonatomic) PhotoPagesViewController *photoPagesViewController;

@end

@implementation PhotoFullscreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoPagesViewController *pages = [sb instantiateViewControllerWithIdentifier:@"PhotoPagesViewControllerIdentifier"];
    [pages setUsesMerchandiseProductPhotos:YES];
    pages.merchandiseItem = self.merchandiseItem;
    self.photoPagesViewController = pages;
    pages.view.frame = self.itemPhotosContainerView.bounds;
    [self.itemPhotosContainerView addSubview:pages.view];
}

@end
