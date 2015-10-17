//
//  Activity.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/17.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Activity : UIView

@property (copy) NSString *labelText;
@property (copy) NSString *detailsLabelText;

- (id)initWithView:(UIView *)view;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end
