//
//  NewsPage.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "NewsPage.h"
#import "NewsLandscapeCell.h"

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
    if (_tableView.currentCellIndex != pageIndex) {
        _tableView.currentCellIndex = pageIndex;
        [_tableView reloadData];
    }
}

#pragma mark - LandscapeViewDataSource & LandscapeViewDelegate methods

- (NSInteger)numberOfCellsInTableView:(LandscapeTableView *)tableView
{
    return _barWidget.listData.count;
}

- (LandscapeCell *)cellInTableView:(LandscapeTableView *)tableView atIndex:(NSInteger)index
{
    NewsLandscapeCell *cell = (NewsLandscapeCell *)[tableView dequeueReusableCell];
    
    if (cell == nil) {
        cell = [[NewsLandscapeCell alloc] initWithFrame:_tableView.bounds];
        cell.owner = self;
    }
    
    ColumnInfo *info = [_barWidget.listData objectAtIndex:index];
    [cell setCellData:info];
    
    return cell;
}

- (void)tableView:(LandscapeTableView *)tableView didChangeAtIndex:(NSInteger)index
{
    _barWidget.pageIndex = index;
}


@end
