//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    if (view == nil) {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",icon]];
//    UIImage* image = [UIImage imageNamed:@"Checkmark"];
    hud.customView = [[UIImageView alloc] initWithImage:image];
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.3];
    
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"Error_w" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"Checkmark_w" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    if (view == nil) {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    MBBackgroundView* backView = [[MBBackgroundView alloc] initWithFrame:view.bounds];
//    backView.style = MBProgressHUDBackgroundStyleBlur;
//    backView.color = MyColorWithAlpha(0, 0, 0, 0.5);
//    hud.dimBackground  = YES;
//    hud.backgroundColor = MyColorWithAlpha(0, 0, 0, 0.3);
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    if (view == nil) {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
