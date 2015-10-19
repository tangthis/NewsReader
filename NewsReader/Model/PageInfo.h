//
//  PageInfo.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/19.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BaseInfo.h"

@interface PageInfo : BaseInfo
@property(nonatomic, strong) NSString    *image;
@property(nonatomic, strong) NSString    *selectImage;
@property(nonatomic, assign) BOOL        unLoad;

+ (NSArray *)pageControllers;
@end
