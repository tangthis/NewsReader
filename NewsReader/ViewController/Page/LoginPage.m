//
//  登录
//  LoginPage.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "LoginPage.h"
#import "Login.h"
#import "UserInfo.h"

@implementation LoginPage

-(void)viewDidLoad
{
    [super viewDidLoad];
}
- (IBAction)doLoginEvent:(id)sender {
    BASE_INFO_FUN(@"login");
    NSString *body = [NSString stringWithFormat:@"username=%@&password=%@",_userName.text,
                      _password.text];
    
    NSDictionary *opInfo = @{
                           @"url":LoginURL,
                           @"body":body
                           };
    
    _operation = [[Login alloc] initWithDelegate:self opInfo:opInfo];
    [_operation executeOp];
    
}

-(void)opSuccess:(UserInfo *)data
{
    BASE_INFO_FUN(data.name);
}
@end
