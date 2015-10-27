//
//  DetailPage.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "WebViewController.h"
#import "NewsInfo.h"

@interface DetailPage : WebViewController

@property(nonatomic, strong) NewsInfo   *newsInfo;

@end
