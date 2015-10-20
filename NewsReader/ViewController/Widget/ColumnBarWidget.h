//
//  ColumnBarWidget.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BaseWidget.h"
#import "ButtonHelper.h"

@protocol ColumnBarDelegate;
@interface ColumnBarWidget : BaseWidget {
    IBOutlet UIScrollView   *_scrollView;
    ButtonHelper          *_btnHelper;
}

@property(nonatomic, assign) NSInteger      pageIndex;
@property(nonatomic, assign) id<ColumnBarDelegate> delegate;

@end


@protocol ColumnBarDelegate <NSObject>

- (void)didSelect:(NSInteger)pageIndex;

@end
