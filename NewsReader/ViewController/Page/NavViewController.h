//
//  NavViewController.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/27.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BasePage.h"

@interface NavViewController : BasePage
@property(nonatomic, strong) NSString   *barBackgroudImage;

- (void)setNavigationItem:(NSString *)title
                 selector:(SEL)selector
                  isRight:(BOOL)isRight;
@end
