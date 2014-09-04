//
//  LeftMenuViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/14/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UILabel+UILabel_TKExtensions.h"


@implementation UIImage (NegativeImage)

- (UIImage *)negativeImage
{
    // get width and height as integers, since we'll be using them as
    // array subscripts, etc, and this'll save a whole lot of casting
    CGSize size = self.size;
    int width = size.width;
    int height = size.height;
    
    // Create a suitable RGB+alpha bitmap context in BGRA colour space
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *memoryPool = (unsigned char *)calloc(width*height*4, 1);
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    // draw the current image to the newly created context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    // run through every pixel, a scan line at a time...
    for(int y = 0; y < height; y++)
    {
        // get a pointer to the start of this scan line
        unsigned char *linePointer = &memoryPool[y * width * 4];
        
        // step through the pixels one by one...
        for(int x = 0; x < width; x++)
        {
            // get RGB values. We're dealing with premultiplied alpha
            // here, so we need to divide by the alpha channel (if it
            // isn't zero, of course) to get uninflected RGB. We
            // multiply by 255 to keep precision while still using
            // integers
            int r, g, b;
            if(linePointer[3])
            {
                r = linePointer[0] * 255 / linePointer[3];
                g = linePointer[1] * 255 / linePointer[3];
                b = linePointer[2] * 255 / linePointer[3];
            }
            else
            r = g = b = 0;
            
            // perform the colour inversion
            r = 255 - r;
            g = 255 - g;
            b = 255 - b;
            
            // multiply by alpha again, divide by 255 to undo the
            // scaling before, store the new values and advance
            // the pointer we're reading pixel data from
            linePointer[0] = r * linePointer[3] / 255;
            linePointer[1] = g * linePointer[3] / 255;
            linePointer[2] = b * linePointer[3] / 255;
            linePointer += 4;
        }
    }
    
    // get a CG image from the context, wrap that into a
    // UIImage
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
    
    // and return
    return returnImage;
}

@end



@interface LeftMenuViewController ()

@property (strong, nonatomic) UITableView *myTableView;

@property (strong, nonatomic) UIImage *suppliedInvertedImage;
@property (strong, nonatomic) UIImage *helpInvertedImage;
@property (strong, nonatomic) UIImage *termsInvertedImage;
@property (strong, nonatomic) UIImage *signoutInvertedImage;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *boldFont = [UIFont fontWithName:@"BebasNeue" size:18.0];
    self.suppliedLabel.font = boldFont;
    [self.suppliedLabel applyThemeAttribute];
    
    self.helpLabel.font = boldFont;
    [self.helpLabel applyThemeAttribute];
    
    self.termsLabel.font = boldFont;
    [self.termsLabel applyThemeAttribute];
    
    self.signoutLabel.font = boldFont;
    [self.signoutLabel applyThemeAttribute];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // The device is an iPhone or iPod touch.
        [self setFixedStatusBar];
    }
    
    self.suppliedInvertedImage = [[UIImage imageNamed:@"hangerMenuItemImage"] negativeImage];
    self.helpInvertedImage = [[UIImage imageNamed:@"helpMenuItemImage"] negativeImage];
    self.termsInvertedImage = [[UIImage imageNamed:@"termsMenuItemImage"] negativeImage];
    self.signoutInvertedImage = [[UIImage imageNamed:@"signOutMenuImteImage"] negativeImage];
    
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)setFixedStatusBar
{
    self.myTableView = self.tableView;
    
    CGRect frame = self.view.bounds;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = self.myTableView.backgroundColor;
    [self.view addSubview:self.myTableView];
    
    CGRect tableViewFrame = self.myTableView.frame;
    tableViewFrame.origin.y -= 2;
    self.myTableView.frame = tableViewFrame;
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(frame.size.width, frame.size.height), 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath indexAtPosition:1];
    
    self.suppliedMenuFrameView.backgroundColor = (index == 0) ? [UIColor blackColor] : [UIColor whiteColor];
    self.helpMenuFrameView.backgroundColor = (index == 1) ? [UIColor blackColor] : [UIColor whiteColor];
    self.termsMenuFrameView.backgroundColor = (index == 2) ? [UIColor blackColor] : [UIColor whiteColor];
    self.signoutMenuFrameView.backgroundColor = (index == 3) ? [UIColor blackColor] : [UIColor whiteColor];

    self.suppliedMenuImageView.image = (index == 0) ? self.suppliedInvertedImage : [UIImage imageNamed:@"hangerMenuItemImage"];
    self.helpMenuImageView.image = (index == 1) ? self.helpInvertedImage : [UIImage imageNamed:@"helpMenuItemImage"];
    self.termsMenuImageView.image = (index == 2) ? self.termsInvertedImage : [UIImage imageNamed:@"termsMenuItemImage"];
    self.signoutMenuImageView.image = (index == 3) ? self.signoutInvertedImage : [UIImage imageNamed:@"signOutMenuImteImage"];
    
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
