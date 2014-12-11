//
//  ItemCategory.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import "ItemCategory.h"

@implementation ItemCategory

+ (NSDictionary*)mts_mapping
{
    return @{@"name": mts_key(name),
             @"id": mts_key(id),
             @"parent_id": mts_key(parentId)
             };
}

- (BOOL)mts_validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing *)outError
{
//    if ([inKey isEqualToString:@"parentId"])
//    {
//        NSLog(@"VALUE = %@", *ioValue);
//    }
    return YES;
}

- (NSString *)description
{
//    return [NSString stringWithFormat:@"<%@: %p, id:%lu, parentId:%lu, name: %@>", NSStringFromClass([self class]), self, _id, _parentId, _name];
    return [NSString stringWithFormat:@"<%@: %p, id:%lu name: %@>", NSStringFromClass([self class]), self, _id, _name];
}

@end
