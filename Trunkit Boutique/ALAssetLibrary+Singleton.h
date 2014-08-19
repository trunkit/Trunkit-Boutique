//
//  ALAssetLibrary+Singleton.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/18/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>


@interface ALAssetsLibrary (Singleton)

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end
