//
//  LandscapeTableView.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/21.
//  Copyright (c) 2015年 tangtech. All rights reserved.
//

#import "LandscapeTableView.h"

@interface LandscapeTableView (LandscapeTableViewPrivate) <UIScrollViewDelegate>

- (void)configureCells;
- (void)configureCell:(LandscapeCell *)cell forIndex:(NSInteger)index;

- (void)recycleCell:(LandscapeCell *)cell;

- (CGRect)frameForScrollView;
- (CGRect)frameForCellAtIndex:(NSUInteger)index;

- (void)willBeginMoving;
- (void)didEndMoving;

@end


@implementation LandscapeTableView


#pragma mark - Lifecycle methods

- (void)addContentView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:[self frameForScrollView]];
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
}

- (void)internalInit
{
    _visibleCells = [[NSMutableSet alloc] init];
    _recycledCells = [[NSMutableSet alloc] init];
    
    _currentCellIndex = -1;
    _lastCellIndex = 0;
    _gapBetweenCells = 20.0f;
    _cellsToPreload = 1;
    _recyclingEnabled = YES;
    _firstLoadedCellIndex = _lastLoadedCellIndex = -1;
    
    self.clipsToBounds = YES;
    [self addContentView];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self internalInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self internalInit];
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
}

- (void)layoutSubviews
{
    if (_isRotationing)
        return;
    
    CGRect oldFrame = _scrollView.frame;
    CGRect newFrame = [self frameForScrollView];
    if (!CGRectEqualToRect(oldFrame, newFrame)) {
        // Strangely enough, if we do this assignment every time without the above
        // check, bouncing will behave incorrectly.
        _scrollView.frame = newFrame;
    }
    
    if (oldFrame.size.width != 0 && _scrollView.frame.size.width != oldFrame.size.width) {
        // rotation is in progress, don't do any adjustments just yet
    } else if (oldFrame.size.height != _scrollView.frame.size.height) {
        // some other height change (the initial change from 0 to some specific size,
        // or maybe an in-call status bar has appeared or disappeared)
        [self configureCells];
    }
}


#pragma mark - Propertites methods

- (void)setGapBetweenCells:(CGFloat)value
{
    _gapBetweenCells = value;
    
    [self setNeedsLayout];
}

- (void)setPagesToPreload:(NSInteger)value
{
    _cellsToPreload = value;
    
    [self configureCells];
}

- (void)setCurrentCellIndex:(NSInteger)newCellIndex
{
    if (_scrollView.frame.size.width > 0 && fabs(_scrollView.frame.origin.x - (-_gapBetweenCells/2)) < 1e-6) {
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * newCellIndex, 0);
    }
    
    _currentCellIndex = newCellIndex;
    _lastCellIndex = _currentCellIndex;
}

- (NSInteger)firstVisibleCellIndex
{
    CGRect visibleBounds = _scrollView.bounds;
    return MAX(floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds)), 0);
}

- (NSInteger)lastVisibleCellIndex
{
    CGRect visibleBounds = _scrollView.bounds;
    return MIN(floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds)), _cellCount - 1);
}


#pragma mark - Utility methods

- (void)reloadData
{
    _cellCount = [_dataSource numberOfCellsInTableView:self];
    
    // recycle all cells
    for (LandscapeCell *cell in _visibleCells) {
        
        [self recycleCell:cell];
    }
    
    [_visibleCells removeAllObjects];
    [self configureCells];
}

- (LandscapeCell *)cellForIndex:(NSUInteger)index
{
    for (LandscapeCell *cell in _visibleCells) {
        
        if (cell.tag == index)
            return cell;
    }
    
    return nil;
}

- (LandscapeCell *)dequeueReusableCell
{
    LandscapeCell *result = [_recycledCells anyObject];
    
    if (result) {
        [_recycledCells removeObject:result];
    }
    
    return result;
}


#pragma mark - FZPageViewPrivate methods

- (void)configureCells
{
    if (_scrollView.frame.size.width <= _gapBetweenCells + 1e-6)
        return;  // not our time yet
    if (_cellCount == 0 && _currentCellIndex > 0)
        return;  // still not our time
    // normally layoutSubviews won't even call us, but protect against any other calls too (e.g. if someones does reloadPages)
    if (_isRotationing)
        return;
    
    // to avoid hiccups while scrolling, do not preload invisible pages temporarily
    BOOL quickMode = (_scrollViewIsMoving && _cellsToPreload > 0);
    CGSize contentSize = CGSizeMake(_scrollView.frame.size.width * _cellCount+2, _scrollView.frame.size.height);
    
    if (!CGSizeEqualToSize(_scrollView.contentSize, contentSize)) {
        
        _scrollView.contentSize = contentSize;
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * _currentCellIndex, 0);
    }
    
    CGRect visibleBounds = _scrollView.bounds;
    NSInteger newCellIndex = MIN(MAX(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)), 0), _cellCount - 1);
    
    newCellIndex = MAX(0, MIN(_cellCount, newCellIndex));
    
    // calculate which pages are visible
    NSInteger firstVisibleCell = self.firstVisibleCellIndex;
    NSInteger lastVisibleCell  = self.lastVisibleCellIndex;
    NSInteger firstCell = MAX(0,            MIN(firstVisibleCell, newCellIndex - _cellsToPreload));
    NSInteger lastCell  = MIN(_cellCount-1, MAX(lastVisibleCell,  newCellIndex + _cellsToPreload));
    
    // recycle no longer visible cells
    NSMutableSet *cellsToRemove = [NSMutableSet set];
    for (LandscapeCell *cell in _visibleCells) {
        
        if (cell.tag < firstCell || cell.tag > lastCell) {
            
            [self recycleCell:cell];
            [cellsToRemove addObject:cell];
        }
    }
    [_visibleCells minusSet:cellsToRemove];
    
    // add missing cells
    for (NSInteger index = firstCell; index <= lastCell; index++) {
        
        if ([self cellForIndex:index] == nil) {
            // only preload visible pages in quick mode
            if (quickMode && (index < firstVisibleCell || index > lastVisibleCell))
                continue;
            
            LandscapeCell *cell = [_dataSource cellInTableView:self atIndex:index];
            
            [self configureCell:cell forIndex:index];
            [_scrollView addSubview:cell];
            [_visibleCells addObject:cell];
        }
    }
    
    // update loaded cells info
    BOOL loadedCellsChanged = NO;
    if (quickMode) {
        // Delay the notification until we actually load all the promised pages.
        // Also don't update _firstLoadedPageIndex and _lastLoadedPageIndex, so
        // that the next time we are called with quickMode==NO, we know that a
        // notification is still needed.
        //loadedCellsChanged = NO;
    } else {
        
        loadedCellsChanged = (_firstLoadedCellIndex != firstCell || _lastLoadedCellIndex != lastCell);
        if (loadedCellsChanged) {
            
            _firstLoadedCellIndex = firstCell;
            _lastLoadedCellIndex  = lastCell;
        }
    }
    
    // update current cell index
    BOOL cellIndexChanged = (newCellIndex != _currentCellIndex);
    if (cellIndexChanged) {
        
        _lastCellIndex = _currentCellIndex;
        _currentCellIndex = newCellIndex;
        
        if ([(NSObject *)_delegate respondsToSelector:@selector(tableView:didChangeAtIndex:)])
            [_delegate tableView:self didChangeAtIndex:_currentCellIndex];
    }
}

- (void)configureCell:(LandscapeCell *)cell forIndex:(NSInteger)index
{
    cell.tag = index;
    cell.frame = [self frameForCellAtIndex:index];
    
    [cell setNeedsDisplay];
}

// It's the caller's responsibility to remove this cell from _visiblePages,
// since this method is often called while traversing _visibleCells array.
- (void)recycleCell:(LandscapeCell *)cell
{
    if ([cell respondsToSelector:@selector(prepareForReuse)]) {
        [cell performSelector:@selector(prepareForReuse)];
    }
    
    if (_recyclingEnabled) {
        [_recycledCells addObject:cell];
    }
    
    [cell removeFromSuperview];
}

- (CGRect)frameForScrollView
{
    CGSize size = self.bounds.size;
    
    return CGRectMake(-_gapBetweenCells/2, 0, size.width + _gapBetweenCells, size.height);
}

- (CGRect)frameForCellAtIndex:(NSUInteger)index
{
    CGFloat cellWidthWithGap = _scrollView.frame.size.width;
    CGSize cellSize = self.bounds.size;
    
    return CGRectMake(cellWidthWithGap * index + _gapBetweenCells/2,
                      0, cellSize.width, cellSize.height);
}

- (void)willBeginMoving
{
    if (!_scrollViewIsMoving) {
        
        _scrollViewIsMoving = YES;
        
        if ([(NSObject *)_delegate respondsToSelector:@selector(tableViewWillBeginMoving:)]) {
            
            [_delegate tableViewWillBeginMoving:self];
        }
    }
}

- (void)didEndMoving
{
    if (_scrollViewIsMoving) {
        
        _scrollViewIsMoving = NO;
        if (_cellsToPreload > 0) {
            // we didn't preload invisible cells during scrolling, so now is the time
            [self configureCells];
        }
        
        if ([(NSObject *)_delegate respondsToSelector:@selector(tableViewDidEndMoving:)]) {
            [_delegate tableViewDidEndMoving:self];
        }
        
        if (_lastCellIndex != _currentCellIndex) {
            
            LandscapeCell *cell = [self cellForIndex:_lastCellIndex];
            
            cell.frame = cell.frame;
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        
        if (_isRotationing)
            return;
        
        [self configureCells];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        [self willBeginMoving];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && _scrollView == scrollView) {
        
        [self didEndMoving];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        [self didEndMoving];
    }
}


@end
