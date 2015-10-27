//
//  BaseController.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "BaseController.h"
#import "ActivityIndicator.h"
@implementation BaseController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationLeft:@"NavigationBell.png" sel:nil];
    [self setNavigationRight:@"NavigationSquare.png"];
    //[self setNavigationTitleImage:@"NavBarIcon.png"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBarImage];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setStatusBarStyle:UIStatusBarStyleLightContent];

}

- (Activity *)showActivityInView:(UIView *)view
{
    Activity *activity = [[ActivityIndicator alloc] initWithView:view];
    CGRect frame = view.bounds;
    
    activity.frame = frame;
    [view addSubview:activity];
    activity.labelText = @"";
    
    return activity;
}

- (void)showIndicator:(NSString *)tipMessage
             autoHide:(BOOL)hide
           afterDelay:(BOOL)delay
{
    if (_activity == nil) {
        _activity = [self showActivityInView:self.view];
    }
    
    if (tipMessage != nil) {
        _activity.labelText = tipMessage;
        [_activity show:NO];
    }
    
    if (hide && _activity.alpha>=1.0) {
        if (delay)
            [_activity hide:YES afterDelay:AnimationSecond];
        else
            [_activity hide:YES];
    }
}

- (void)hideIndicator
{
    [_activity hide:YES];
}

- (void)setNavBarImage
{
    UIImage *image = [UIImage imageNamed:[Global isSystemLowIOS7]?@"NavigationBar44.png":@"NavigationBar64.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSDictionary *attribute = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                };
    
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
}

- (UIButton *)customButton:(NSString *)imageName
                  selector:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)setNavigationTitleImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    self.navigationItem.titleView = imageView;
}

- (void)setNavigationLeft:(NSString *)imageName sel:(SEL)sel
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self customButton:imageName selector:sel]];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setNavigationRight:(NSString *)imageName
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self customButton:imageName selector:@selector(doRight:)]];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)style
{
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

- (void)opSuccess:(id)data
{
    [self hideIndicator];
}

- (IBAction)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
