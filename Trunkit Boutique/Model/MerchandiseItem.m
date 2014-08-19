//
//  MerchandiseItem.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/9/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "MerchandiseItem.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MerchandiseItem

- (id)init
{
    self = [super init];
    if (self)
    {
        self.productPhotos = [@[] mutableCopy];
        self.productPhotosTaken = [@[] mutableCopy];
        self.quantityPerSizes = [[NSMutableDictionary alloc] init];
        self.unitPrice = 0.0f;
    }
    return self;
}

- (UIImage *)mainProductPhoto
{
    if (_productPhotos.count)
    {
        id mainPhoto = [self.productPhotos objectAtIndex:0];
        if ([mainPhoto isKindOfClass:[ALAsset class]])
        {
            ALAsset *asset = (ALAsset *)mainPhoto;
            return [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        }
        return [self.productPhotos objectAtIndex:0];
    }
    return nil;
}

- (UIImage *)lastTakenPhoto
{
    if (_productPhotosTaken.count)
    {
        return [self.productPhotosTaken lastObject];
    }
    return nil;
}

- (NSString *)title
{
    return _itemName;
}

- (NSString *)subTitle
{
    return _styleNumber;
}

@end
