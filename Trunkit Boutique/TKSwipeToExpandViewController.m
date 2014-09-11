//
//  TKSwipeToExpandViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "TKSwipeToExpandViewController.h"

@interface TKSwipeToExpandViewController ()

@property (readwrite, nonatomic) TKSwipeToExpandViewPosition currentPosition;
@property (readwrite, nonatomic) CGFloat collapsedHeight;
@property (readwrite, nonatomic) CGPoint downPoint;
@property (readwrite, nonatomic) BOOL panGestureComplete;

@end

@implementation TKSwipeToExpandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _currentPosition = TKSwipeToExpandViewPositionCollapsed;
        _panGestureComplete = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _currentPosition = TKSwipeToExpandViewPositionCollapsed;
        _panGestureComplete = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _collapsedHeight = self.photoCollectionContainerHeightCon.constant;
    
	UIPanGestureRecognizer *feedPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [feedPanRecognizer setMinimumNumberOfTouches:1];
    [feedPanRecognizer setMaximumNumberOfTouches:3];
    [feedPanRecognizer setDelegate:self];
    [feedPanRecognizer setDelaysTouchesBegan:YES];
	[self.view addGestureRecognizer:feedPanRecognizer];
}

- (BOOL)singleTapDiscardsKeyboard
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)move:(UIPanGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.view];
    CGFloat collapsedY = self.view.bounds.size.height - _collapsedHeight;
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        _downPoint = location;
    }
    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged)
    {
        BOOL pan = ((location.y > 0) && (location.y < collapsedY)) ? YES : NO;
        CGFloat deltaY = location.y;
        CGFloat minDragLength = 0.0f;
        if (_currentPosition == TKSwipeToExpandViewPositionExpanded)
        {
            minDragLength = 50.0f;
            deltaY = location.y - _downPoint.y;
            if ((deltaY < minDragLength) || (_downPoint.y > 100))
            {
                pan = NO;
            }
        }
        else
        {
            if (_downPoint.y < collapsedY)
            {
                pan = NO;
            }
        }
        
        if (pan)
        {
            [self moveCollectionContainerToY:location.y - ((_currentPosition == TKSwipeToExpandViewPositionExpanded) ? (minDragLength + _downPoint.y) : 0)];
            _panGestureComplete = NO;
        }
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        if (!_panGestureComplete)
        {
            CGPoint velocity = [sender velocityInView:self.view];
            TKSwipeToExpandViewPosition positionAfterAnimation = TKSwipeToExpandViewPositionCollapsed;
            CGFloat newHeight = _collapsedHeight;
            
            if (velocity.y <= 0)
            {
                newHeight = self.view.bounds.size.height;
                positionAfterAnimation = TKSwipeToExpandViewPositionExpanded;
            }
            
            CGFloat velocityY = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
            CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
            
            [UIView animateWithDuration:animationDuration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){
                                 CGFloat toY = 0;
                                 if (positionAfterAnimation == TKSwipeToExpandViewPositionCollapsed)
                                 {
                                     toY = self.view.frame.size.height - _collapsedHeight;
                                 }
                                 [self moveCollectionContainerToY:toY];
                             }completion:^(BOOL finished) {
                                 if (finished)
                                 {
                                     self.currentPosition = positionAfterAnimation;
                                     _panGestureComplete = YES;
                                 }
                             }];
        }
    }
}

- (void)moveCollectionContainerToY:(CGFloat)y
{
    CGFloat height = self.view.frame.size.height - y;
    self.photoCollectionContainerHeightCon.constant = height;
    CGRect frame = self.containerView.frame;
    frame.origin.y = y;
    frame.size.height = height;
    self.containerView.frame = frame;
    [self.view layoutIfNeeded];
}

@end
