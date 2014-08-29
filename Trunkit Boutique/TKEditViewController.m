//
//  TKEditViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/6/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "TKEditViewController.h"
#import "UILabel+UILabel_TKExtensions.h"

#define kOFFSET_FOR_KEYBOARD        216.0f

@interface TKEditViewController ()

@end

@implementation TKEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIFont *placeholerrFont = [UIFont fontWithName:@"HelveticaLTStd-LightCond" size:18.0];
    self.descriptionTextViewPlaceholder.font = placeholerrFont;
    [self applyThemeToLabel:self.descriptionTextViewPlaceholder withFontSize:16.0];

//    UILabel *customFontLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
//    customFontLabel.text = [self navigationItemTitle];
//    
//    customFontLabel.textAlignment = NSTextAlignmentCenter;
    
    UIFont *titleFont = [UIFont fontWithName:@"BebasNeue" size:18.0];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationTitleLabel.font = titleFont;
    [self.navigationTitleLabel applyThemeAttribute];
    
    
//    self.navigationItem.hidesBackButton = YES;
    
    
    if ([self singleTapDiscardsKeyboard])
    {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setDelegate:self];
        self.singleTap = singleTap;
        if (self.singleTapDiscardsKeyboard)
        [self.view addGestureRecognizer:singleTap];
        [self registerForKeyboardNotifications];
    }
    
}

- (NSString *)navigationItemTitle
{
    return @"Title Here";
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)singleTapDiscardsKeyboard
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[self unregisterFromKeyboardNotifications];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // WTF
    if (self.scrollView.frame.origin.y == 20)
    {
        self.scrollView.frame = CGRectMake(0.0, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height+20);
    }
    self.scrollView.contentSize = self.detailsContainerView.frame.size;
//    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    

}

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeButtonTapped:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark Keyboard UX

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)unregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{
}

- (void)keyboardWillShow:(NSNotification *)note
{
}

- (void)scrollToMakeViewVisible:(UIView *)textField
{
    [self.scrollView setContentOffset:[self viewOriginForEdit:textField] animated:YES];
}

- (CGPoint)viewOriginForEdit:(UIView *)view
{
    CGRect scrollToRect = view.frame;
    CGFloat scrollY = scrollToRect.origin.y - 20;
    CGPoint scrollPoint = CGPointMake(0.0, scrollY);
    return scrollPoint;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    [self hideTextFieldSearchResults];
}

- (void)hideTextFieldSearchResults
{
    if (!self.matchesTableViewController)
        return;
    
    __block TextFieldSearchResultsTableViewController *tableViewController = self.matchesTableViewController;
    self.matchesTableViewController = nil;
    
    CGRect frame = tableViewController.tableView.frame;
    frame.origin.y += 50;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         tableViewController.tableView.frame = frame;
         tableViewController.view.alpha = 0.0;
     }
                     completion:^(BOOL finished)
     {
         [tableViewController.tableView removeFromSuperview];
         tableViewController = nil;
     }];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    NSLog(@"%@", touch.view);
//    NSLog(@"%@", touch.view.superview);
//    NSLog(@"%@", touch.view.superview.superview);
//    NSLog(@"%@", touch.view.superview.superview.superview);
//    NSLog(@"%@", touch.view.superview);
    
    if ([touch.view isKindOfClass:[UIControl class]]
        || [touch.view.superview.superview isKindOfClass:[UITableViewCell class]])
        return NO;
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
	//    if (![self.deliveryDatePickerView isHidden])
	//    {
	//        [self dismissPicker:nil];
	//    }
}

#pragma mark Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self hideTextFieldSearchResults];
    [self scrollToMakeViewVisible:textView];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

#pragma mark Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hideTextFieldSearchResults];
    
    TKReferenceValueType referenceValueType = [self referenceValueTypeForTextField:textField];
    if (referenceValueType != TKReferenceValueNoneType)
    {
        if (!_matchesTableViewController)
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TextFieldSearchResultsTableViewController *tableViewController = [sb instantiateViewControllerWithIdentifier:@"TextFieldSearchResultsTableViewControllerIdentifier"];
            
            tableViewController.referenceValueType = referenceValueType;
            tableViewController.textField = textField;
            [self addChildViewController:tableViewController];
            
            CGFloat height = [UIScreen mainScreen].bounds.size.height - kOFFSET_FOR_KEYBOARD; // / [UIScreen mainScreen].scale;
            CGPoint point = [self viewOriginForEdit:textField];
            CGRect frame = CGRectMake(point.x + 6
                                      , point.y + (textField.frame.size.height * 1.5)
                                      , textField.frame.size.width
                                      , height);

            tableViewController.view.frame = frame;
            tableViewController.view.alpha = 0.0;
            [tableViewController.tableView reloadData];
            [self.matchesTableViewController setMatchesForString:textField.text];
            [self.detailsContainerView addSubview:tableViewController.tableView];
            self.matchesTableViewController = tableViewController;
            
            [UIView animateWithDuration:0.6
                                  delay:0.1
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^
             {
                 tableViewController.view.alpha = 1.0;
             }
                             completion:^(BOOL finished)
             {
                 
             }];
        }
    }
    
    [self scrollToMakeViewVisible:textField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self textFieldHasCurrencyFormat:textField])
    {
        [self formatCurrencyField:textField];
    }
}

- (BOOL)textFieldHasCurrencyFormat:(UITextField *)textField
{
    return NO;
}

- (TKReferenceValueType)referenceValueTypeForTextField:(UITextField *)textField
{
    return TKReferenceValueNoneType; //override
}

- (IBAction)textFieldTextDidChange:(UITextField *)textField
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.matchesTableViewController setMatchesForString:textField.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    NSLog(@"%s, %@", __PRETTY_FUNCTION__, textField);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

//- (BOOL)textFieldShowsMatches:(UITextField *)textField
//{
//    return NO;
//}

#pragma mark - Theming

- (void)applyThemeToTextField:(UITextField *)textField
{
    UIFont *regularFont = [UIFont fontWithName:@"HelveticaLTStd-LightCond" size:18.0];
    //    UIFont *largeFont = [UIFont fontWithName:@"LucidaGrande" size:20.0];
	
	textField.font = regularFont;
	UIView *styleNumberPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
	textField.leftView = styleNumberPaddingView;
	textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderWidth = 2.0f;
}

- (void)applyThemeToTextView:(UITextView *)textView
{
    UIFont *regularFont = [UIFont fontWithName:@"HelveticaLTStd-LightCond" size:16.0];
    //    UIFont *largeFont = [UIFont fontWithName:@"LucidaGrande" size:20.0];
	
	textView.font = regularFont;
    //	UIView *styleNumberPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    //	textView.leftView = styleNumberPaddingView;
    //	textView.leftViewMode = UITextFieldViewModeAlways;
    
    textView.layer.borderWidth = 2.0f;
}

- (void)applyThemeToTextView:(UITextView *)textView  withFontSize:(CGFloat)fontSize
{
    UIFont *regularFont = [UIFont fontWithName:@"HelveticaLTStd-LightCond" size:fontSize];
	textView.font = regularFont;
}

- (void)applyThemeToLabel:(UILabel *)label withFontSize:(CGFloat)fontSize
{
    UIFont *regularFont = [UIFont fontWithName:@"HelveticaLTStd-LightCond" size:fontSize];
//    UIFont *largeFont = [UIFont fontWithName:@"LucidaGrande" size:fontSize];
	
	label.font = regularFont;
}

- (void)applyTitleThemeToLabel:(UILabel *)label withFontSize:(CGFloat)fontSize
{
    UIFont *largeFont = [UIFont fontWithName:@"BebasNeue" size:fontSize];
	
	label.font = largeFont;
}

- (void)applyThemeToWhiteButton:(UIButton *)button
{
    UIFont *largeFont = [UIFont fontWithName:@"BebasNeue" size:18.0];
    button.titleLabel.font = largeFont;
    
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [button.titleLabel applyThemeAttribute];
    [button setNeedsLayout];
}

- (void)applyThemeToBlackButton:(UIButton *)button
{
    [self applyThemeToBlackButton:button withFontSize:19.0];
}

- (void)applyThemeToBlackButton:(UIButton *)button withFontSize:(CGFloat)fontSize
{
    UIFont *largeFont = [UIFont fontWithName:@"BebasNeue" size:fontSize];
    button.titleLabel.font = largeFont;
    [button.titleLabel applyThemeAttribute];
    button.contentEdgeInsets = UIEdgeInsetsMake(2.0, 2.0, 0.0, 0.0);

    [button setNeedsLayout];
}

- (void)formatCurrencyField:(UITextField *)textField
{
    NSLocale* currentUserLocale = [NSLocale currentLocale];
    
    // If the user just typed the number in, e.g. 12.34 or 42, prepend the currency symbol:
    NSString *currencySymbol = [currentUserLocale objectForKey:NSLocaleCurrencySymbol];
    
    NSRange strRange = [textField.text rangeOfString:currencySymbol];
    if (strRange.location == NSNotFound)
    {
        NSString *numberStr = [NSNumberFormatter localizedStringFromNumber:[NSDecimalNumber numberWithFloat:[textField.text floatValue]]
                                                               numberStyle:NSNumberFormatterCurrencyStyle];
        textField.text = numberStr;
    }
    else
    {
        // contains a currency symbol, but we don't know if it's in the form $xx.nn or just $xx.
        // If it's $xx, we want to change it to $xx.00:
        NSString *decimalSeparator = [currentUserLocale objectForKey:NSLocaleDecimalSeparator];
        NSRange resultsRange = [textField.text rangeOfString:decimalSeparator
                                                     options:NSCaseInsensitiveSearch];
        if(resultsRange.location == NSNotFound)
        {
            // number is in form $XX, change it to $XX.00:
            NSNumberFormatter *costFmt = [[NSNumberFormatter alloc] init];
            [costFmt setNumberStyle:NSNumberFormatterCurrencyStyle];
            
            NSNumber* floatNum = [costFmt numberFromString:textField.text];
            NSNumber *costNum=[NSNumber numberWithFloat:[floatNum floatValue]];
            NSString* costStr = [costFmt stringFromNumber:costNum];
            
            textField.text = costStr;
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc respondsToSelector:@selector(setMerchandiseItem:)])
    {
        [(id)vc setMerchandiseItem:self.merchandiseItem];
    }
}

@end
