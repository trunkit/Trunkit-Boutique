//
//  ALAssetLibrary+Singleton.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/18/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "ALAssetLibrary+Singleton.h"

@implementation ALAssetsLibrary (Singleton)

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
