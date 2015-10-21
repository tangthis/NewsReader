//
//  BaseCell.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInfo.h"

@interface BaseCell : UITableViewCell{
    IBOutlet UILabel        *_titleLabel;
}

@property(nonatomic, strong) BaseInfo   *cellInfo;

- (void)initCell;
- (void)setCellData:(BaseInfo *)info;

@end
