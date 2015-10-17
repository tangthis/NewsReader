//
//  ButtonHelper.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/17.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonHelper : NSObject

@property(nonatomic, strong) UIButton   *button;
@property(nonatomic, strong) UIColor    *normalColor;
@property(nonatomic, strong) UIColor    *selectedColor;

- (void)setButton:(UIButton *)btn
      normalColor:(UIColor *)nColor
    selectedColor:(UIColor *)sColor;

- (void)setSelected:(BOOL)selected;

@end
