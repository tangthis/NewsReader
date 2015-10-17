//
//  String.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/17.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface String : NSObject

/*
 * 对字符串进行URL编码转换
 */
+ (NSString *)urlEncodeCovertString:(NSString *)source;

/*
 * 将字符串转换为
 */
+ (void)convertString:(NSString *)source toHexBytes:(unsigned char *)hexBuffer;

/*
 * 将当前时间转换为时间戳字符串：since 1970，如@"1369118167"
 */
+ (NSString *)intervalFromNowTime;

/*
 * 删除中文输入法下的空格
 */
+ (NSString *)deleteChinesSpace:(NSString *)sourceText;

/*
 * 转化为字符串类型
 */
+(NSString *)stringFromObject:(id)obj;

/*
 * 将URL的查询字符串放入字典中如：http://..?userName=name&password=password
 * 将查询字符串userName=name&password=password 放入字典
 */
+ (NSDictionary *)parseURLQueryString:(NSString *)queryString;

/*
 * 将unicode码转成普通文字.(\u6790)
 */
+ (NSString *)replaceUnicode:(NSString *)unicodeString;

@end
