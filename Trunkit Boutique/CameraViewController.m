//
//  CameraViewController.m
//  Benchmark
//
//  Created by Frank Le Grand on 5/18/14.
//  Copyright (c) 2014 Parse. All rights reserved.
//

#import "CameraViewController.h"
#import "PhotoEditorViewController.h"
//#import <QuartzCore/QuartzCore.h>
#import "ALAssetsLibrary+TKSingleton.h"

static CGFloat optionAvailableAlpha = 0.6;
static CGFloat optionUnavailableAlpha = 0.2;

@interface CameraViewController ()

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
//@property (strong, nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *capturePreviewLayer;
@property (strong, nonatomic) TKImage *capturedPhoto;


@property (readwrite) BOOL isCapturingImage;
@property (readwrite) CGRect portraitCaptureRect;

@end

@implementation CameraViewController

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
	[self setupCamera];
    [self evaluateFlashButton];
    
    self.viewFinderFormat = (self.captureView.frame.size.width == self.captureView.frame.size.height) ? TKCameraViewFinderFormatSquare : TKCameraViewFinderFormatPortrait;
    
    [self setLastPhotoThumbnail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setLastPhotoThumbnail];
    [_captureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_captureSession stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:self];
//	UIViewController *destVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"CameraToPhotoAcceptanceSegueIdentifier"])
    {
        PhotoEditorViewController *vc = (PhotoEditorViewController *)segue.destinationViewController;
        vc.photo = self.capturedPhoto;
        vc.popToControllerOnAccept = _popToControllerOnAccept;
        self.capturedPhoto = nil;
    }
}

- (IBAction)backButtonTapped:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Camera

- (void)setupCamera
{
	if (!_captureSession)
	{
        _viewFinderFormat = TKCameraViewFinderFormatPortrait;
        
		_captureSession = [[AVCaptureSession alloc] init];
		_captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
		_capturePreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
//		_capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//		[_capturePreviewLayer setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		_capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        
		_capturePreviewLayer.frame = _captureView.layer.bounds;
//		_capturePreviewLayer.frame = CGRectMake(0, 0, 100, 100);
        
        
//        CGRect frame = _captureView.frame;
//        NSLog(@"frame1 = (%f, %f, %f, %f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
		[_captureView.layer addSublayer:_capturePreviewLayer];
		
		NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
		if (devices.count)
		{
			_captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
			NSError * error = nil;
			AVCaptureDeviceInput * deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
			[_captureSession addInput:deviceInput];
			
			_stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
			NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
			[_stillImageOutput setOutputSettings:outputSettings];
			[_captureSession addOutput:_stillImageOutput];
			[_captureSession startRunning];
		}
	}
}

- (void)viewDidLayoutSubviews
{
    CGRect frame = _captureView.frame;
    NSLog(@"frame = (%f, %f, %f, %f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
	_capturePreviewLayer.frame = _captureView.layer.bounds;
    
    if (self.viewFinderFormat == TKCameraViewFinderFormatPortrait)
    {
        self.portraitCaptureRect = self.captureView.frame;
    }

}

- (IBAction)takePhotoButtonTapped:(id)sender
{
	[self capturePhoto];
}

- (UIImage *)normalizedImage:(UIImage *)image
{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

- (void)capturePhoto
{
#if TARGET_IPHONE_SIMULATOR
    self.capturedPhoto = [[TKImage alloc] initWithCGImage:[UIImage imageNamed:@"SampleSkinnyJeansWomen"].CGImage];
    [self performSegueWithIdentifier:@"CameraToPhotoAcceptanceSegueIdentifier" sender:self];
    
#else
    _isCapturingImage = YES;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    __weak typeof(self) weakSelf = self;
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                   completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         
         UIImage * capturedImage = [[UIImage alloc]initWithData:imageData scale:1];
//         UIImage * capturedImage = [UIImage imageWithCGImage:[[UIImage alloc]initWithData:imageData scale:1].CGImage
//                                                       scale:1.0
//                                                 orientation:UIImageOrientationUp] ;
         
         capturedImage = [weakSelf normalizedImage:capturedImage];
         
         if (_captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0])
		 {
             // rear camera active
             if (weakSelf.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                 CGImageRef cgRef = capturedImage.CGImage;
                 capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationUp];
             }
             else if (weakSelf.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                 CGImageRef cgRef = capturedImage.CGImage;
                 capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationDown];
             }
         }
         else if (_captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1])
		 {
             // front camera active
             
             // flip to look the same as the camera
             if (UIInterfaceOrientationIsPortrait(weakSelf.interfaceOrientation)) capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationLeftMirrored];
             else {
                 if (weakSelf.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
                     capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationDownMirrored];
                 else if (weakSelf.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
                     capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationUpMirrored];
             }
             
         }
         
         CGSize cropSize = capturedImage.size;
         CGFloat aspectRatio = weakSelf.captureView.frame.size.width / weakSelf.captureView.frame.size.height;
         cropSize.height = cropSize.width / aspectRatio;
         
         capturedImage = [weakSelf crop:capturedImage from:capturedImage.size to:cropSize];
		 weakSelf.capturedPhoto = [[TKImage alloc] initWithCGImage:capturedImage.CGImage];
//         capturedImage;
         _isCapturingImage = NO;
         [weakSelf performSegueWithIdentifier:@"CameraToPhotoAcceptanceSegueIdentifier" sender:weakSelf];
     }];
#endif
}

- (UIImage *)crop:(UIImage *)image from:(CGSize)src to:(CGSize)dst
{
    CGPoint cropCenter = CGPointMake((src.width/2), (src.height/2));
    CGPoint cropStart = CGPointMake((cropCenter.x - (dst.width/2)), (cropCenter.y - (dst.height/2)));
    CGRect cropRect = CGRectMake(cropStart.x, cropStart.y, dst.width, dst.height);
    CGImageRef cropRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage* cropImage = [UIImage imageWithCGImage:cropRef];
    CGImageRelease(cropRef);
    
    return cropImage;
}

- (IBAction)switchCameraBtnTapped:(id)sender
{
    if (_isCapturingImage != YES)
	{
        if (self.captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
            // rear active, switch to front
            self.captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1];
            
            [self.captureSession beginConfiguration];
            AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
            for (AVCaptureInput * oldInput in self.captureSession.inputs)
			{
                [self.captureSession removeInput:oldInput];
            }
            [self.captureSession addInput:newInput];
            [self.captureSession commitConfiguration];
        }
        else if (self.captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1])
		{
            // front active, switch to rear
            self.captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
            [self.captureSession beginConfiguration];
            AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
            for (AVCaptureInput * oldInput in self.captureSession.inputs)
			{
                [self.captureSession removeInput:oldInput];
            }
            [self.captureSession addInput:newInput];
            [self.captureSession commitConfiguration];
        }
        
        [self evaluateFlashButton];
    }
}

- (IBAction)flashByttonnTapped:(id)sender
{
    if ([self.captureDevice isFlashAvailable])
    {
        if (self.captureDevice.flashActive)
        {
            if([self.captureDevice lockForConfiguration:nil])
            {
                self.captureDevice.flashMode = AVCaptureFlashModeOff;
                [self.flashButton setTintColor:[UIColor blackColor]];
            }
        }
        else
        {
            if([self.captureDevice lockForConfiguration:nil])
            {
                self.captureDevice.flashMode = AVCaptureFlashModeOn;
                [self.flashButton setTintColor:[self greenColor]];
            }
        }
        [self.captureDevice unlockForConfiguration];
    }
}

- (void)evaluateFlashButton
{
    // Evaluate Flash Available?
    if (self.captureDevice.isFlashAvailable)
    {
        self.flashButton.alpha = optionAvailableAlpha;
        
        // Evaluate Flash Active?
        if (self.captureDevice.isFlashActive)
        {
            [self.flashButton setTintColor:[self greenColor]];
        }
        else {
            [self.flashButton setTintColor:[UIColor blackColor]];
        }
    }
    else {
        self.flashButton.alpha = optionUnavailableAlpha;
        [self.flashButton setTintColor:[self darkGreyColor]];
    }
}

- (IBAction)squarePortraitButtonTapped:(id)sender
{
    self.viewFinderFormat = (self.viewFinderFormat == TKCameraViewFinderFormatPortrait) ? TKCameraViewFinderFormatSquare : TKCameraViewFinderFormatPortrait;
    
    CGRect toFrame = self.captureView.frame;
    CGFloat toHeight = (self.viewFinderFormat == TKCameraViewFinderFormatPortrait) ? self.portraitCaptureRect.size.height : self.portraitCaptureRect.size.width;
    CGFloat toY = toFrame.origin.y + ((toFrame.size.height - toHeight) / 2);
    
    if ((self.viewFinderFormat == TKCameraViewFinderFormatSquare) && ((toY + toHeight) > (toFrame.origin.y + toFrame.size.height)))
    {
        toY = toFrame.origin.y;
    }
    
    toFrame.size.height = toHeight;
    toFrame.origin.y = toY;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         self.captureView.frame = toFrame;
                         
//                         [self.view layoutIfNeeded];
                         
                     }completion:^(BOOL finished) {
                         self.capturePreviewLayer.frame = self.captureView.bounds;
                     }];

//    self.viewFinderAspectRatioConstraint.constant = 419/320;
//    [self.view setNeedsLayout];
    
    
//    [self.captureView removeConstraint:self.viewFinderAspectRatioConstraint];
//    
//    NSLayoutConstraint *constraint =[NSLayoutConstraint
//                                     constraintWithItem:self.captureView
//                                     attribute:NSLayoutAttributeHeight
//                                     relatedBy:NSLayoutRelationEqual
//                                     toItem:self.captureView
//                                     attribute:NSLayoutAttributeWidth
//                                     multiplier:3/4
//                                     constant:1.0f];
//    
//    self.viewFinderAspectRatioConstraint = constraint;
}

#pragma mark COLORS

- (UIColor *) darkGreyColor {
    return [UIColor colorWithRed:0.226082 green:0.244034 blue:0.297891 alpha:1];
}
- (UIColor *) redColor {
    return [UIColor colorWithRed:1 green:0 blue:0.105670 alpha:.6];
}
- (UIColor *) greenColor {
    return [UIColor colorWithRed:0.128085 green:.749103 blue:0.004684 alpha:0.6];
}
- (UIColor *) blueColor {
    return [UIColor colorWithRed:0 green:.478431 blue:1 alpha:1];
}


#pragma mark Camera Roll

- (void)setLastPhotoThumbnail
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSAssert(![NSThread isMainThread], @"This would create a deadlock (main thread waiting for main thread to complete)");
        
        ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary defaultAssetsLibrary];
        
        // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            // Within the group enumeration block, filter to enumerate just photos.
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            // Chooses the photo at the last index
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                
                // The end of the enumeration is signaled by asset == nil.
                if (alAsset) {
	                    
                    // Stop the enumerations
                    *stop = YES; *innerStop = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.thumbnailImageView.image = [UIImage imageWithCGImage:[alAsset thumbnail]];
                        [self.thumbnailButton setImage:[UIImage imageWithCGImage:[alAsset thumbnail]] forState:UIControlStateNormal];
                    });

                    // Do something interesting with the AV asset.
                    //                [self sendTweet:latestPhoto];
                }
            }];
        } failureBlock: ^(NSError *error) {
            // Typically you should handle an error more gracefully than this.
            NSLog(@"No groups");
        }];
    });
}

@end
