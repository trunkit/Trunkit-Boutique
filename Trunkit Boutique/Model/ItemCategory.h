//
//  ItemCategory.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Motis.h"

@interface ItemCategory : NSObject

@property (readwrite, nonatomic) NSUInteger id;
@property (strong, nonatomic) NSString *name;
@property (readwrite, nonatomic) NSString *parentId;
//@property (readwrite, nonatomic) NSUInteger parentId;

@end
