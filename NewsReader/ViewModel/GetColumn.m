//
//  GetColumn.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "GetColumn.h"
#import "ColumnInfo.h"
@implementation GetColumn
-(void) parseSuccess:(NSDictionary *)dict jsonString:(NSString *)jsonString
{
    NSArray *infos = [ColumnInfo arrayFromDict:dict];
    [_delegate opSuccess:infos];
}
@end
