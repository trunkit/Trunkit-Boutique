//
//  SupplyAnItemPageViewController.h
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/2/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKEditViewController.h"

@interface SupplyAnItemPageViewController : TKEditViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

//@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UILabel *pageNumberLabel;

- (IBAction)continueButtonTapped:(id)sender;

//- (void)applyThemeToTextField:(UITextField *)textField;
//- (void)applyThemeToLabel:(UILabel *)label withFontSize:(CGFloat)fontSize;
//- (void)applyThemeToTextView:(UITextView *)textView;
//- (void)applyThemeToWhiteButton:(UIButton *)button;
//- (void)applyThemeToBlackButton:(UIButton *)button;

@end
