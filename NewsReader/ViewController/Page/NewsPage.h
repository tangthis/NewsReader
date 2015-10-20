//
//  NewsPage.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BasePage.h"
#import "ColumnBarWidget.h"
@interface NewsPage : BasePage{
    
    IBOutlet UIView *_backBarView;
    ColumnBarWidget *_barWidget;
}

@end
