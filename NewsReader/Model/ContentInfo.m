//
//  ContentInfo.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/27.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "ContentInfo.h"
#import "ContentImageInfo.h"
@implementation ContentInfo

+ (instancetype)infoWithDict:(NSDictionary *)dict
{
    ContentInfo *info = [[ContentInfo alloc] init];
    
    info.title = [dict objectForKey:@"title"];
    info.source = [dict objectForKey:@"source"];
    info.ptime = [dict objectForKey:@"ptime"];
    info.digest = [dict objectForKey:@"digest"];
    info.body = [dict objectForKey:@"body"];
    info.ec = [dict objectForKey:@"ec"];
    info.sourceurl = [dict objectForKey:@"source_url"];
    
    NSArray *images =[dict objectForKey:@"img"];
    info.images = [ContentImageInfo arrayFromArray:images];
    
    return info;
}

@end
