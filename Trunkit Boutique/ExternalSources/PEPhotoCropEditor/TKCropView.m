//
//  PECropView.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/15/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//


#import "TKCropView.h"
#import "TKCropRectView.h"
#import "UIImage+TKCrop.h"

//static const CGFloat MarginTop = 37.0f;
////static const CGFloat MarginBottom = MarginTop;
//static const CGFloat MarginLeft = 20.0f;
////static const CGFloat MarginRight = MarginLeft;

static const CGFloat MarginTop = 0.0f;
//static const CGFloat MarginBottom = MarginTop;
static const CGFloat MarginLeft = 0.0f;
//static const CGFloat MarginRight = MarginLeft;

@interface TKCropView () <UIScrollViewDelegate, UIGestureRecognizerDelegate, TKCropRectViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *zoomingView;
@property (nonatomic) UIImageView *imageView;

@property (nonatomic) TKCropRectView *cropRectView;
@property (nonatomic) UIView *topOverlayView;
@property (nonatomic) UIView *leftOverlayView;
@property (nonatomic) UIView *rightOverlayView;
@property (nonatomic) UIView *bottomOverlayView;

@property (nonatomic) CGRect insetRect;
@property (nonatomic) CGRect editingRect;

@property (nonatomic, getter = isResizing) BOOL resizing;
@property (nonatomic) UIInterfaceOrientation interfaceOrientation;

@end

@implementation TKCropView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.savedZoomingRect = CGRectZero;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.maximumZoomScale = 20.0f;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.bouncesZoom = NO;
    self.scrollView.clipsToBounds = NO;
    [self addSubview:self.scrollView];
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    rotationGestureRecognizer.delegate = self;
    _rotationGestureRecognizer = rotationGestureRecognizer;
    [self.scrollView addGestureRecognizer:rotationGestureRecognizer];
    
    self.cropRectView = [[TKCropRectView alloc] init];
    self.cropRectView.delegate = self;
    [self addSubview:self.cropRectView];
    
    self.topOverlayView = [[UIView alloc] init];
    self.topOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [self addSubview:self.topOverlayView];
    
    self.leftOverlayView = [[UIView alloc] init];
    self.leftOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [self addSubview:self.leftOverlayView];
    
    self.rightOverlayView = [[UIView alloc] init];
    self.rightOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [self addSubview:self.rightOverlayView];
    
    self.bottomOverlayView = [[UIView alloc] init];
    self.bottomOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [self addSubview:self.bottomOverlayView];
}

#pragma mark -

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.userInteractionEnabled) {
        return nil;
    }
    
    UIView *hitView = [self.cropRectView hitTest:[self convertPoint:point toView:self.cropRectView] withEvent:event];
    if (hitView) {
        return hitView;
    }
    CGPoint locationInImageView = [self convertPoint:point toView:self.zoomingView];
    CGPoint zoomedPoint = CGPointMake(locationInImageView.x * self.scrollView.zoomScale, locationInImageView.y * self.scrollView.zoomScale);
    if (CGRectContainsPoint(self.zoomingView.frame, zoomedPoint)) {
        return self.scrollView;
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.image) {
        return;
    }
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.editingRect = CGRectInset(self.bounds, MarginLeft, MarginTop);
    } else {
        self.editingRect = CGRectInset(self.bounds, MarginLeft, MarginLeft);
    }
    
    if (!self.imageView) {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
            self.insetRect = CGRectInset(self.bounds, MarginLeft, MarginTop);
        } else {
            self.insetRect = CGRectInset(self.bounds, MarginLeft, MarginLeft);
        }
        
        [self setupImageView];
    }
    
    if (!self.isResizing) {
        [self layoutCropRectViewWithCropRect:self.scrollView.frame];
        
        if (self.interfaceOrientation != interfaceOrientation) {
            [self zoomToCropRect:self.scrollView.frame];
        }
    }
    
    self.interfaceOrientation = interfaceOrientation;
}

- (void)layoutCropRectViewWithCropRect:(CGRect)cropRect
{
    self.cropRectView.frame = cropRect;
    [self layoutOverlayViewsWithCropRect:cropRect];
}

- (void)layoutOverlayViewsWithCropRect:(CGRect)cropRect
{
    self.topOverlayView.frame = CGRectMake(0.0f,
                                           0.0f,
                                           CGRectGetWidth(self.bounds),
                                           CGRectGetMinY(cropRect));
    self.leftOverlayView.frame = CGRectMake(0.0f,
                                            CGRectGetMinY(cropRect),
                                            CGRectGetMinX(cropRect),
                                            CGRectGetHeight(cropRect));
    self.rightOverlayView.frame = CGRectMake(CGRectGetMaxX(cropRect),
                                             CGRectGetMinY(cropRect),
                                             CGRectGetWidth(self.bounds) - CGRectGetMaxX(cropRect),
                                             CGRectGetHeight(cropRect));
    self.bottomOverlayView.frame = CGRectMake(0.0f,
                                              CGRectGetMaxY(cropRect),
                                              CGRectGetWidth(self.bounds),
                                              CGRectGetHeight(self.bounds) - CGRectGetMaxY(cropRect));
}

- (void)setupImageView
{
    CGRect cropRect = AVMakeRectWithAspectRatioInsideRect(self.image.size, self.insetRect);
    CGRect scrollRect = (CGRectEqualToRect(self.savedScrollRect, CGRectZero)) ? cropRect : self.savedScrollRect;
    
//    self.scrollView.frame = cropRect;
//    self.scrollView.contentSize = cropRect.size;
    self.scrollView.frame = scrollRect;
    self.scrollView.contentSize = scrollRect.size;
    
    CGRect zoomingRect = (CGRectEqualToRect(self.savedZoomingRect, CGRectZero)) ? self.scrollView.bounds : self.savedZoomingRect;
    
//    self.zoomingView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
    self.zoomingView = [[UIView alloc] initWithFrame:zoomingRect];
    self.zoomingView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.zoomingView];

    CGRect imageRect = (CGRectEqualToRect(self.savedImageRect, CGRectZero)) ? self.zoomingView.bounds : self.savedImageRect;

//    self.imageView = [[UIImageView alloc] initWithFrame:self.zoomingView.bounds];
    self.imageView = [[UIImageView alloc] initWithFrame:imageRect];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    [self.zoomingView addSubview:self.imageView];
}

- (void)resetZoomingRect
{
//    CGRect cropRect = AVMakeRectWithAspectRatioInsideRect(self.image.size, self.insetRect);
//    self.scrollView.frame = cropRect;
//    self.scrollView.contentSize = cropRect.size;
    
//    CGRect zoomingRect = self.scrollView.bounds;
//    self.zoomingView.frame = zoomingRect;
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    BOOL initLayout = (!_image);
    _image = image;
    
    if (initLayout)
    {
        self.savedZoomingRect = (initLayout) ? CGRectZero : self.zoomingView.frame;
        self.savedScrollRect = (initLayout) ? CGRectZero : self.scrollView.frame;
        self.savedImageRect = (initLayout) ? CGRectZero : self.imageView.frame;
        
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        [self.zoomingView removeFromSuperview];
        self.zoomingView = nil;
        [self setNeedsLayout];
    }
    else
    {
        self.imageView.image = _image;
    }
}

- (void)setKeepingCropAspectRatio:(BOOL)keepingCropAspectRatio
{
    _keepingCropAspectRatio = keepingCropAspectRatio;
    self.cropRectView.keepingAspectRatio = self.keepingCropAspectRatio;
}

- (void)setCropAspectRatio:(CGFloat)aspectRatio andCenter:(BOOL)center
{
    CGRect cropRect = self.scrollView.frame;
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    if (aspectRatio <= 1.0f) {
        width = height * aspectRatio;
        if (width > CGRectGetWidth(self.imageView.bounds)) {
            width = CGRectGetWidth(cropRect);
            height = width / aspectRatio;
        }
    } else {
        height = width / aspectRatio;
        if (height > CGRectGetHeight(self.imageView.bounds)) {
            height = CGRectGetHeight(cropRect);
            width = height * aspectRatio;
        }
    }
    cropRect.size = CGSizeMake(width, height);
    [self zoomToCropRect:cropRect andCenter:center];
}

- (void)setCropAspectRatio:(CGFloat)aspectRatio
{
    [self setCropAspectRatio:aspectRatio andCenter:YES];
}

- (CGFloat)cropAspectRatio
{
    CGRect cropRect = self.scrollView.frame;
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    return width / height;
}

- (void)setCropRect:(CGRect)cropRect
{
    [self zoomToCropRect:cropRect];
}

- (CGRect)cropRect
{
    return self.scrollView.frame;
}

- (void)setImageCropRect:(CGRect)imageCropRect
{
    [self resetCropRect];
    
    CGRect scrollViewFrame = self.scrollView.frame;
    CGSize imageSize = self.image.size;
    
    CGFloat scale = MIN(CGRectGetWidth(scrollViewFrame) / imageSize.width,
                        CGRectGetHeight(scrollViewFrame) / imageSize.height);
    
    CGFloat x = CGRectGetMinX(imageCropRect) * scale + CGRectGetMinX(scrollViewFrame);
    CGFloat y = CGRectGetMinY(imageCropRect) * scale + CGRectGetMinY(scrollViewFrame);
    CGFloat width = CGRectGetWidth(imageCropRect) * scale;
    CGFloat height = CGRectGetHeight(imageCropRect) * scale;
    
    CGRect rect = CGRectMake(x, y, width, height);
    CGRect intersection = CGRectIntersection(rect, scrollViewFrame);
    
    if (!CGRectIsNull(intersection)) {
        self.cropRect = intersection;
    }
}

- (void)resetCropRect
{
    [self resetCropRectAnimated:NO];
}

- (void)resetCropRectAnimated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    self.imageView.transform = CGAffineTransformIdentity;
    
    CGSize contentSize = self.scrollView.contentSize;
    CGRect initialRect = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
    [self.scrollView zoomToRect:initialRect animated:NO];
    
    self.scrollView.bounds = self.imageView.bounds;
    
    [self layoutCropRectViewWithCropRect:self.scrollView.bounds];
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (UIImage *)croppedImage
{
    return [self.image rotatedImageWithtransform:self.rotation croppedToRect:self.zoomedCropRect];
}

- (UIImage *)imageCroppedWithImage:(UIImage *)image
{
    return [image rotatedImageWithtransform:self.rotation croppedToRect:self.zoomedCropRect];
}

- (CGRect)zoomedCropRect
{
    CGRect cropRect = [self convertRect:self.scrollView.frame toView:self.zoomingView];
    CGSize size = self.image.size;
    
    CGFloat ratio = 1.0f;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(orientation)) {
        ratio = CGRectGetWidth(AVMakeRectWithAspectRatioInsideRect(self.image.size, self.insetRect)) / size.width;
    } else {
        ratio = CGRectGetHeight(AVMakeRectWithAspectRatioInsideRect(self.image.size, self.insetRect)) / size.height;
    }
    
    CGRect zoomedCropRect = CGRectMake(cropRect.origin.x / ratio,
                                       cropRect.origin.y / ratio,
                                       cropRect.size.width / ratio,
                                       cropRect.size.height / ratio);
    
    return zoomedCropRect;
}

- (BOOL)userHasModifiedCropArea
{
    CGRect zoomedCropRect = CGRectIntegral(self.zoomedCropRect);
    return (!CGPointEqualToPoint(zoomedCropRect.origin, CGPointZero) ||
            !CGSizeEqualToSize(zoomedCropRect.size, self.image.size) ||
            !CGAffineTransformEqualToTransform(self.rotation, CGAffineTransformIdentity));
}

- (CGAffineTransform)rotation
{
    return self.imageView.transform;
}

- (CGFloat)rotationAngle
{
    CGAffineTransform rotation = self.imageView.transform;
    return atan2f(rotation.b, rotation.a);
}

- (void)setRotationAngle:(CGFloat)rotationAngle
{
    self.imageView.transform = CGAffineTransformMakeRotation(rotationAngle);
}

- (void)setRotationAngle:(CGFloat)rotationAngle snap:(BOOL)snap
{
    if (snap)
    {
        rotationAngle = nearbyintf(rotationAngle / M_PI_2) * M_PI_2;
    }
    self.rotationAngle = rotationAngle;
}

- (CGRect)cappedCropRectInImageRectWithCropRectView:(TKCropRectView *)cropRectView
{
    CGRect cropRect = cropRectView.frame;
    
    CGRect rect = [self convertRect:cropRect toView:self.scrollView];
    if (CGRectGetMinX(rect) < CGRectGetMinX(self.zoomingView.frame)) {
        cropRect.origin.x = CGRectGetMinX([self.scrollView convertRect:self.zoomingView.frame toView:self]);
        CGFloat cappedWidth = CGRectGetMaxX(rect);
        cropRect.size = CGSizeMake(cappedWidth,
                                   !self.keepingCropAspectRatio ? cropRect.size.height : cropRect.size.height * (cappedWidth/cropRect.size.width));
    }
    if (CGRectGetMinY(rect) < CGRectGetMinY(self.zoomingView.frame)) {
        cropRect.origin.y = CGRectGetMinY([self.scrollView convertRect:self.zoomingView.frame toView:self]);
        CGFloat cappedHeight =  CGRectGetMaxY(rect);
        cropRect.size = CGSizeMake(!self.keepingCropAspectRatio ? cropRect.size.width : cropRect.size.width * (cappedHeight / cropRect.size.height),
                                   cappedHeight);
    }
    if (CGRectGetMaxX(rect) > CGRectGetMaxX(self.zoomingView.frame)) {
        CGFloat cappedWidth = CGRectGetMaxX([self.scrollView convertRect:self.zoomingView.frame toView:self]) - CGRectGetMinX(cropRect);
        cropRect.size = CGSizeMake(cappedWidth,
                                   !self.keepingCropAspectRatio ? cropRect.size.height : cropRect.size.height * (cappedWidth/cropRect.size.width));
    }
    if (CGRectGetMaxY(rect) > CGRectGetMaxY(self.zoomingView.frame)) {
        CGFloat cappedHeight =  CGRectGetMaxY([self.scrollView convertRect:self.zoomingView.frame toView:self]) - CGRectGetMinY(cropRect);
        cropRect.size = CGSizeMake(!self.keepingCropAspectRatio ? cropRect.size.width : cropRect.size.width * (cappedHeight / cropRect.size.height),
                                   cappedHeight);
    }
    
    return cropRect;
}

- (void)automaticZoomIfEdgeTouched:(CGRect)cropRect
{
    if (CGRectGetMinX(cropRect) < CGRectGetMinX(self.editingRect) - 5.0f ||
        CGRectGetMaxX(cropRect) > CGRectGetMaxX(self.editingRect) + 5.0f ||
        CGRectGetMinY(cropRect) < CGRectGetMinY(self.editingRect) - 5.0f ||
        CGRectGetMaxY(cropRect) > CGRectGetMaxY(self.editingRect) + 5.0f) {
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self zoomToCropRect:self.cropRectView.frame];
        } completion:NULL];
    }
}

#pragma mark -

- (void)cropRectViewDidBeginEditing:(TKCropRectView *)cropRectView
{
    self.resizing = YES;
}

- (void)cropRectViewEditingChanged:(TKCropRectView *)cropRectView
{
    CGRect cropRect = [self cappedCropRectInImageRectWithCropRectView:cropRectView];
    
    [self layoutCropRectViewWithCropRect:cropRect];
    
    [self automaticZoomIfEdgeTouched:cropRect];
}

- (void)cropRectViewDidEndEditing:(TKCropRectView *)cropRectView
{
    self.resizing = NO;
    [self zoomToCropRect:self.cropRectView.frame];
}

- (void)zoomToCropRect:(CGRect)toRect andCenter:(BOOL)center
{
    if (CGRectEqualToRect(self.scrollView.frame, toRect)) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(toRect);
    CGFloat height = CGRectGetHeight(toRect);
    
    CGFloat scale = MIN(CGRectGetWidth(self.editingRect) / width, CGRectGetHeight(self.editingRect) / height);
    
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGRect cropRect = CGRectMake((CGRectGetWidth(self.bounds) - scaledWidth) / 2,
                                 (CGRectGetHeight(self.bounds) - scaledHeight) / 2,
                                 scaledWidth,
                                 scaledHeight);
    
    CGRect zoomRect = [self convertRect:toRect toView:self.zoomingView];
    zoomRect.size.width = CGRectGetWidth(cropRect) / (self.scrollView.zoomScale * scale);
    zoomRect.size.height = CGRectGetHeight(cropRect) / (self.scrollView.zoomScale * scale);
    
    if(center) {
        CGRect imageViewBounds = self.imageView.bounds;
        zoomRect.origin.y = (CGRectGetHeight(imageViewBounds) / 2) - (CGRectGetHeight(zoomRect) / 2);
        zoomRect.origin.x = (CGRectGetWidth(imageViewBounds) / 2) - (CGRectGetWidth(zoomRect) / 2);
    }
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.bounds = cropRect;
        [self.scrollView zoomToRect:zoomRect animated:NO];
        
        [self layoutCropRectViewWithCropRect:cropRect];
    } completion:NULL];
}

- (void)zoomToCropRect:(CGRect)toRect
{
    [self zoomToCropRect:toRect andCenter:NO];
}

#pragma mark -

- (void)handleRotation:(UIRotationGestureRecognizer *)gestureRecognizer
{
    CGFloat rotation = gestureRecognizer.rotation;
    
    CGAffineTransform transform = CGAffineTransformRotate(self.imageView.transform, rotation);
    self.imageView.transform = transform;
    gestureRecognizer.rotation = 0.0f;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.cropRectView.showsGridMinor = YES;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
               gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
               gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        self.cropRectView.showsGridMinor = NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomingView;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint contentOffset = scrollView.contentOffset;
    *targetContentOffset = contentOffset;
}

@end
