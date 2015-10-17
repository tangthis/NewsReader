//
//  AppSetting.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/17.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSetting : NSObject

+ (NSString *)getValue:(NSString *)key;
+ (void)setValue:(id)value forKey:(NSString *)key;

@end
