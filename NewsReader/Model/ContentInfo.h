//
//  ContentInfo.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/27.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BaseInfo.h"

@interface ContentInfo : BaseInfo
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *source;
@property(nonatomic, strong) NSString *ptime;
@property(nonatomic, strong) NSString *digest;
@property(nonatomic, strong) NSString *body;
@property(nonatomic, strong) NSString *ec;
@property(nonatomic, strong) NSString *sourceurl;
@property(nonatomic, strong) NSArray  *images;
@end
