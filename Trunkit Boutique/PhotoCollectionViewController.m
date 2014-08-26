//
//  PhotoCollectionViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "ALAssetsLibrary+TKSingleton.h"
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
//    self.photos = [@[] mutableCopy];
    [self.collectionView reloadData];
    
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSAssert(![NSThread isMainThread], @"This would create a deadlock (main thread waiting for main thread to complete)");
        
        ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary defaultAssetsLibrary];
        NSLog(@"Assets load");
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            NSLog(@"GROUP = %@", group);
            if (![[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:TK_PHOTO_ALBUM_NAME])
            {
                return;
            }
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if(result)
                {
                    [tmpAssets addObject:result];
                    NSLog(@"Asset loaded %@", result);
                }
                else
                {
                    for (ALAsset *anAsset in tmpAssets)
                    {
                        NSLog(@"URL = %@", anAsset.defaultRepresentation.url);
                        
                        NSArray * filtered = [_photos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"defaultRepresentation.url == %@", anAsset.defaultRepresentation.url]];
                        
                        if (!filtered.count)
                        {
                            [self.photos addObject:anAsset];
                        }
                    }
                    
                    // Put the session photos up front
                    //
                    NSLog(@"SESSION PHOTOS = %@", sessionPhotos);
                    for (NSInteger index = 0; index < sessionPhotos.count; index++)
                    {
                        NSURL *url = nil;
                        id image = [sessionPhotos objectAtIndex:index];
                        if ([image isKindOfClass:[ALAsset class]])
                        {
                            url = ((ALAsset *) image).defaultRepresentation.url;
                        }
                        else
                        {
                            url = image;
                        }
                        NSInteger currentIndex = NSNotFound;
                        
                        NSIndexSet *indexSet = [_photos indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                            return [((ALAsset *)obj).defaultRepresentation.url.absoluteString isEqualToString:url.absoluteString];
                        }];
                        
                        currentIndex = indexSet.firstIndex;
                        
                        if (currentIndex != NSNotFound)
                        {
                            ALAsset *aSessionPhoto = [_photos objectAtIndex:currentIndex];
                            [self.photos removeObject:aSessionPhoto];
                            [self.photos insertObject:aSessionPhoto atIndex:index];
                            
                            if (![_selectedAssets containsObject:aSessionPhoto])
                            {
                                [self setPhoto:aSessionPhoto selected:YES];
                            }
//                            // Automatically select the last photo that was just taken
//                            if (index == sessionPhotos.count - 1)
//                            {
//                                if (![_selectedAssets containsObject:aSessionPhoto])
//                                {
//                                    [self setPhoto:aSessionPhoto selected:YES];
//                                }
//                            }
                        }
                        else
                        {
                            NSLog(@"WARNING: An asset was not loaded for a session photo with URL %@", url);
                            continue;
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.collectionView reloadData];
                    });
                }
            }];
        }
                                   failureBlock:^(NSError *error) {
                                       NSLog(@"Error loading images %@", error);
                                   }];
    });

    
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
    //FIXME DISABLED FOR NOW - WIP
    //
    
//    self.selectedAssets = [self.sessionPhotos mutableCopy];
//    if ([_delegate respondsToSelector:@selector(photoCollectionViewController:didChangeSelection:)])
//    {
//        [_delegate photoCollectionViewController:self didChangeSelection:self.selectedAssets];
//    }

}

- (void)setPhoto:(ALAsset *)photo selected:(BOOL)selected
{
    if (selected)
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
    ALAsset *asset = nil;
    
    if ([photo isKindOfClass:[ALAsset class]])
    {
        asset = (ALAsset *)photo;
        [cell setAsset:asset];
    }
    else if ([photo isKindOfClass:[NSURL class]])
    {
        asset = [self.cachedImages valueForKey:[photo absoluteString]];
        if (!asset)
        {
            ALAssetsLibrary *library = [ALAssetsLibrary defaultAssetsLibrary];
            [library assetForURL:photo
                     resultBlock:^(ALAsset *anAsset) {
                         [cell setAsset:anAsset];
                         [self.cachedImages setObject:anAsset forKey:[photo absoluteString]];
                     }
                    failureBlock:^(NSError *error )
             {
             }];

        }
    }
    
    NSIndexSet *indexSet = [_selectedAssets indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [((ALAsset *)obj).defaultRepresentation.url.absoluteString isEqualToString:asset.defaultRepresentation.url.absoluteString];
    }];
    
    NSUInteger selectionIndex = indexSet.firstIndex;
    cell.selectionOrder = (selectionIndex == NSNotFound) ? -1 : selectionIndex + 1;
    
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
        [self setPhoto:photo selected:YES];
    }
    else
    {
        [self setPhoto:photo selected:NO];
    }
    
    // FIXME: Be more efficient and reload only the selected items to
    // reset the selection order label
    [self.collectionView reloadData];
    if ([_delegate respondsToSelector:@selector(photoCollectionViewController:didChangeSelection:)])
    {
        [_delegate photoCollectionViewController:self didChangeSelection:self.selectedAssets];
    }
}

@end
