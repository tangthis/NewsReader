//
//  BaseCell.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell
- (void)initCell
{
}

- (void)setCellData:(BaseInfo *)info
{
    self.cellInfo = info;
    _titleLabel.text = info.name;
}
@end
