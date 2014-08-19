//
//  PhotoEditorViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/12/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKEditViewController.h"
#import "ALAssetLibrary+Singleton.h"

@interface PhotoEditorViewController : TKEditViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *retakeButton;
@property (strong, nonatomic) IBOutlet UIButton *useButton;

@property (strong, nonatomic) ALAsset *photo;
@property (strong, nonatomic) UIImage *editedPhoto;

//@property (readwrite, nonatomic) CGFloat brightnessAdjustment;
//@property (readwrite, nonatomic) CGFloat contrastAdjustment;

@property (strong, nonatomic) UIViewController *popToControllerOnAccept;

- (IBAction)adjustButtonTapped:(id)sender;
- (IBAction)cropButtonTapped:(id)sender;
- (IBAction)useButtonTapped:(id)sender;

@end
