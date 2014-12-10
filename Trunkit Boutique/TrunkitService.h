//
//  TrunkitService.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchandiseItem.h"
#import "Brand.h"

typedef void (^QueryCompletionBlock)(BOOL success, NSArray *records, NSError *error);

@interface TrunkitService : NSObject

- (void)queryItems:(QueryCompletionBlock)completionBlock;
- (void)queryItemWithId:(NSUInteger)itemId completionBlock:(QueryCompletionBlock)completionBlock;

- (void)queryBrands:(QueryCompletionBlock)completionBlock;


@end
