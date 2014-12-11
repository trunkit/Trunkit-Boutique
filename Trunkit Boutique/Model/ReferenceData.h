//
//  ReferenceData.h
//  Trunkit Boutique
//
//  Created by Frank LeGrand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrunkitService.h"
#import "ItemCategory.h"

typedef void (^ReferenceDataDidReloadBlock)(BOOL success, NSError *error);

@interface ReferenceData : NSObject

@property (strong, atomic) NSArray *brands;

+ (ReferenceData *)sharedReferenceData;
- (void)reloadDataWithCompletionBlock:(ReferenceDataDidReloadBlock)completionBlock;

- (NSArray *)mainCategories;
- (NSArray *)subCategoriesForCategory:(ItemCategory *)category;
- (NSArray *)subCategoriesForCategoryId:(NSUInteger)categoryId;
- (NSString *)nameForCategoryId:(NSUInteger)categoryId;
- (ItemCategory *)categoryForName:(NSString *)name;
- (NSString *)nameForBrandId:(NSUInteger)brandId;
- (Brand *)brandForName:(NSString *)name;

@end
