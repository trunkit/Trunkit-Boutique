//
//  ReferenceData.m
//  Trunkit Boutique
//
//  Created by Frank LeGrand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "ReferenceData.h"

@interface ReferenceData()

@property (strong, atomic) NSArray *categories;

@end


@implementation ReferenceData

+ (ReferenceData *)sharedReferenceData;
{
    static dispatch_once_t pred;
    static ReferenceData *sharedReferenceData = nil;
    
    dispatch_once(&pred, ^{
        sharedReferenceData = [[[self class] alloc] init];
    });
    return sharedReferenceData;
}

- (void)reloadDataWithCompletionBlock:(ReferenceDataDidReloadBlock)completionBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [self loadBrandsOnDispatchQueue:queue group:group];
    [self loadCategoriesOnDispatchQueue:queue group:group];
    
    dispatch_group_notify(group, queue, ^(){
        NSLog(@"Loaded %lu brands.", self.brands.count);
        NSLog(@"Loaded %lu categories.", self.categories.count);
        completionBlock((self.brands.count && self.categories.count), nil);
    });
}

- (void)loadBrandsOnDispatchQueue:(dispatch_queue_t)dispatchQueue group:(dispatch_group_t)dispatchGroup
{
    dispatch_group_enter(dispatchGroup);
    dispatch_async(dispatchQueue, ^{
        TrunkitService *service = [[TrunkitService alloc] init];
        [service queryBrands:^(BOOL success, NSArray *records, NSError *error) {
            if (!success) {
                NSLog(@"ERROR loading brands: %@", error);
            }
            else
            {
                self.brands = records;
            }
            dispatch_group_leave(dispatchGroup);
        }];
    });
}

- (void)loadCategoriesOnDispatchQueue:(dispatch_queue_t)dispatchQueue group:(dispatch_group_t)dispatchGroup
{
    dispatch_group_enter(dispatchGroup);
    dispatch_async(dispatchQueue, ^{
        TrunkitService *service = [[TrunkitService alloc] init];
        [service queryCategories:^(BOOL success, NSArray *records, NSError *error) {
            if (!success) {
                NSLog(@"ERROR loading categories: %@", error);
            }
            else
            {
                self.categories = records;
            }
            dispatch_group_leave(dispatchGroup);
        }];
    });
}

- (NSArray *)mainCategories
{
    NSPredicate *nullParentPredicate = [NSPredicate predicateWithBlock:^BOOL(ItemCategory *itemCategory, NSDictionary *bindings) {
        return (!itemCategory.parentId);
    }];
    return [self.categories filteredArrayUsingPredicate:nullParentPredicate];
}

- (NSArray *)subCategoriesForCategory:(ItemCategory *)category
{
    return [self subCategoriesForCategoryId:category.id];
}

- (NSArray *)subCategoriesForCategoryId:(NSUInteger)categoryId
{
    NSPredicate *childPredicate = [NSPredicate predicateWithBlock:^BOOL(ItemCategory *itemCategory, NSDictionary *bindings) {
        return (itemCategory.parentId && [itemCategory.parentId integerValue] == categoryId);
    }];
    return [self.categories filteredArrayUsingPredicate:childPredicate];
}

- (NSString *)nameForCategoryId:(NSUInteger)categoryId
{
    for (ItemCategory *aCategory in self.categories) {
        if (aCategory.id == categoryId)
        {
            return aCategory.name;
        }
    }
    return nil;
}

- (ItemCategory *)categoryForName:(NSString *)name
{
    for (ItemCategory *aCategory in self.categories) {
        if ([aCategory.name isEqualToString:name])
        {
            return aCategory;
        }
    }
    return nil;
}

- (NSString *)nameForBrandId:(NSUInteger)brandId
{
    for (Brand *aBrand in self.brands) {
        if (aBrand.id == brandId)
        {
            return aBrand.name;
        }
    }
    return nil;
}

- (Brand *)brandForName:(NSString *)name
{
    for (Brand *aBrand in self.brands) {
        if ([aBrand.name isEqualToString:name])
        {
            return aBrand;
        }
    }
    return nil;
}

@end
