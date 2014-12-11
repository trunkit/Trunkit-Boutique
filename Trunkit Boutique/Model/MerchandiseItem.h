//
//  MerchandiseItem.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/9/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Motis.h"

@interface MerchandiseItem : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *styleNumber;
@property (strong, nonatomic) NSString *designerName;

//FIXME: Remove these 2
@property (strong,nonatomic) NSString *itemCategory;
@property (strong,nonatomic) NSString *itemSubCategory;

@property (strong, nonatomic) NSString *brandId;
@property (strong, nonatomic) NSString *itemCategoryId;
@property(strong, nonatomic) NSString *itemSubCategoryId;


@property (strong, nonatomic) NSString *supplierName;
@property (strong, nonatomic) NSString *fitDescription;
@property (strong, nonatomic) NSString *materialsDescription;
@property (readwrite, nonatomic) CGFloat unitPrice;
@property (strong, nonatomic) NSString *itemLongDescription;

@property (strong, nonatomic) NSMutableDictionary *quantityPerSizes;

@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSString *subTitle;

@property (strong, nonatomic) NSMutableArray *productPhotosTaken;
@property (strong, nonatomic) NSMutableArray *productPhotos;
@property (readonly, nonatomic) id mainProductPhoto;

@property (readwrite, nonatomic) NSUInteger itemId;

- (NSString *)designerName;
- (NSString *)categoryName;
- (NSString *)subCategoryName;

- (NSURL *)lastTakenPhoto;

@end
