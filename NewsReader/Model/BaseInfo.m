//
//  BaseInfo.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BaseInfo.h"

@implementation BaseInfo

-(instancetype) initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.ID = [dict objectForKey:@"id"];
        self.name = [dict objectForKey:@"name"];
        //[self setValuesForKeysWithDictionary:dict];简洁写法
    }
    return self;
}

+(instancetype) infoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *) arrayFromDict:(NSDictionary *) dict
{
    NSArray *array = [dict objectForKey:NetData];
    return [self arrayFromArray:array];
}

+(NSArray *) arrayFromArray:(NSArray *) array
{
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        [infos addObject:[self infoWithDict:dict]];
    }
    
    if(infos.count == 0){
        return nil;
    }
    
    return infos;
}


@end
