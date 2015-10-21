//
//  NewsPage.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BasePage.h"
#import "ColumnBarWidget.h"
#import "LandscapeTableView.h"
@interface NewsPage : BasePage{
    
    IBOutlet UIView *_backBarView;
    ColumnBarWidget *_barWidget;
    IBOutlet LandscapeTableView   *_tableView;
}

@end
