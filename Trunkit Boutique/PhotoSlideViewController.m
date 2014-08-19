//
//  PhotoSlideViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/3/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "PhotoSlideViewController.h"

@interface PhotoSlideViewController ()

@end

@implementation PhotoSlideViewController

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

    [self setImageOnImageView];
//    self.imageView.image = _image;
}

- (void)setImage:(id)image
{
    _image = image;
    [self setImageOnImageView];
}

- (void)setImageOnImageView
{
    UIImage *photo = nil;
    
    if ([_image isKindOfClass:[ALAsset class]])
    {
        ALAsset *asset = (ALAsset *)_image;
        photo = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        self.imageView.image = photo;
    }
    else
    {
        self.imageView.image = _image;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
