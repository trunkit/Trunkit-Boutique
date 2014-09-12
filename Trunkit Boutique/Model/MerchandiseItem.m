//
//  MerchandiseItem.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/9/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "MerchandiseItem.h"
#import "ALAssetsLibrary+TKSingleton.h"

@implementation MerchandiseItem

+ (NSDictionary*)mts_mapping
{
    return @{@"name": mts_key(itemName),
             @"price": mts_key(unitPrice),
             @"description": mts_key(itemLongDescription),
             @"fit": mts_key(fitDescription),
             @"construction": mts_key(materialsDescription),
             @"boutique_id": mts_key(supplierName),
             @"primary_category_id": mts_key(designerName),
             @"secondary_category_id": mts_key(designerName),
             @"sizes": mts_key(quantityPerSizes),
             };
}

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

- (id)mainProductPhoto
{
    return [self imageAtIndex:0];
}

- (UIImage *)imageAtIndex:(NSInteger)index
{
    if (!_productPhotos.count || (index < 0) || (index > _productPhotos.count - 1))
    {
        return nil;
    }

    id image = [self.productPhotos objectAtIndex:index];
    if (![image isKindOfClass:[NSURL class]])
    {
        NSLog(@"WARNING! Object in photo array in not a URL: %@", image);
//        return image;
    }
    return image;
//    else
//    {
//        // Probably will not keep this code
//        //
//        ALAssetsLibrary *library = [ALAssetsLibrary defaultAssetsLibrary];
//        [library assetForURL:image
//                 resultBlock:^(ALAsset *asset) {
//                     NSLog(@"WARNING! %s called unexpectedly.", __PRETTY_FUNCTION__);
//                 }
//                failureBlock:^(NSError *error )
//         {
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving Photo"
//                                                             message:@"A system error occurred while trying to save your photo."
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
//             [alert show];
//             NSLog(@"Error loading asset");
//         }];
//        
////        return [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
//    }
//    return nil;
}

- (NSURL *)lastTakenPhoto
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
