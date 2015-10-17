//
//  AdvertPage.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BasePage.h"

@interface AdvertPage : BasePage{
    IBOutlet UIImageView *_imageView;
}

+(BOOL)canShowAdvertPage;

+(void)showAdvertPage;

@end
