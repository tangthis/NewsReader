//
//  String.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/17.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "String.h"

@implementation String

static char TwoCharToHex(char a, char b)
{
    char encoder[3] = {0,0,0};
    
    encoder[0] = a;
    encoder[1] = b;
    
    return (char) strtol(encoder,NULL,16);
}

+ (NSString *)urlEncodeCovertString:(NSString *)source
{
    if (source==nil) {
        return @"";
    }
    
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[source mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    
    BASE_INFO_FUN(result);
    
    return [result autorelease];
}

+ (void)convertString:(NSString *)source toHexBytes:(unsigned char *)hexBuffer
{
    const char * bytes = [source cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char * index = hexBuffer;
    
    while ((*bytes) && (*(bytes +1))) {
        *index = TwoCharToHex(*bytes, *(bytes + 1));
        
        ++index;
        bytes += 2;
    }
    
    *index = 0;
}

+ (NSString *)intervalFromNowTime
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld", (long)interval];
}

+ (NSString *)deleteChinesSpace:(NSString *)sourceText
{
   return [sourceText stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(NSString *)stringFromObject:(id)obj
{
    NSString *ret = nil;
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        ret = [NSString stringWithFormat:@"%ld", [obj longValue]];
    }
    else {
        ret = obj;
    }
    
    return ret;
}

+ (NSDictionary *)parseURLQueryString:(NSString *)queryString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        
        if([keyValue count] == 2) {
            NSString *key = [keyValue objectAtIndex:0];
            NSString *value = [keyValue objectAtIndex:1];
            
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if(key && value)
                [dict setObject:value forKey:key];
        }
    }
    
    return dict;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeString
{
    NSString *tempStr1 = [unicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization
                           propertyListFromData:tempData
                           mutabilityOption:NSPropertyListImmutable
                           format:NULL
                           errorDescription:NULL
                           ];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

@end
