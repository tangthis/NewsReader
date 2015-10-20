//
//  ColumnBarWidget.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "ColumnBarWidget.h"
#import "GetColumn.h"
#import "ColumnInfo.h"
@implementation ColumnBarWidget

- (void)viewDidLoad
{
    _btnHelper = [[ButtonHelper alloc] init];
    self.listData = [NSMutableArray array];
    
    [super viewDidLoad];
}

- (BOOL)isReloadLocalData
{
    return [super isReloadLocalData];
}

- (void)requestServer
{
    [self requestServerOp];
}

- (void)requestServerOp
{
    NSDictionary *dictInfo = @{@"url":ColumnURL,
                               @"body":@"1"
                               };
    
    _operation = [[GetColumn alloc] initWithDelegate:self opInfo:dictInfo];
    [_operation executeOp];
}

- (void)opSuccess:(NSMutableArray *)data
{
    [super opSuccess:data];
    self.listData = data;
    [self updateUI];
}

- (void)updateUI
{
    [self addColumnBar];
    self.pageIndex = 0;
}


- (void)addColumnBar
{
    // 先删除再添加
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger index = 0;
    CGFloat origin_x = 0;
    CGFloat insets = 18.0f;
    UIEdgeInsets buttonInsets = UIEdgeInsetsMake(0.0f, insets, 0.0f, insets);
    CGSize titleSize = CGSizeZero;
    UIButton *button = nil;
    ColumnInfo *info = nil;
    
    _scrollView.contentInset = buttonInsets;
    
    for(index=0; index<self.listData.count; index++) {
        
        info = [self.listData objectAtIndex:index];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index+1;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:info.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        titleSize = [info.name sizeWithFont:button.titleLabel.font];
        button.frame = CGRectMake(origin_x, 0.0f, titleSize.width+20.0f, 36);
        origin_x += titleSize.width + 3.0f + 20.0f;
        
        [_scrollView addSubview:button];
    }
    
    _scrollView.contentSize = CGSizeMake(origin_x, 36);
}

- (void)buttonClicked:(UIButton *)sender
{
    _pageIndex = sender.tag -1;
    
    [self setColumnTabCenter:sender.frame];
    [_btnHelper setButton:sender
              normalColor:[UIColor blackColor]
            selectedColor:[UIColor redColor]];
    
    [self.delegate didSelect:_pageIndex];
}

- (void)didSelect:(NSInteger)pageIndex
{
    
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
    
    UIButton *sender = ((UIButton *)[_scrollView.subviews objectAtIndex:pageIndex]);
    [self buttonClicked:sender];
}

- (void)setColumnTabCenter:(CGRect)frame {
    
    CGFloat xOffer = frame.origin.x - _scrollView.contentOffset.x - 320/2;
    xOffer = _scrollView.contentOffset.x+xOffer+frame.size.width/2;
    
    if (xOffer < 18)
        xOffer = -18;
    else if (xOffer + 320 > _scrollView.contentSize.width)
        xOffer = _scrollView.contentSize.width - 320+18;
    
    if (xOffer <= 0)
        xOffer = -18;
    
    [_scrollView setContentOffset:CGPointMake(xOffer, 0) animated:YES];
}

@end
