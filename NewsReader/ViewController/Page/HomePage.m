//
//  HomePage.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "HomePage.h"
#import "PageInfo.h"
@implementation HomePage

-(id)init
{
    if(self = [super init]){
        [self addTabControllers];
    }
    return self;
}

-(void)addTabControllers
{
    self.tabBar.tintColor = [UIColor redColor];
    self.viewControllers = [PageInfo pageControllers];
    
}
@end
