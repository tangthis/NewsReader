//
//  PageInfo.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/19.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "PageInfo.h"

@implementation PageInfo

-(instancetype) initWithDict:(NSDictionary *)dict
{
    PageInfo *info = [[PageInfo alloc] init];
    
    info.ID = [dict objectForKey:@"ClassName"];
    info.name = [dict objectForKey:@"Title"];
    info.image = [dict objectForKey:@"Image"];
    info.selectImage = [dict objectForKey:@"SelectImage"];
    info.unLoad = [[dict objectForKey:@"UnLoad"] boolValue];
    
    return info;
}

+(NSArray *)pages
{
    NSString *configFile = [[NSBundle mainBundle] pathForResource:@"TabBarPages" ofType:@"plist"];
    NSArray *configs = [NSArray arrayWithContentsOfFile:configFile];
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    
    if(configs.count <=0){
        BASE_INFO_FUN(@"TabBarConfig未设置");
    }
    for (NSDictionary *dict in configs) {
        [pages addObject:[PageInfo infoWithDict:dict]];
    }
    return pages;
}

+ (NSArray *)pageControllers
{
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    NSArray *pages = [self pages];
    UINavigationController *nav = nil;
    UIViewController *pageController = nil;
    
    for (PageInfo *pageInfo in pages) {
        if(pageInfo.unLoad){
            if(pageInfo.unLoad){
                continue;
            }
        }
        pageController = [[NSClassFromString(pageInfo.ID) alloc] init];
        nav = [[UINavigationController alloc]initWithRootViewController:pageController];
        pageController.title = pageInfo.name;
        pageController.tabBarItem.image = [UIImage imageNamed:pageInfo.image];
        [controllers addObject:nav];
    }
    return controllers;
}

@end
