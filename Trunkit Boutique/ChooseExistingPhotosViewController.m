//
//  ChooseExistingPhotosViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/5/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "ChooseExistingPhotosViewController.h"

@interface ChooseExistingPhotosViewController ()

@end

@implementation ChooseExistingPhotosViewController

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
    
    [self applyThemeToTextField:self.chooseBrandTextField];
    [self applyThemeToTextField:self.styleNumberTextField];

    self.chooseBrandTextField.text = self.merchandiseItem.designerName;
    self.styleNumberTextField.text = self.merchandiseItem.styleNumber;
    
    
    
    
    
    
    NSArray *mockImages = @[@"http://assets.tobi.com/files/images/377/30827/37578/women/1/800x800.jpg",
                            @"http://whatkatewore.com/wp-content/uploads/2011/09/Kate-Hudson-Jeans-Jeanography.jpg",
                            @"http://www.eecloth.com/wp-content/uploads/2014/03/07/0/106-Hudson-Jeans-Palerme-Cuff-Knee-Short-for-Women-4.jpg",
                            @"https://s3.amazonaws.com/assets.svpply.com/large/2614718.jpg?1402501163",
                            @"http://www.stylegag.com/wp-content/uploads/2014/02/2012-women-new-designer-casual-dresses-gentlewomen-a-plus-size-bust-skirt-print-lace-decoration-bohemia.jpg",
                            @"http://cache.net-a-porter.com/images/products/35202/35202_fr_xl.jpg",
                            @"http://s7d2.scene7.com/is/image/DVF/S890401T14BBLACK?$Demandware%20Large%20Rectangle$",
                            @"http://www.maykool.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/s/k/skirts-designer-asymmetric-hem-black-skirt-004705.jpg",
                            @"http://1.bp.blogspot.com/-pz-VlK1GywY/TfdW5ul-rsI/AAAAAAAAAJg/gWt1i99FOS0/s400/summer_shoes_trehds_2011.jpg",
                            @"http://cdn.shopify.com/s/files/1/0115/5332/products/1024_lyon_blue_1024x1024.jpg?v=1398297639",
                            @"http://img.alibaba.com/wsphoto/v0/519213392/free-ship-EMS-luxury-trend-nackline-point-shirt-black-white-wedding-groom-shirt-M-L-XL.jpg",
                            @"http://blog.youdesignit.com/images/prophecy_opt.jpg",
                            @"https://trishsformalaffair.com/wp-content/uploads/2014/07/zagairi-boulevard-of-dreams-mens-long-sleeve-designer-shirt.jpg",
                            @"http://i1.tribune.com.pk/wp-content/uploads/2012/08/423410-image-1345213752-109-640x480.JPG",
                            @"http://c776239.r39.cf2.rackcdn.com/Gilli-5246-Black-White-1.jpg",
                            @"http://cdn.is.bluefly.com/mgen/Bluefly/prodImage.ms?productCode=2070113&width=300&height=300.jpg"];

    
    
    
    self.merchandiseItem.productPhotos = [mockImages mutableCopy];
    
    
    
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoPagesViewController *pages = [sb instantiateViewControllerWithIdentifier:@"PhotoPagesViewControllerIdentifier"];
    [pages setUsesMerchandiseProductPhotos:YES];
    pages.merchandiseItem = self.merchandiseItem;
    self.photoPagesController = pages;
    pages.view.frame = self.photoPagesContainerView.bounds;
    [self.photoPagesContainerView addSubview:pages.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)navigationItemTitle
{
    return @"Existing Photos";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.chooseBrandTextField)
    {
        [self.styleNumberTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.chooseBrandTextField)
    {
        [self.styleNumberTextField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.styleNumberTextField)
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (TKReferenceValueType)referenceValueTypeForTextField:(UITextField *)textField
{
    if (textField == self.chooseBrandTextField)
        return TKReferenceValueBrandType;
    
    return TKReferenceValueNoneType;
}

- (IBAction)continueButtonTapped:(id)sender
{
    //TODO: Fields validation
    
    //TODO: Lookup existing photos and branch navigation
    
    self.merchandiseItem.styleNumber = self.styleNumberTextField.text;
    self.merchandiseItem.designerName = self.chooseBrandTextField.text;
    
    [self performSegueWithIdentifier:@"ChooseExistingPhotosToSupplyItemPage2SegueIdentifier" sender:sender];
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
