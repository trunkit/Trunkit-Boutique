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
@property (strong, nonatomic) PhotoSlideViewController *nextSlideController;

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
    
    self.controlView.frame = self.view.bounds;
    [self.view addSubview:self.controlView];
    [self initControlViewWithCurrentIndex:0];

//    UIPageControl *pageControlAppearance = [UIPageControl appearanceWhenContainedIn:[UIPageViewController class], nil];
//    pageControlAppearance.pageIndicatorTintColor = [UIColor lightGrayColor];
//    pageControlAppearance.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    
    
}

- (void)initControlViewWithCurrentIndex:(NSInteger)index
{
    for (UIView *aDot in self.controlView.subviews)
    {
        [aDot removeFromSuperview];
    }
    
    NSInteger pagesCount = self.photos.count;
    CGFloat dotWidth = 7.0f;
    CGFloat spacing = 8.0f;
    NSInteger xIncrement = spacing + dotWidth;
    CGFloat xStartOffset = ((-1 * xIncrement) * (pagesCount / 2.0f));
    
    CGRect firstFrame = CGRectMake((self.view.frame.size.width /2) + xStartOffset, self.view.frame.size.height - 30, dotWidth, dotWidth);
    
    for (NSInteger i = 0; i < pagesCount; i++)
    {
        CGRect frame = firstFrame;
        frame.origin.x += i * xIncrement;
        UIImageView *dot = [self pageControlImageViewWithFrame:frame selected:(index == i)];
        [self.controlView addSubview:dot];
    }
}

- (UIImageView *)pageControlImageViewWithFrame:(CGRect)frame selected:(BOOL)selected
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
    view.image = [UIImage imageNamed:(selected) ? @"PageControlStroke" : @"PageControlFill"];
    return view;
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
//        self.photos = _merchandiseItem.productPhotosTaken;
        self.photos = [@[] mutableCopy];
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

    PhotoSlideViewController *initialVC = nil;
    
    if (_photos.count)
    {
        initialVC = [self viewControllerForPhotoAtIndex:0];
    }
    
    if (!initialVC)
    {
        initialVC = [[PhotoSlideViewController alloc] init];
    }


    dispatch_async(dispatch_get_main_queue(), ^{
        [self setViewControllers:@[initialVC]
                       direction:UIPageViewControllerNavigationDirectionForward //|UIPageViewControllerNavigationDirectionReverse
                        animated:NO
                      completion:^(BOOL finished) {
                      }];
        [self initControlViewWithCurrentIndex:0];
    });

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

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (completed)
    {
//        NSLog(@"%s - %@", __PRETTY_FUNCTION__, previousViewControllers);
        PhotoSlideViewController *previousSlideController = [previousViewControllers objectAtIndex:0];
        if (self.nextSlideController.slideIndex != previousSlideController.slideIndex)
        {
            [self initControlViewWithCurrentIndex:self.nextSlideController.slideIndex];
        }
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
//    NSLog(@"%s - %@", __PRETTY_FUNCTION__, pendingViewControllers);
    self.nextSlideController = [pendingViewControllers objectAtIndex:0];
}

#pragma mark Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
//    NSLog(@"%s Asked what's After %d", __PRETTY_FUNCTION__, ((PhotoSlideViewController *)viewController).slideIndex);
    
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
//    NSLog(@"%s Asked what's Before %d", __PRETTY_FUNCTION__, ((PhotoSlideViewController *)viewController).slideIndex);
    
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
//    return self.photos.count;
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"%s - %@ - %@", __PRETTY_FUNCTION__, gestureRecognizer, otherGestureRecognizer);
    return YES;
}



@end
