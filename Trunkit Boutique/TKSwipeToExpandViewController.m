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
//@property (nonatomic) CGRect originalFrame;

@property (readwrite, nonatomic) CGFloat firstX;
@property (readwrite, nonatomic) CGFloat firstY;

@property (readwrite, nonatomic) CGFloat collapsedHeight;

@end

@implementation TKSwipeToExpandViewController

@synthesize firstX = firstX;
@synthesize firstY = firstY;

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
	[self.view addGestureRecognizer:feedPanRecognizer];
}

- (BOOL)singleTapDiscardsKeyboard
{
    return NO;
}


//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    if (_collapsedY == 0)
//    {
//        _collapsedY = self.view.bounds.size.height - 100;
//    }
//    if (_currentPosition == TKSwipeToExpandViewPositionCollapsed)
//        _originalFrame = [self viewToExpand].frame;
//    
//}

//- (UIView *)viewToExpand
//{
////    return self.sizingView;
//    return self.view.superview;
////    return self.view;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (void)handleTwoFingerSwipe:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return;
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    
    
    
    /*
     *
     
    CGRect toFrame = CGRectZero;
    
    NSLog(@"View bounds : (%f, %f, %f, %f)", [self viewToExpand].bounds.origin.x, [self viewToExpand].bounds.origin.y, [self viewToExpand].bounds.size.width, [self viewToExpand].bounds.size.height);
    NSLog(@"View frame : (%f, %f, %f, %f)", [self viewToExpand].frame.origin.x, [self viewToExpand].frame.origin.y, [self viewToExpand].frame.size.width, [self viewToExpand].frame.size.height);
    
    if (self.currentPosition == TKSwipeToExpandViewPositionCollapsed)
    {
        toFrame = self.originalFrame;
        toFrame.size.height = self.originalFrame.origin.y + self.originalFrame.size.height;// - 64;
        toFrame.origin.y = 64;
//        toFrame.size.height = 300;
//        toFrame.origin.y = 0;
        self.currentPosition = TKSwipeToExpandViewPositionExpanded;
    }
    else
    {
        toFrame = self.originalFrame;
        self.currentPosition = TKSwipeToExpandViewPositionCollapsed;
    }
    [self viewToExpand].frame = toFrame;
    CGRect toSelfFrame = self.sizingView.frame;
    toSelfFrame.size.height = toFrame.size.height;

    self.sizingView.frame = toSelfFrame;
//    [self.sizingView setNeedsDisplay];
//    [self.sizingView setNeedsLayout];
     
     */
    

    if (self.currentPosition == TKSwipeToExpandViewPositionCollapsed)
    {
        self.currentPosition = TKSwipeToExpandViewPositionExpanded;
    }
    else
    {
        self.currentPosition = TKSwipeToExpandViewPositionCollapsed;
    }

    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         self.photoCollectionContainerHeightCon.constant = (_currentPosition == TKSwipeToExpandViewPositionCollapsed)
                         ? 110 : (self.view.frame.size.height);
                         
//                         self.itemPhotosContainerView.alpha = (_currentPosition == TKSwipeToExpandViewPositionCollapsed) ? 1.0 : 0.0;
                         
                         [self.view layoutIfNeeded];
//                         [self.sizingView layoutIfNeeded];
//                         [[self viewToExpand] layoutSubviews];
//                         [self.view layoutSubviews];
                         
                     }completion:^(BOOL finished) {
//                         [self.view layoutSubviews];
//                         CGRect containerFrame = toFrame;
//                         containerFrame.size.height -= 30;
//                         self.containerView.frame = containerFrame;
                     }];
}

-(void)move:(UIPanGestureRecognizer *)sender
{
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
//    CGPoint translatedPoint2 = [(UIPanGestureRecognizer*)sender translationInView:self.containerView];
//    
    CGPoint location = [sender locationInView:self.view];
    
    NSLog(@"LOCATION POINT => (%f, %f)", location.x, location.y);
    
    CGFloat collapsedY = self.view.bounds.size.height - _collapsedHeight;
    
    if (location.y < collapsedY)
    {
        CGFloat newHeight = self.view.bounds.size.height - location.y;
        self.photoCollectionContainerHeightCon.constant = newHeight;
    }
    else
    {
    }
    
//    NSLog(@"TRANSLATED POINT => (%f, %f)", translatedPoint.x, translatedPoint.y);
//    NSLog(@"TRANSLATED POINT 2 => (%f, %f)", translatedPoint2.x, translatedPoint2.y);

    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
//        firstX = [[sender view] center].x;
//        firstY = [[sender view] center].y;
        firstX = translatedPoint.x;
        firstY = translatedPoint.y;
    }
    
//    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY);
    
//    [[sender view] setCenter:translatedPoint];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        CGFloat velocityY = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        
//        CGFloat finalX = translatedPoint.x + velocityX;
//        CGFloat finalY = firstY;// translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
//        CGFloat finalY = translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);

        CGFloat newHeight = _collapsedHeight;
        if (translatedPoint.y < 0)
        {
            NSLog(@"UP!");
            newHeight = self.view.bounds.size.height;
//            finalY = 0;
        }
        else
        {
            NSLog(@"DOWN!");
        }
//        else if (finalY > 1024)
//        {
//            finalY = 1024;
//        }

//        if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
//            if (finalX < 0) {
//                //finalX = 0;
//            } else if (finalX > 768) {
//                //finalX = 768;
//            }
//            
//            if (finalY < 0) {
//                finalY = 0;
//            } else if (finalY > 1024) {
//                finalY = 1024;
//            }
//        } else {
//            if (finalX < 0) {
//                //finalX = 0;
//            } else if (finalX > 1024) {
//                //finalX = 768;
//            }
//            
//            if (finalY < 0) {
//                finalY = 0;
//            } else if (finalY > 768) {
//                finalY = 1024;
//            }
//        }
        
        CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
        
        NSLog(@"the duration is: %f", animationDuration);
        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:5.0];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//        [UIView setAnimationDelegate:self];
////        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
////        [[sender view] setCenter:CGPointMake(finalX, finalY)];
//        self.photoCollectionContainerHeightCon.constant = newHeight;
//        [UIView commitAnimations];
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){
                             self.photoCollectionContainerHeightCon.constant = newHeight;
                             [self.view layoutIfNeeded];
                         }completion:^(BOOL finished) {
                         }];

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
