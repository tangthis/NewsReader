//
//  LandscapeTableView.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/21.
//  Copyright (c) 2015年 tangtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandscapeCell.h"

@protocol LandscapeTableViewDelegate;
@protocol LandscapeTableViewDataSource;

@interface LandscapeTableView : UIView <UIScrollViewDelegate> {
    
    // 存储页面的滚动条容器
    UIScrollView                *_scrollView;
    
    // 单元格之间的间隔，缺省20
    CGFloat                     _gapBetweenCells;
    // 预先加载的单元格数，在可见单元格的两边预先加载不可见单元格的数目
    NSInteger                   _cellsToPreload;
    // 单元格总数
    NSInteger                   _cellCount;
    // 当前索引
    NSInteger                   _currentCellIndex;
    // 上次选择的单元格索引
    NSInteger                   _lastCellIndex;
    // 加载当前可见单元格左边的索引
    NSInteger                   _firstLoadedCellIndex;
    // 加载当前可见单元格右边的索引
    NSInteger                   _lastLoadedCellIndex;
    // 可重用单元格控件的集合
    NSMutableSet                *_recycledCells;
    // 当前可见单元格集合
    NSMutableSet                *_visibleCells;
    
    // 是否正在旋转
    BOOL                        _isRotationing;
    // 页面容器是否正在滑动
    BOOL                        _scrollViewIsMoving;
    // 回收站是否可用，是否将不用的页控件保存到_recycledCells集合中
    BOOL                        _recyclingEnabled;
}

@property(nonatomic, assign) IBOutlet id<LandscapeTableViewDataSource>    dataSource;
@property(nonatomic, assign) IBOutlet id<LandscapeTableViewDelegate>      delegate;

@property(nonatomic, assign) CGFloat    gapBetweenCells;
@property(nonatomic, assign) NSInteger  cellsToPreload;
@property(nonatomic, assign) NSInteger  cellCount;
@property(nonatomic, assign) NSInteger  currentCellIndex;

// 重新加载数据
- (void)reloadData;
// 由索引获得单元格控件，如果该单元格还没有加载将返回nil
- (LandscapeCell *)cellForIndex:(NSUInteger)index;
// 返回可以重用的单元格控件,如果没有可重用的，返回nil
- (LandscapeCell *)dequeueReusableCell;

@end


@protocol LandscapeTableViewDataSource
@required
- (NSInteger)numberOfCellsInTableView:(LandscapeTableView *)tableView;
- (LandscapeCell *)cellInTableView:(LandscapeTableView *)tableView atIndex:(NSInteger)index;

@end


@protocol LandscapeTableViewDelegate
@optional
- (void)tableView:(LandscapeTableView *)tableView didChangeAtIndex:(NSInteger)index;
- (void)tableView:(LandscapeTableView *)tableView didSelectCellAtIndex:(NSInteger)index;

// a good place to start and stop background processing
- (void)tableViewWillBeginMoving:(LandscapeTableView *)tableView;
- (void)tableViewDidEndMoving:(LandscapeTableView *)tableView;

@end
