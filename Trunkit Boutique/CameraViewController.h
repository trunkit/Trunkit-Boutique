//
//  CameraViewController.h
//  Benchmark
//
//  Created by Frank Le Grand on 5/18/14.
//  Copyright (c) 2014 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TKEditViewController.h"
#import "TKImage.h"

typedef enum {
    TKCameraViewFinderFormatPortrait,
    TKCameraViewFinderFormatSquare,
} TKCameraViewFinderFormat;


@interface CameraViewController : TKEditViewController

@property (readwrite) TKCameraViewFinderFormat viewFinderFormat;

//@property (weak, nonatomic) CreatePostViewController *createPostViewController;

@property (weak, nonatomic) IBOutlet UIView *captureView;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UIButton *thumbnailButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewFinderAspectRatioConstraint;

@property (strong, nonatomic) UIViewController *popToControllerOnAccept;


- (IBAction)backButtonTapped:(id)sender;
- (IBAction)takePhotoButtonTapped:(id)sender;
- (IBAction)switchCameraBtnTapped:(id)sender;
- (IBAction)flashByttonnTapped:(id)sender;
- (IBAction)squarePortraitButtonTapped:(id)sender;

@end
