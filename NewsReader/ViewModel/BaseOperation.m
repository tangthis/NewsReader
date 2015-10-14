//
//  BaseOperation.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BaseOperation.h"

@implementation BaseOperation

-(id)initWithDelegate:(id<BaseOperationDelegate>)delegate opInfo:(NSDictionary *)opInfo
{
    if(self = [super init]){
        _delegate = delegate;
        _opInfo = opInfo;
        _totalLength = 0;
    }
    return self;
}

- (void)cancelOp
{
    if (_connection != nil) {
        BASE_INFO_FUN(@"_connection dealloc cancel");
        [_connection cancel];
    }
    _connection = nil;
}

- (void)dealloc
{
    if (_connection != nil) {
        BASE_INFO_FUN(@"_connection dealloc cancel");
        [_connection cancel];
    }
    _connection = nil;
    _delegate = nil;
}

- (NSTimeInterval)timeoutInterval
{
    return FxRequestTimeout;
}

-(NSMutableURLRequest *)urlRequest
{
    NSString *urlString = [_opInfo objectForKey:@"url"];
    BASE_INFO_FUN(urlString);
    
    id body = [_opInfo objectForKey:@"body"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (body != nil) {
        [request setHTTPMethod:HTTPPOST];
        if ([body isKindOfClass:[NSString class]]) {
            [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            [request setHTTPBody:body];
        }
    }else{
        [request setHTTPMethod:HTTPGET];
    }
    
    return request;
    
}

//使用delegate异步发送请求
- (void)executeOp
{
    _connection = [[NSURLConnection alloc] initWithRequest:[self urlRequest] delegate:self];
}


- (void)parseData:(NSData *)data
{
    if (data.length == 0) {
        [self parseSuccess:nil jsonString:nil];
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [JsonUtility jsonValueFromString:jsonString];
    NSString *result = [dict objectForKey:NetResult];
    if ([result isEqualToString:NetOk]) {
        [self parseSuccess:dict jsonString:jsonString];
    }else{
        [self parseFail:dict];
    }
    _receiveData = nil;
    
}
- (void)parseSuccess:(NSDictionary *)dict jsonString:(NSString *)jsonString
{
    [_delegate opSuccess:dict];
}
- (void)parseFail:(id)dict
{
    if ([dict isKindOfClass:[NSString class]]) {
        [_delegate opFail:(NSString *)dict];
        return;
    }
    if ([[dict objectForKey:NetResult] isEqualToString:NetInvalidateToken]) {
        BASE_ERROR_FUN(NetInvalidateToken);
    }
    [_delegate opFail:[dict objectForKey:NetMessage]];
}
- (void)parseProgress:(long long)receivedLength
{
    
}

#pragma mark NSURLConnectionDelegage methods

// 收到回应
- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)aResponse;
    NSString *statusCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    _statusCode = [statusCode intValue];
    _receiveData = [[NSMutableData alloc] init];
    if (_statusCode == 200 || _statusCode == 206) {
        _totalLength = [response expectedContentLength];
    }
    BASE_INFO_FUN(statusCode);
}
// 接收数据
- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data
{
    BASE_INFO_FUN(([NSString stringWithFormat:@"%lu", (unsigned long)data.length]));
    [_receiveData appendData:data];
    [self parseProgress:_receiveData.length];
}
// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)aConn
{
    BASE_INFO_FUN([[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding]);
    
    // 成功接受：200有数据，204没有数据，206断点续传
    if (_statusCode == 200 || _statusCode == 204 || _statusCode == 206) {
        [self parseData:_receiveData];
    }
    else {
        
        NSString *errorMessage = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
        
        if (errorMessage.length <= 0) {
            errorMessage = [[NSString alloc] initWithFormat:@"ResponseCode:%ld", (long)_statusCode];
        }
        
        [self parseFail:errorMessage];
    }
    
    _connection = nil;
    _receiveData = nil;
}
// 返回错误
- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error
{
    [self parseFail:[error localizedDescription]];
    
    _connection = nil;
    _receiveData = nil;
}

@end
