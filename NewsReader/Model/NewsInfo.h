//
//  NewsInfo.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BaseInfo.h"

@interface NewsInfo : BaseInfo
//描述
@property(nonatomic,strong) NSString *desc;
//图片
@property(nonatomic,strong) NSString *iconUrl;
//文章链接
@property(nonatomic,strong) NSString *contentUrl;

@end
