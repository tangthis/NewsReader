//
//  BaseOperation.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BaseOperationDelegate;
@interface BaseOperation : NSObject{//声明变量，不能通过点语法设置和获取变量
    id<BaseOperationDelegate> _delegate;
    NSURLConnection *_connection;
    NSMutableData *_receiveData;//NSMutableData可变的字节操作类
    NSInteger _statusCode;
    long long _totalLength;//双长整型
    //默认是@protected
@public NSDictionary *_opInfo;
}

-(id)initWithDelegate:(id<BaseOperationDelegate>) delegate opInfo:(NSDictionary *) opInfo;
-(NSMutableURLRequest *) urlRequest;
- (void)executeOp;
- (void)cancelOp;
- (void)parseData:(id)data;
- (void)parseSuccess:(NSDictionary *)dict jsonString:(NSString *)jsonString;
- (void)parseFail:(id)dict;
- (void)parseProgress:(long long)receivedLength;
- (NSTimeInterval)timeoutInterval;

@end


@protocol BaseOperationDelegate <NSObject>

-(void)opSuccess:(id)data;
-(void)opFail:(NSString *) errorMsg;

@optional
- (void)opSuccessEx:(id)data opinfo:(NSDictionary *)dictInfo;
- (void)opFailEx:(NSString *)errorMessage opinfo:(NSDictionary *)dictInfo;
- (void)opSuccessMatch:(id)data;
- (void)opUploadSuccess;

@end
