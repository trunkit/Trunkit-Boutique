//
//  TrunkitService.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "TrunkitService.h"

@implementation TrunkitService

- (NSString *)apiKey
{
    return @"sZxEXrF5czuBd2o-C_LK";
}

- (void)queryItems:(QueryCompletionBlock)completionBlock
{
    NSString *itemsRootAPI = @"https://www.trunkit.com/items.json";
    NSString *getItemsAPI = [itemsRootAPI stringByAppendingString:[NSString stringWithFormat:@"?api_key=%@", [self apiKey]]];
    NSURL *getItemsURL = [NSURL URLWithString:getItemsAPI];
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    [[urlSession dataTaskWithURL:getItemsURL
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   NSArray *records = nil;
                   
                   if (error) {
                       NSLog(@"Error in request with URL %@: %@", getItemsURL, error);
                   }
                   else
                   {
                       NSMutableArray *workArray = [@[] mutableCopy];
                       
                       NSError *serializeError = nil;
                       NSArray *feedArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializeError];
                       if (serializeError) {
                           //TODO: Add to the returned error
                           NSLog(@"Error serializing feed: %@", serializeError);
                       }
                       else
                       {
                           for (NSDictionary *aDict in feedArray) {
                               MerchandiseItem *item = [[MerchandiseItem alloc] init];
                               [item mts_setValuesForKeysWithDictionary:aDict];
                               [workArray addObject:item];
                           }
                           records = [NSArray arrayWithArray:workArray];
                       }
                   }
                   completionBlock((!error), records, error);
                   
               }] resume];
}

- (void)queryItemWithId:(NSUInteger)itemId completionBlock:(QueryCompletionBlock)completionBlock
{
    NSString *itemRootAPI = [NSString stringWithFormat:@"https://www.trunkit.com/items/%lu.json", (unsigned long)itemId];
    NSString *getItemAPI = [itemRootAPI stringByAppendingString:[NSString stringWithFormat:@"?api_key=%@", [self apiKey]]];
    NSURL *getItemURL = [NSURL URLWithString:getItemAPI];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    [[urlSession dataTaskWithURL:getItemURL
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   NSDictionary *itemDict = nil;
                   
                   if (error) {
                       NSLog(@"Error in request with URL %@: %@", getItemURL, error);
                   }
                   else
                   {
                       NSError *serializeError = nil;
                       itemDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializeError];
                       if (serializeError) {
                           //TODO: Add to the returned error
                           NSLog(@"Error serializing item: %@", serializeError);
                       }
                   }
                   completionBlock((!error), @[itemDict], error);
                   
               }] resume];
}

- (void)queryBrands:(QueryCompletionBlock)completionBlock
{
    NSString *brandsRootAPI = @"https://www.trunkit.com/brands.json";
    NSString *getBrandsAPI = [brandsRootAPI stringByAppendingString:[NSString stringWithFormat:@"?api_key=%@", [self apiKey]]];
    NSURL *getBrandsURL = [NSURL URLWithString:getBrandsAPI];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    [[urlSession dataTaskWithURL:getBrandsURL
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   NSArray *records = nil;
                   
                   if (error) {
                       NSLog(@"Error in request with URL %@: %@", getBrandsURL, error);
                   }
                   else
                   {
                       NSMutableArray *workArray = [@[] mutableCopy];
                       
                       NSError *serializeError = nil;
                       NSArray *brandsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializeError];
                       if (serializeError) {
                           //TODO: Add to the returned error
                           NSLog(@"Error serializing brands: %@", serializeError);
                       }
                       else
                       {
                           for (NSDictionary *aDict in brandsArray) {
                               Brand *brand = [[Brand alloc] init];
                               [brand mts_setValuesForKeysWithDictionary:aDict];
                               [workArray addObject:brand];
                           }
                           records = [NSArray arrayWithArray:workArray];
                       }
                   }
                   completionBlock((!error), records, error);
               }] resume];
}

@end
