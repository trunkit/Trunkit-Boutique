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
    
	UIPanGestureRecognizer *feedPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerSwipe:)];
    [feedPanRecognizer setMinimumNumberOfTouches:1];
    [feedPanRecognizer setMaximumNumberOfTouches:3];
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

- (void)handleTwoFingerSwipe:(UIPanGestureRecognizer *)gestureRecognizer
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
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
                         
                         self.itemPhotosContainerView.alpha = (_currentPosition == TKSwipeToExpandViewPositionCollapsed) ? 1.0 : 0.0;
                         
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
