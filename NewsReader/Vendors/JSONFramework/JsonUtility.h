//
//  JsonUtility.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtility : NSObject

+ (id)jsonValueFromString:(NSString *)jsonString;
+ (NSString *)jsonValueFromObject:(id)object;

@end
