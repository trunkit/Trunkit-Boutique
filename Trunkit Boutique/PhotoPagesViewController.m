//
//  PhotoPagesViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/3/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "PhotoPagesViewController.h"
#import "PhotoSlideViewController.h"

@interface PhotoPagesViewController ()

@property (strong, nonatomic) NSArray *photos;

@end

@implementation PhotoPagesViewController

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
        _usesMerchandiseProductPhotos = NO;
        [self setDataSource:self];
        [self setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UIPageControl *pageControlAppearance = [UIPageControl appearanceWhenContainedIn:[UIPageViewController class], nil];
//    pageControlAppearance.pageIndicatorTintColor = [UIColor lightGrayColor];
//    pageControlAppearance.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMerchandiseItem:(MerchandiseItem *)merchandiseItem
{
    _merchandiseItem = merchandiseItem;
    if (_usesMerchandiseProductPhotos)
    {
        self.photos = _merchandiseItem.productPhotos;
    }
    else
    {
        self.photos = _merchandiseItem.productPhotosTaken;
    }
}

- (void)setUsesMerchandiseProductPhotos:(BOOL)usesMerchandiseProductPhotos
{
    _usesMerchandiseProductPhotos = usesMerchandiseProductPhotos;
    if (_usesMerchandiseProductPhotos)
    {
        self.photos = _merchandiseItem.productPhotos;
    }
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
//    self.dataSource = nil;
    
//    PhotoSlideViewController *initialVC = [self viewControllerForPhotoAtIndex:0];
    PhotoSlideViewController *initialVC = nil;
    
    if (_photos.count)
    {
        initialVC = [self viewControllerForPhotoAtIndex:(_photos.count - 1)];
    }
    
    if (!initialVC)
    {
        initialVC = [[PhotoSlideViewController alloc] init];
    }

//    __weak typeof(self) weakSelf = self;
    
    [self setViewControllers:@[initialVC]
                   direction:UIPageViewControllerNavigationDirectionForward|UIPageViewControllerNavigationDirectionReverse
                    animated:NO
                  completion:^(BOOL finished) {
//                      __strong typeof(weakSelf) strongSelf = weakSelf;
//                      if (strongSelf) {
//                          strongSelf.dataSource = nil;
//                          strongSelf.dataSource = strongSelf;
//                      }
                  }];
//    self.dataSource = self;

}

- (void)addPhoto:(id)photo
{
    self.photos = [_photos arrayByAddingObject:photo];
}

- (void)removePhoto:(id)photo
{
    if ([_photos containsObject:photo])
    {
        NSMutableArray *tempPhotos = [_photos mutableCopy];
        [tempPhotos removeObject:photo];
        self.photos = [NSArray arrayWithArray:tempPhotos];
        
//        NSMutableArray *tempPhotos = [[NSMutableArray alloc] init];
//        NSInteger index = 0;
//        
//        for (id aPhoto in _photos)
//        {
//            if (aPhoto != photo)
//            {
//                [tempPhotos addObject:[self viewControllerForPhotoAtIndex:index]];
//            }
//            index++;
//        }
//        self.photos = [NSArray arrayWithArray:tempPhotos];

    }
}

//- (NSArray *)photos
//{
//    return _merchandiseItem.productPhotosTaken;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Delegate


#pragma mark Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"%s Asked what's After %d", __PRETTY_FUNCTION__, ((PhotoSlideViewController *)viewController).slideIndex);
    
    NSInteger imageIndex = 0;
    if ([viewController isKindOfClass:[PhotoSlideViewController class]])
    {
        
        PhotoSlideViewController *vc = (PhotoSlideViewController *)viewController;
        if (vc.slideIndex < (self.photos.count -1))
        {
            imageIndex = vc.slideIndex + 1;
            return [self viewControllerForPhotoAtIndex:imageIndex];
        }
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"%s Asked what's Before %d", __PRETTY_FUNCTION__, ((PhotoSlideViewController *)viewController).slideIndex);
    
    NSInteger imageIndex = 0;
    if ([viewController isKindOfClass:[PhotoSlideViewController class]])
    {
        
        PhotoSlideViewController *vc = (PhotoSlideViewController *)viewController;
        if (vc.slideIndex > 0)
        {
            imageIndex = vc.slideIndex - 1;
            return [self viewControllerForPhotoAtIndex:imageIndex];
        }
    }
    return nil;
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return self.photos.count;
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
////    return self.photos.count;
//}

- (PhotoSlideViewController *)viewControllerForPhotoAtIndex:(NSInteger)index
{
    if (!_photos.count
        || index > _photos.count)
    {
        return nil;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	PhotoSlideViewController *newVC = [sb instantiateViewControllerWithIdentifier:@"PhotoSlideViewControllerIdentifier"];
    newVC.image = [_photos objectAtIndex:index];
    newVC.slideIndex = index;
    return newVC;
}

@end
