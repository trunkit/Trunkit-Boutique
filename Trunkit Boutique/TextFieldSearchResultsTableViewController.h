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

@interface TextFieldSearchResultsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *matches;
@property (readwrite) TKReferenceValueType referenceValueType;
@property (weak, nonatomic) UITextField *textField;

- (void)setMatchesForString:(NSString *)string;

@end
