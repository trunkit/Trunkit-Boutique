//
//  PEResizeControl.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/15/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//


#import "TKResizeControl.h"

@interface TKResizeControl ()

@property (nonatomic, readwrite) CGPoint translation;
@property (nonatomic) CGPoint startPoint;

@end

@implementation TKResizeControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 44.0f, 44.0f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.exclusiveTouch = YES;
        
//        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//        [self addGestureRecognizer:gestureRecognizer];
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint translationInView = [gestureRecognizer translationInView:self.superview];
        self.startPoint = CGPointMake(roundf(translationInView.x), translationInView.y);
        
        if ([self.delegate respondsToSelector:@selector(resizeControlViewDidBeginResizing:)]) {
            [self.delegate resizeControlViewDidBeginResizing:self];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        self.translation = CGPointMake(roundf(self.startPoint.x + translation.x),
                                       roundf(self.startPoint.y + translation.y));
        
        if ([self.delegate respondsToSelector:@selector(resizeControlViewDidResize:)]) {
            [self.delegate resizeControlViewDidResize:self];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if ([self.delegate respondsToSelector:@selector(resizeControlViewDidEndResizing:)]) {
            [self.delegate resizeControlViewDidEndResizing:self];
        }
    }
}

@end
