//
//  AdvertInfo.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "AdvertInfo.h"

@implementation AdvertInfo

+(instancetype) infoWithDict:(NSDictionary *)dict
{
    AdvertInfo *info = [[AdvertInfo alloc] init];
    info.ID = [dict objectForKey:@"id"];
    info.name = [dict objectForKey:@"name"];
    info.imageUrl = [dict objectForKey:@"imageurl"];
    info.linkUrl = [dict objectForKey:@"linkurl"];
    return info;
}

@end
