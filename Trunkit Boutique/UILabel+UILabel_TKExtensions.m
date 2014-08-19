//
//  UILabel+UILabel_TKExtensions.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/26/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "UILabel+UILabel_TKExtensions.h"

@implementation UILabel (UILabel_TKExtensions)

- (void)applyThemeAttribute
{
    NSString *string = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    self.text = nil;
    self.attributedText = attributedString;
}

- (void)setTKThemeText:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
//    self.text = nil;
    self.attributedText = attributedString;
}

@end
