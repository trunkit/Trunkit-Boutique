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

@end

@implementation TKSwipeToExpandViewController

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
    _currentPosition = TKSwipeToExpandViewPositionCollapsed;
    
    _collapsedHeight = self.photoCollectionContainerHeightCon.constant;
    
	UIPanGestureRecognizer *feedPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [feedPanRecognizer setMinimumNumberOfTouches:1];
    [feedPanRecognizer setMaximumNumberOfTouches:3];
    [feedPanRecognizer setDelegate:self];
    [feedPanRecognizer setDelaysTouchesBegan:YES];
	[self.containerView addGestureRecognizer:feedPanRecognizer];
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
    NSLog(@"%s - %@ - %@", __PRETTY_FUNCTION__, gestureRecognizer, otherGestureRecognizer);
    return YES;
}

//TODO: Subclass UIView and implement this
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView* view = [super hitTest:point withEvent:event];
//    if(view == self) {
//        view = _backView;
//    }
//    return view;
//}

-(void)move:(UIPanGestureRecognizer *)sender
{
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint location = [sender locationInView:self.view];
    
//    NSLog(@"LOCATION POINT => (%f, %f)", location.x, location.y);
    
    CGFloat collapsedY = self.view.bounds.size.height - _collapsedHeight;
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        _downPoint = location;
    }
    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged)
    {
        NSLog(@"YS => %f - %f", location.y, collapsedY);
        BOOL pan = ((location.y > 0) && (location.y < collapsedY)) ? YES : NO;
        CGFloat deltaY = location.y;
        CGFloat minDragLength = 0.0f;
        if (_currentPosition == TKSwipeToExpandViewPositionExpanded)
        {
            minDragLength = 50.0f;
            deltaY = location.y - _downPoint.y;
            if ((deltaY < minDragLength) || (_downPoint.y > 100))
            {
                NSLog(@"NO PANNING-1");
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
            CGFloat newHeight = self.view.bounds.size.height - deltaY + minDragLength;
            self.photoCollectionContainerHeightCon.constant = newHeight;
        }
        else
        {
            NSLog(@"NO PANNING");
        }
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        //TODO Fix redundant code
        BOOL hasPanned = YES;
        if (_currentPosition == TKSwipeToExpandViewPositionExpanded)
        {
            CGFloat minDragLength = 50.0f;
            CGFloat deltaY = location.y - _downPoint.y;
            if ((deltaY < minDragLength) || (_downPoint.y > 100))
            {
                NSLog(@"NO PANNING-END-1");
                hasPanned = NO;
            }
        }

        if (hasPanned && (self.photoCollectionContainerHeightCon.constant != _collapsedHeight))
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
                                 self.photoCollectionContainerHeightCon.constant = newHeight;
                                 [self.view layoutIfNeeded];
                             }completion:^(BOOL finished) {
                                 if (finished)
                                 {
                                     self.currentPosition = positionAfterAnimation;
                                 }
                             }];
            
        }
    }
}

@end
