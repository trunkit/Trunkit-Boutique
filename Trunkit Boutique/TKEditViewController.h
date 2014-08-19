//
//  TKEditViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/6/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TKSearchResultTableViewCell.h"
#import "TextFieldSearchResultsTableViewController.h"
#import "MerchandiseItem.h"

@interface TKEditViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) MerchandiseItem *merchandiseItem;

@property (strong, nonatomic) IBOutlet UILabel *navigationTitleLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *detailsContainerView;

@property (strong, nonatomic) IBOutlet UILabel *descriptionTextViewPlaceholder;

@property (strong, nonatomic) UITapGestureRecognizer *singleTap;

@property (strong, nonatomic) IBOutlet TextFieldSearchResultsTableViewController *matchesTableViewController;

- (IBAction)textFieldTextDidChange:(UITextField *)textField;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)closeButtonTapped:(id)sender;

- (void)applyThemeToTextField:(UITextField *)textField;
- (void)applyThemeToLabel:(UILabel *)label withFontSize:(CGFloat)fontSize;
- (void)applyTitleThemeToLabel:(UILabel *)label withFontSize:(CGFloat)fontSize;
- (void)applyThemeToTextView:(UITextView *)textView;
- (void)applyThemeToTextView:(UITextView *)textView  withFontSize:(CGFloat)fontSize;
- (void)applyThemeToWhiteButton:(UIButton *)button;
- (void)applyThemeToBlackButton:(UIButton *)button;
- (void)applyThemeToBlackButton:(UIButton *)button withFontSize:(CGFloat)fontSize;

//- (BOOL)textFieldShowsMatches:(UITextField *)textField;
- (TKReferenceValueType)referenceValueTypeForTextField:(UITextField *)textField;

- (BOOL)singleTapDiscardsKeyboard;
- (BOOL)textFieldHasCurrencyFormat:(UITextField *)textField;
- (void)formatCurrencyField:(UITextField *)textField;

@end
