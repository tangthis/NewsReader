//
//  BaseController.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseOperation.h"
#import "Activity.h"
@interface BaseController : UIViewController<BaseOperationDelegate>{
    BaseOperation *_operation;
    Activity *_activity;
}

- (void)showIndicator:(NSString *)tipMessage
             autoHide:(BOOL)hide
           afterDelay:(BOOL)delay;
- (void)hideIndicator;

// 导航栏设置
- (void)setNavigationTitleImage:(NSString *)imageName;
- (void)setNavigationLeft:(NSString *)imageName sel:(SEL)sel;
- (void)setNavigationRight:(NSString *)imageName;
- (void)setStatusBarStyle:(UIStatusBarStyle)style;
- (void)opSuccess:(id)data;

@end
