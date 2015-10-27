//
//  GetContent.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/27.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "GetContent.h"
#import "ContentInfo.h"

@implementation GetContent

- (void)parseData:(NSData *)data
{
    if (data.length <= 0) { //返回的长度为0，认为成功
        [self parseSuccess:nil jsonString:nil];
        return;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [JsonUtility jsonValueFromString:jsonString];
    NSString *articleID = [_opInfo objectForKey:@"aid"];
    
    NSDictionary *dictResult = [dict objectForKey:articleID];
    if (dictResult != nil) {
        [self parseSuccess:dictResult jsonString:jsonString ];
    }
    else {
        [self parseFail:jsonString];
    }
    
    _receiveData = nil;
}

- (void)parseSuccess:(NSDictionary *)dict jsonString:jsonString
{
    ContentInfo *info = [ContentInfo infoWithDict:dict];
    
    [_delegate opSuccess:info];
}

@end
