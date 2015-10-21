//
//  NewsCell.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "NewsCell.h"
#import "NewsInfo.h"
#import "Download.h"

@implementation NewsCell

- (void)initCell
{
    [super initCell];
    RegisterNotify(NofifyNewsIcon, @selector(downloadIcon:));
}

- (void)dealloc
{
    RemoveNofify;
}

- (void)setCellData:(NewsInfo *)info
{
    [super setCellData:info];
    
    _descLabel.numberOfLines = 2;
    _descLabel.text = info.desc;
    
    [[Download download] setNewsIcon:info imageView:_imageView];
}

- (void)downloadIcon:(NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    NewsInfo *info = [dict objectForKey:@"info"];
    
    if ([info.ID isEqualToString:self.cellInfo.ID]) {
        UIImage *image = [dict objectForKey:@"data"];
        _imageView.image = image;
    }
}

@end
