//
//  ReferenceData.h
//  Trunkit Boutique
//
//  Created by Frank LeGrand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrunkitService.h"

@interface ReferenceData : NSObject

@property (strong, nonatomic) NSArray *brands;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *subCategories;

+ (ReferenceData *)sharedReferenceData;
- (void)reloadData;

@end
