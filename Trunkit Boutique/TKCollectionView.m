//
//  TKCollectionView.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/3/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "TKCollectionView.h"

@implementation TKCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}


//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    NSLog(@"%s - %@", __PRETTY_FUNCTION__, view);
//    return view;
//    
////    UIView *touchedView = [super hitTest:point withEvent:event];
////    NSSet* touches = [event allTouches];
////    return touchedView;
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s - %@", __PRETTY_FUNCTION__, event);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
