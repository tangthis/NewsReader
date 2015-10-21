//
//  LandscapeCell.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/21.
//  Copyright (c) 2015年 tangtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInfo.h"

@interface LandscapeCell : UIView 

@property(nonatomic, strong) BaseInfo   *cellInfo;
@property(nonatomic, assign) id         owner;

- (void)setCellData:(BaseInfo *)info;

@end
