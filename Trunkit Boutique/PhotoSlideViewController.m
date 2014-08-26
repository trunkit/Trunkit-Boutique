//
//  PhotoSlideViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/3/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "PhotoSlideViewController.h"
#import "ALAssetsLibrary+TKSingleton.h"

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
}

- (void)setImage:(id)image
{
    if ([image isKindOfClass:[NSString class]])
    {
        _image = [NSURL URLWithString:image];
    }
    else
    {
        _image = image;
    }
    [self setImageOnImageView];
}

- (void)setImageOnImageView
{
    if ([_image isKindOfClass:[ALAsset class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ALAsset *asset = (ALAsset *)_image;
            UIImage *photo = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            self.imageView.image = photo;
        });
    }
    else if ([_image isKindOfClass:[NSURL class]])
    {
        NSURL *url = (NSURL *)_image;
        if ([url.absoluteString hasPrefix:@"assets-library://asset"])
        {
            dispatch_queue_t queue = dispatch_queue_create("PHOTO_SLIDE_QUEUE", 0);
            dispatch_async(queue, ^{
                ALAssetsLibrary *library = [ALAssetsLibrary defaultAssetsLibrary];
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 UIImage *photo = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                                 self.imageView.image = photo;
                             });
                         }
                        failureBlock:^(NSError *error)
                 {
                     NSLog(@"ERROR %s: %@", __PRETTY_FUNCTION__, error);
                 }];
            });
                           
        }
        else
        {
            NSString *identifier = [NSString stringWithFormat:@"%@-%@", self.description, url.absoluteString];
            char const * s = [identifier  UTF8String];

            dispatch_queue_t queue = dispatch_queue_create(s, 0);
            dispatch_async(queue, ^{
                UIImage *photo = nil;
                NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                photo = [[UIImage alloc] initWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = photo;
                });
            });

        }
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
