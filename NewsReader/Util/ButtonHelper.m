//
//  ButtonHelper.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/17.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "ButtonHelper.h"

@implementation ButtonHelper

- (void)setButton:(UIButton *)btn
      normalColor:(UIColor *)nColor
    selectedColor:(UIColor *)sColor
{
    [self setSelected:NO];
    
    self.button = btn;
    self.normalColor = nColor;
    self.selectedColor = sColor;
    
    [self setSelected:YES];
}

- (void)setSelected:(BOOL)selected
{
    UIColor *color = selected?_selectedColor:_normalColor;
 
    [_button setTitleColor:color forState:UIControlStateNormal];
    [_button setTitleColor:color forState:UIControlStateHighlighted];
}

@end
