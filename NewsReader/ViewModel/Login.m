//
//  Login.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "Login.h"
#import "UserInfo.h"

@implementation Login

-(void) parseSuccess:(NSDictionary *)dict jsonString:(NSString *)jsonString
{
    NSDictionary *dictData = [dict objectForKey:NetData];
    UserInfo *info = [UserInfo infoWithDict:dictData];
    
    [_delegate opSuccess:info];
}
@end
