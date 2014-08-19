//
//  PhotoCollectionViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+TKImageScale.h"



@interface PhotoCollectionViewController ()

@property(nonatomic, strong) IBOutlet TKCollectionView *collectionView;
@property(strong, nonatomic) NSMutableArray *photos;
//@property(nonatomic, strong) NSArray *assets;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;


@end

@implementation PhotoCollectionViewController

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
    _selectedAssets = [@[] mutableCopy];
    
//    UIPanGestureRecognizer *feedPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerSwipe:)];
//    [feedPanRecognizer setMinimumNumberOfTouches:1];
//    [feedPanRecognizer setMaximumNumberOfTouches:3];
//    [feedPanRecognizer setDelaysTouchesBegan:YES];
//	[self.collectionView addGestureRecognizer:feedPanRecognizer];
    
//    NSArray *recos = self.collectionView.gestureRecognizers;
//    NSLog(@"RECOS = %@", recos);
}

//- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
//{
//    [super handlePan:gestureRecognizer];
//    
//}

//- (void)handleTwoFingerSwipe:(UIPanGestureRecognizer *)gestureRecognizer
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    NSLog(@"Collection View frame : (%f, %f, %f, %f)", self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);

}

- (void)setSessionPhotos:(NSMutableArray *)sessionPhotos
{
    _sessionPhotos = sessionPhotos;
    self.photos = [_sessionPhotos mutableCopy];
    [self.collectionView reloadData];
    
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    // 1
    ALAssetsLibrary *assetsLibrary = [PhotoCollectionViewController defaultAssetsLibrary];
    NSLog(@"Assets load");
    // 2
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                // 3
                [tmpAssets addObject:result];
            }
        }];
        
        // 4
        //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        //self.assets = [tmpAssets sortedArrayUsingDescriptors:@[sort]];
        [self.photos addObjectsFromArray:tmpAssets];
//        self.assets = tmpAssets;
        NSLog(@"Assets loaded %d", tmpAssets.count);
        
        // 5
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
    
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

- (void)selectAllPhotos
{
    self.selectedAssets = [self.sessionPhotos mutableCopy];
    if ([_delegate respondsToSelector:@selector(photoCollectionViewController:didChangeSelection:)])
    {
        [_delegate photoCollectionViewController:self didChangeSelection:self.selectedAssets];
    }

}


#pragma mark - collection view data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return self.assets.count;
    return self.photos.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    id photo = self.photos[indexPath.row];
    UIImage *image = nil;
    
    if ([photo isKindOfClass:[ALAsset class]])
    {
        ALAsset *asset = (ALAsset *)photo;
        image = [self.cachedImages valueForKey:[asset description]];
        if (!image)
        {
            image = [UIImage imageWithCGImage:[asset thumbnail]];
//            image = [image imageScaledToQuarter];
//            [self.cachedImages setValue:image forKey:[asset description]];
        }
//        if (cell.asset != asset)
//        {
//            cell.asset = asset;
//        }

    }
    else
    {
        image = (UIImage *)photo;
    }
    [cell setImage:image];

//    cell.imageFormatIdentifier = @"thumbnail";
//    ALAsset *asset = self.assets[indexPath.row];
//    if (cell.asset != asset)
//    {
//        cell.asset = asset;
//    }
//    NSInteger index = [self.selectedAssets indexOfObject:asset];
    NSInteger index = [self.selectedAssets indexOfObject:photo];
    cell.selectionOrder = (index == NSNotFound) ? -1 : index + 1;
    
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    ALAsset *asset = self.assets[indexPath.row];
    id photo = self.photos[indexPath.row];

    NSInteger index = [self.selectedAssets indexOfObject:photo];
    if (index == NSNotFound)
    {
        [self.selectedAssets addObject:photo];
        if ([_delegate respondsToSelector:@selector(photoCollectionViewController:didSelectItem:)])
        {
            [_delegate photoCollectionViewController:self didSelectItem:photo];
        }
    }
    else
    {
        [self.selectedAssets removeObject:photo];
        if ([_delegate respondsToSelector:@selector(photoCollectionViewController:didDeSelectItem:)])
        {
            [_delegate photoCollectionViewController:self didDeSelectItem:photo];
        }
    }
    // FIXME: Be more efficient and reload only the selected items to
    // reset the selection order label
    [self.collectionView reloadData];
    if ([_delegate respondsToSelector:@selector(photoCollectionViewController:didChangeSelection:)])
    {
        [_delegate photoCollectionViewController:self didChangeSelection:self.selectedAssets];
    }
//    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    
//    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
//    UIImage *image = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
    // Do something with the image
}

#pragma mark - assets

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
