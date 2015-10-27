//
//  WebViewController.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/27.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "NavViewController.h"

@interface WebViewController : NavViewController{
    IBOutlet UIWebView  *_webView;
}

@property(nonatomic, strong) NSString   *urlString;

- (void)loadHtml;

@end
