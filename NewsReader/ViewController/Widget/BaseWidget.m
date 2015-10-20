//
//  BaseWidget.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BaseWidget.h"

@implementation BaseWidget
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadData];
}

- (void)updateUI
{
}

- (void)reloadData
{
    if (![self isReloadLocalData]) {
        [self requestServer];
    }
    else {
        [self requestServerOp];
        [self updateUI];
    }
}

- (BOOL)isReloadLocalData
{
    BOOL isReload = self.listData.count > 0;
    
    if (isReload) {
        [self updateUI];
    }
    
    return isReload;
}

- (void)requestServer
{
    [self showIndicator:LoadingTip autoHide:NO afterDelay:NO];
    [self requestServerOp];
}

- (void)requestServerOp
{
}

@end
