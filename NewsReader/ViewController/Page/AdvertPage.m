//
//  AdvertPage.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "AdvertPage.h"
#import "AppSetting.h"
#import "Date.h"
#import "AppDelegate.h"
#import "GetImage.h"

@implementation AdvertPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

+(BOOL)canShowAdvertPage
{
    NSString *dateString = [AppSetting getValue:AdvertKey];
    NSDate *date = [Date dateFromStringYMDHMS:dateString];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    //一小时之内不再显示启动图
    return interval < AdvertCheckTime ? NO : YES;
}

+(void)showAdvertPage
{
    //设置广告启动时间
    [AppSetting setValue:[Date stringFromDateYMDHMS:[NSDate date]] forKey:AdvertKey];
    AdvertPage *controller = [[AdvertPage alloc] init];
    UIWindow *window = [AppDelegate appDeg].window;
    if (window.rootViewController != nil) {
        CGRect frame = window.rootViewController.view.bounds;
        controller.view.frame = frame;
        [window.rootViewController.view addSubview:controller.view];
    } else {
        window.rootViewController = controller;
        [window makeKeyAndVisible];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self getAdvertImage];
}

- (BOOL)checkLanchExist
{
    NSString *fileName = [Date stringFromDateYMD:[NSDate date]];
    NSString *filePath = [Global getCacheImage:fileName];
    
    if ([FileUtility isFileExist:filePath]) {
        _imageView.image = [UIImage imageWithContentsOfFile:filePath];
        [self delayHideAdvert];
        return YES;
    }
    
    return NO;
}
- (void)getAdvertImage
{
    // 本地已经存在，取本地图片
    if ([self checkLanchExist]) {
        return;
    }
    
    [self getAdvertOp];
}

- (void)getAdvertOp
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSString *url = [NSString stringWithFormat:AdvertURL, (long)size.width, (long)size.height];
    NSDictionary *dictInfo = @{@"url":url};
    
    _operation = [[BaseOperation alloc] initWithDelegate:self opInfo:dictInfo];
    [_operation executeOp];
}

- (void)delayHideAdvert
{
    [self performSelector:@selector(hideLanch) withObject:nil afterDelay:AdvertDelayTime];
}

- (void)hideLanch
{
    if (self.view.superview != [AppDelegate appDeg].window) {
        [self.view removeFromSuperview];
    }
    else
        [[AppDelegate appDeg] showHomePage];
}

- (void)getLaunchImageOp:(NSString *)url
{
    NSDictionary *dictInfo = @{@"url":url};
    
    _operation = [[GetImage alloc] initWithDelegate:self opInfo:dictInfo];
    [_operation executeOp];
}

#pragma mark - BaseOperationDelegate methods

- (void)opSuccess:(NSDictionary *)dict
{
    NSDictionary *dictData = [dict objectForKey:NetData];
    NSString *url = [dictData objectForKey:@"imageurl"];
    
    [self getLaunchImageOp:url];
}

- (void)opSuccessEx:(id)data opinfo:(NSDictionary *)dictInfo
{
    [self setLaucnImage:data];
    [self delayHideAdvert];
}

- (void)setLaucnImage:(NSData *)data
{
    NSString *fileName = [Date stringFromDateYMD:[NSDate date]];
    UIImage *image = [UIImage imageWithData:data];
    
    if (image!=nil) {
        _imageView.image = image;
        [data writeToFile:[Global getCacheImage:fileName] atomically:YES];
    }
}

@end
