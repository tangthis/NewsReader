//
//  GetNews.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "GetNews.h"
#import "NewsInfo.h"
@implementation GetNews

-(void) parseSuccess:(NSDictionary *)dict jsonString:(NSString *)jsonString
{
    NSArray *infos = [NewsInfo arrayFromDict:dict];
    [_delegate opSuccess:infos];
}
@end
