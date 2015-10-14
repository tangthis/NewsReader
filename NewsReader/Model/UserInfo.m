//
//  UserInfo.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+(instancetype) infoWithDict:(NSDictionary *)dict
{
    UserInfo *info = [[UserInfo alloc] init];
    info.ID = [dict objectForKey:@"id"];
    info.name = [dict objectForKey:@"name"];
    info.token = [dict objectForKey:@"token"];
    return info;
}
@end
