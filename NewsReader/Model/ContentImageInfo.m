//
//  ContentImageInfo.m
//  NewsReader
//
//  Created by tangthis on 15/10/26.
//  Copyright (c) 2015年 tangtech. All rights reserved.
//

#import "ContentImageInfo.h"

@implementation ContentImageInfo

+ (instancetype)infoWithDict:(NSDictionary *)dict
{
    ContentImageInfo *info = [[ContentImageInfo alloc] init];
    
    info.ref = [dict objectForKey:@"ref"];
    info.pixel = [dict objectForKey:@"pixel"];
    info.alt = [dict objectForKey:@"alt"];
    info.src = [dict objectForKey:@"src"];
    
    return info;
}

@end
