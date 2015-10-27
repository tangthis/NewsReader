//
//  DetailPage.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "DetailPage.h"
#import "ContentInfo.h"
#import "GetContent.h"
#import "ContentImageInfo.h"

@implementation DetailPage

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.barBackgroudImage = @"NavBarWhite";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationLeft:@"NavigationBackBlack.png"
                        sel:@selector(doBack:)];
    [self setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)loadHtml
{
    [self showIndicator:LoadingTip autoHide:NO afterDelay:NO];
    [self executeContentOp];
}

- (void)executeContentOp
{
    NSString *url = [NSString stringWithFormat:DetailURLFmt, _newsInfo.ID];
    NSDictionary *dictInfo = @{@"url":url,
                               @"aid":_newsInfo.ID
                               };
    
    _operation = [[GetContent alloc] initWithDelegate:self opInfo:dictInfo];
    [_operation executeOp];
}

- (void)opSuccess:(ContentInfo *)info
{
    _operation = nil;
    
    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"content_template2" ofType:@"html"];
    NSString *htmlString = [self htmlConvert:info];
    
    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:urlString]];
}

- (NSString *)htmlConvert:(ContentInfo *)info
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"content_template2" ofType:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    html = [html stringByReplacingOccurrencesOfString:HtmlBody withString:info.body];
    html = [html stringByReplacingOccurrencesOfString:HtmlTitle withString:info.title];
    html = [html stringByReplacingOccurrencesOfString:HtmlSource withString:info.source];
    html = [html stringByReplacingOccurrencesOfString:HtmlPTime withString:info.ptime];
    html = [html stringByReplacingOccurrencesOfString:HtmlDigest withString:info.digest];
    html = [html stringByReplacingOccurrencesOfString:HtmlSourceURL withString:info.sourceurl];
    
    if (info.images.count > 0) {
        NSString *img = nil;
        
        for (ContentImageInfo *imageInfo in info.images) {
            img = [NSString stringWithFormat:HtmlImage, imageInfo.src];
            html = [html stringByReplacingOccurrencesOfString:imageInfo.ref withString:img];
        }
    }
    
    return html;
}

- (void)doShare
{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = self.newsInfo.name;
//    message.description = self.newsInfo.desc;
//    
//    NSString *iconFile = [NSString stringWithFormat:NewsIconPrex, self.newsInfo.ID];
//    
//    iconFile = [FxGlobal getCacheImage:iconFile];
//    [message setThumbImage:[UIImage imageWithContentsOfFile:iconFile]];
//    
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = self.newsInfo.contentUrl;
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.message = message;
//    req.bText = NO;
//    req.scene = WXSceneTimeline;
//    
//    if (![WXApi sendReq:req]) {
//        [self showIndicator:@"未安装微信" autoHide:YES afterDelay:YES];
//    }
}

@end
