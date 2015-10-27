//
//  WebViewController.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/27.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadHtml];
}

- (void)dealloc
{
    [_webView stopLoading];
    _webView.delegate = nil;
}

- (void)loadHtml
{
    [self showIndicator:LoadingTip autoHide:NO afterDelay:NO];
    
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [_webView loadRequest:request];
}


#pragma mark - UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideIndicator];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
