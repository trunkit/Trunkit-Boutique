//
//  MerchandiseItem.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/9/14.
//  Copyright (c) 2014 MyFourSonsApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchandiseItem : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *styleNumber;
@property (strong, nonatomic) NSString *designerName;

@property (strong,nonatomic) NSString *itemCategory;
@property (strong,nonatomic) NSString *itemSubCategory;

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
@property (readonly, nonatomic) UIImage *mainProductPhoto;

- (NSURL *)lastTakenPhoto;

@end
