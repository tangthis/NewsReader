//
//  GetAdvert.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "GetAdvert.h"
#import "AdvertInfo.h"

@implementation GetAdvert

-(void) parseSuccess:(NSDictionary *)dict jsonString:(NSString *)jsonString
{
    NSDictionary *dictData = [dict objectForKey:NetData];
    AdvertInfo *advert = [AdvertInfo infoWithDict:dictData];
    
    [_delegate opSuccess:advert];
}
@end
