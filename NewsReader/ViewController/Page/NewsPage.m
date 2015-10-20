//
//  NewsPage.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "NewsPage.h"

@implementation NewsPage

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_barWidget == nil) {
        [self addBarWidget];
    }
}

- (void)addBarWidget
{
    _barWidget = [[ColumnBarWidget alloc] init];
    
    _barWidget.delegate = self;
    _barWidget.view.frame = _backBarView.bounds;
    [_backBarView addSubview:_barWidget.view];
    
    [_backBarView sendSubviewToBack:_barWidget.view];
}

- (void)didSelect:(NSInteger)pageIndex
{

}

@end
