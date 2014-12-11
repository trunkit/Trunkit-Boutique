//
//  TextFieldSearchResultsTableViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/7/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TKReferenceValueNoneType,
    TKReferenceValueBrandType,
    TKReferenceValueCategoryType,
    TKReferenceValueSubCategoryType,
} TKReferenceValueType;

@interface TextFieldSearchResultsTableViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *matches;
@property (readwrite, nonatomic) TKReferenceValueType referenceValueType;
@property (readwrite, nonatomic) NSUInteger parentCategoryId;
@property (weak, nonatomic) UITextField *textField;

- (void)setMatchesForString:(NSString *)string;

@end
