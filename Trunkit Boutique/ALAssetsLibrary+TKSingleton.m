//
//  ALAssetsLibrary+TKSingleton.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 8/21/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "ALAssetsLibrary+TKSingleton.h"


@implementation ALAssetsLibrary (TKSingleton)

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{     //write the image data to the assets library (camera roll)
    [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
                       completionBlock:^(NSURL* assetURL, NSError* error)
     {
         //error handling
         if (error!=nil)
         {
             completionBlock(assetURL, error);
             return;
         }
         
         //add the asset to the custom photo album
         [self addAssetURL: assetURL
                   toAlbum:albumName
       withCompletionBlock:completionBlock];
     }];
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    __block BOOL albumWasFound = NO;
    //search all photo albums in the library
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         //compare the names of the albums
         if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame)
         {
             //target album is found
             albumWasFound = YES;
             
             //get a hold of the photo's asset instance
             [self assetForURL: assetURL
                   resultBlock:^(ALAsset *asset) {
                       //add photo to the target album
                       [group addAsset: asset];
                       //run the completion block
                       completionBlock(assetURL, nil);
                   }
                  failureBlock: ^(NSError *error) {
                      completionBlock (nil, error);
                      
                  }];
             //album was found, bail out of the method
             return;
         }
         if (group==nil && albumWasFound==NO)
         {
             //photo albums are over, target album does not exist, thus create it
             ALAssetsLibrary* weakSelf = self;
             //create new assets album
             [self addAssetsGroupAlbumWithName:albumName
                                   resultBlock:^(ALAssetsGroup *group) {
                                       //get the photo's instance
                                       [weakSelf assetForURL: assetURL
                                                 resultBlock:^(ALAsset *asset)
                                        {
                                            //add photo to the newly created album
                                            [group addAsset:asset];
                                            //call the completion block
                                            completionBlock(assetURL, nil);
                                        }
                                                failureBlock: ^(NSError *error) {
                                                    completionBlock (nil, error);
                                                    
                                                }];
                                   } failureBlock: ^(NSError *error) {
                                       completionBlock (nil, error);
                                       
                                   }];
             return;
         }
     }
     
                      failureBlock: ^(NSError *error) {
                          completionBlock (nil, error);
                          
                      }];
}

@end
