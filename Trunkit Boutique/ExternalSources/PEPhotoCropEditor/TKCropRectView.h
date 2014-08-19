//
//  PECropRectView.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/15/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKCropRectViewDelegate;

@interface TKCropRectView : UIView

@property (nonatomic, weak) id<TKCropRectViewDelegate> delegate;
@property (nonatomic) BOOL showsGridMajor;
@property (nonatomic) BOOL showsGridMinor;

@property (nonatomic) BOOL keepingAspectRatio;

@end

@protocol TKCropRectViewDelegate <NSObject>

- (void)cropRectViewDidBeginEditing:(TKCropRectView *)cropRectView;
- (void)cropRectViewEditingChanged:(TKCropRectView *)cropRectView;
- (void)cropRectViewDidEndEditing:(TKCropRectView *)cropRectView;

@end

