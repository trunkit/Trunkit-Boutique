//
//  Brand.h
//  Trunkit Boutique
//
//  Created by Frank LeGrand on 12/10/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Motis.h"

@interface Brand : NSObject

@property (readwrite, nonatomic) NSUInteger id;
@property (strong, nonatomic) NSString *name;

@end
