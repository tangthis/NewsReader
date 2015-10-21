//
//  NewsLandscapeCell.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/21.
//  Copyright (c) 2015年 tangtech. All rights reserved.
//

#import "NewsLandscapeCell.h"
#import "ColumnInfo.h"
@implementation NewsLandscapeCell

- (void)setCellData:(ColumnInfo *)info
{
    [super setCellData:info];
    
    if (_widget == nil) {
        _widget = [[NewsWidget alloc] init];
        _widget.columnInfo = info;
        _widget.owner = self.owner;
        _widget.view.frame = self.bounds;
        
        [self addSubview:_widget.view];
    }
    else {
        _widget.columnInfo = info;
        [_widget reloadData];
    }
}

@end
