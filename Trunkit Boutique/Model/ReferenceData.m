//
//  ReferenceData.m
//  Trunkit Boutique
//
//  Created by Frank LeGrand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "ReferenceData.h"

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

- (void)reloadData
{
    [self loadBrands];
}

- (void)loadBrands
{
    TrunkitService *service = [[TrunkitService alloc] init];
    [service queryBrands:^(BOOL success, NSArray *records, NSError *error) {
        if (!success) {
            NSLog(@"ERROR loading brands: %@", error);
            return;
        }
        NSLog(@"Loaded brands: %@", records);
        self.brands = records;
    }];
}

@end
