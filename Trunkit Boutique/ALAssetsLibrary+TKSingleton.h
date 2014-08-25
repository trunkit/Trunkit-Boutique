//
//  ALAssetsLibrary+TKSingleton.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/21/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#define TK_PHOTO_ALBUM_NAME @"Trunkit Boutique"

typedef void(^SaveImageCompletion)(NSURL *assetURL, NSError* error);

@interface ALAssetsLibrary (TKSingleton)

+ (ALAssetsLibrary *)defaultAssetsLibrary;

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

@end
