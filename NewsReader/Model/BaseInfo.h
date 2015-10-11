//
//  BaseInfo.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfo : NSObject
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *name;
/// 初始化方法
-(instancetype) initWithDict:(NSDictionary *) dict;
/// 初始化方法
+(instancetype) infoWithDict:(NSDictionary *) dict;
/// 字典转NSArray
+(NSArray *) arrayFromDict:(NSDictionary *) dict;
/// 将数组转成对象数组
+(NSArray *) arrayFromArray:(NSArray *) array;

@end
