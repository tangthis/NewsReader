//
//  NewsInfo.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "NewsInfo.h"

@implementation NewsInfo

+(instancetype) infoWithDict:(NSDictionary *)dict
{
    NewsInfo *info = [[NewsInfo alloc] init];
    info.ID = [dict objectForKey:@"id"];
    info.name = [dict objectForKey:@"name"];
    info.desc = [dict objectForKey:@"desc"];
    info.iconUrl = [dict objectForKey:@"iconurl"];
    info.contentUrl = [dict objectForKey:@"contenturl"];
    return info;
}


@end
