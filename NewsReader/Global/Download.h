//
//  Download.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/17.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsInfo.h"

@interface Download : NSObject

@property(nonatomic, strong)NSMutableDictionary *dictIcons;

+ (Download *)download;

- (void)cancelDownload;
- (void)setNewsIcon:(NewsInfo *)newsInfo
          imageView:(UIImageView *)imageView;

@end
