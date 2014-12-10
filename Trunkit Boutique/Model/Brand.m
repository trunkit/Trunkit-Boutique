//
//  Brand.m
//  Trunkit Boutique
//
//  Created by Frank LeGrand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "Brand.h"

@implementation Brand

+ (NSDictionary*)mts_mapping
{
    return @{@"name": mts_key(name),
             @"id": mts_key(id)
             };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, id:%lu name: %@>", NSStringFromClass([self class]), self, _id, _name];
}


@end
