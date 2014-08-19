//
//  PEResizeControl.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/15/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol TKResizeControlViewDelegate;

@interface TKResizeControl : UIView

@property (nonatomic, weak) id<TKResizeControlViewDelegate> delegate;
@property (nonatomic, readonly) CGPoint translation;

@end

@protocol TKResizeControlViewDelegate <NSObject>

- (void)resizeControlViewDidBeginResizing:(TKResizeControl *)resizeControlView;
- (void)resizeControlViewDidResize:(TKResizeControl *)resizeControlView;
- (void)resizeControlViewDidEndResizing:(TKResizeControl *)resizeControlView;

@end
