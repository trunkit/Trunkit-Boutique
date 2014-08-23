//
//  ItemTableViewCell.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/21/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "ALAssetsLibrary+TKSingleton.h"

@implementation ItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setImage:(id)image
//{
//    _image = image;
//    [self setImageOnImageView];
//}
//
//- (void)setImageOnImageView
//{
//    UIImage *photo = nil;
//    
//    if ([_image isKindOfClass:[ALAsset class]])
//    {
//        ALAsset *asset = (ALAsset *)_image;
//        photo = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//        self.imageView.image = photo;
//    }
//    else if ([_image isKindOfClass:[NSURL class]])
//    {
//        ALAssetsLibrary *library = [ALAssetsLibrary defaultAssetsLibrary];
//        [library assetForURL:(NSURL *)_image
//                 resultBlock:^(ALAsset *asset) {
//                     NSLog(@"Read asset: %@ - %@", asset, asset.defaultRepresentation.url);
//                     
//                     UIImage *photo = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//                     self.productPhotoImageView.image = photo;
//                 }
//                failureBlock:^(NSError *error )
//         {
//             NSLog(@"ERROR %s: %@", __PRETTY_FUNCTION__, error);
//         }];
//    }
//    else if ([_image isKindOfClass:[UIImage class]])
//    {
//        self.productPhotoImageView.image = _image;
//    }
//}


@end
