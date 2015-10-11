//
//  JsonUtility.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "JsonUtility.h"
#import "JsonWriter.h"
#import "JsonParser.h"

@implementation JsonUtility

+ (id)jsonValueFromString:(NSString *)jsonString
{
    JsonParser *jsonParser = [JsonParser new];
    id repr = [jsonParser objectWithString:jsonString];
    
    if (!repr) {
        BASE_INFO_FUN(@"不是合法的JSON格式");
        BASE_INFO_FUN(jsonString);
    }
    
    [jsonParser release];
    return repr;
}

+ (NSString *)jsonValueFromObject:(id)object
{
    JsonWriter *jsonWriter = [JsonWriter new]; 
    NSString *json = [jsonWriter stringWithObject:object];
    
    if (!json) {
        BASE_INFO_FUN(@"对象不能转换为Json格式字符串");
        BASE_INFO_FUN([jsonWriter errorTrace]);
    }
    
    [jsonWriter release];
    return json;
}

@end
