//
//  NewsWidget.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "TableWidget.h"
#import "ColumnInfo.h"
@interface NewsWidget : TableWidget{
    BOOL        _hasNextPage;
    NSInteger   _pageIndex;
}

@property(nonatomic, strong) ColumnInfo   *columnInfo;

@end
