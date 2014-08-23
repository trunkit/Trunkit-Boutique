//
//  ALAssetsLibrary+TKSingleton.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/21/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (TKSingleton)

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end
