//
//  PhotoScrollViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/17/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//


#import "PhotoScrollViewController.h"
#import "UIImage+TKImageScale.h"

@interface PhotoScrollViewController ()

@property (strong, nonatomic) NSMutableDictionary *cachedImages;

@end

@implementation PhotoScrollViewController

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
    
//    _assets = [@[] mutableCopy];
    _photos = [@[] mutableCopy];
    _cachedImages = [[NSMutableDictionary alloc] init];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

//- (void)setAssets:(NSMutableArray *)assets
//{
//    _assets = assets;
//    [self.collectionView reloadData];
//}

- (void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    [self.collectionView reloadData];
}

- (void)addPhoto:(id)aPhoto
{
    [self.photos addObject:aPhoto];
    [self.collectionView reloadData];
}

- (void)removePhoto:(id)aPhoto
{
    [self.photos removeObject:aPhoto];
    [self.collectionView reloadData];
}

#pragma mark - collection view data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return self.assets.count;
    return self.photos.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoScrollViewCellIdentifier" forIndexPath:indexPath];

//    ALAsset *asset = self.assets[indexPath.row];
    id photo = self.photos[indexPath.row];
    UIImage *image = nil;
    
    if ([photo isKindOfClass:[ALAsset class]])
    {
        ALAsset *asset = (ALAsset *)photo;
        image = [self.cachedImages valueForKey:[asset description]];
        if (!image)
        {
            image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
            image = [image imageScaledToQuarter];
            [self.cachedImages setValue:image forKey:[asset description]];
        }
    }
    else
    {
        image = (UIImage *)photo;
    }
    
    
    cell.image = image;
    
//    if (cell.asset != asset)
//    {
//        cell.asset = asset;
//        cell.selectionOrder = -1;
//    }
//    NSInteger index = [self.assets indexOfObject:asset];
    
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

#pragma mark - collection view delegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGFloat height = collectionView.frame.size.height;
    CGFloat width = height * .8;
    CGSize size = CGSizeMake(width, height);
    return size;
}

@end
