//
//  Date.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/17.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Date : NSObject 

/*
 调整日期的小时数：将小于minHour或大于maxHour的时间调整到fitHour
 参数minHour,maxHour,fitHour 必须在0-24之间
 2012-05-15 8:10:10 调整后为：2012-05-15 fitHour:10:10
 2012-05-15 23:20:20 调整后为：2012-05-16 fitHour:20:20 
*/
+ (NSDate *)adjustDateHour:(NSDate *)srcDate 
                   minHour:(NSUInteger)minHour 
                   maxHour:(NSUInteger)maxHour 
                   fitHour:(NSUInteger)fitHour;

/*
 日期-字符串转换函数
 */
//年月日转换：2015-10-30
+ (NSString *)stringFromDateYMD:(NSDate *)date;
+ (NSDate *)dateFromStringYMD:(NSString *)dateString;

//年月日星期时分：2015-10-30 星期四 10:20
+ (NSString *)stringFromDateYMDEHM:(NSDate *)date;
+ (NSDate *)dateFromStringYMDEHM:(NSString *)dateString;

//年月日时分秒：2015-10-30 10:10:10
+ (NSString *)stringFromDateYMDHMS:(NSDate *)date;
+ (NSDate *)dateFromStringYMDHMS:(NSString *)dateString;

//获取年、月、日
+ (NSString *)getYear:(NSDate *)date;
+ (NSString *)getMonth:(NSDate *)date;
+ (NSString *)getDay:(NSDate *)date;

@end
