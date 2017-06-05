//
//  ZNRegularHelp.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/17.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNRegularHelp.h"
#import "ZNDrawerMainController.h"

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
    
    
    if ([result isKindOfClass:[ZNDrawerMainController class]]) {
        ZNDrawerMainController* drawerController = (ZNDrawerMainController*)result;
        result = drawerController.mainViewController;
    }
    
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


+ (UIViewController *)getViewControllerWithOriginView:(UIView *)originView{
    if (originView) {
        for (UIView* next = [originView superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                return (UIViewController*)nextResponder;
            }
        }
    }
    return nil;
}



@end
