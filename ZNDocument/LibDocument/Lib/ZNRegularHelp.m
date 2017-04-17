//
//  ZNRegularHelp.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/17.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNRegularHelp.h"

@implementation ZNRegularHelp


+ (UIViewController *)getCurrentShowViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabbar = (UITabBarController*)result;
        result = tabbar.selectedViewController;
    }
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigation = (UINavigationController*)result;
        result = navigation.visibleViewController;
    }
    return result;
}


@end
