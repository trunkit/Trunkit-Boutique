//
//  ChooseOrTakePhotoViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/5/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "ChooseOrTakePhotoViewController.h"

@interface ChooseOrTakePhotoViewController ()

@end

@implementation ChooseOrTakePhotoViewController

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
    
    [self applyThemeToLabel:self.chooseExistingPhotosLabel withFontSize:18.0];
    [self applyThemeToLabel:self.takeAPhotoLabel withFontSize:18.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)navigationItemTitle
{
    return @"";
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
