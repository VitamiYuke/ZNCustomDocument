//
//  UIBarButtonItem+Extension.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)




/**
 消除间距
 */
+ (UIBarButtonItem *)itemWithSpacer{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;// width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
    return negativeSpacer;
}

/**
 自定义图片导航拦
 */
+ (UIBarButtonItem *)itemWithNormalImage:(UIImage *)normalImage HighlightedImage:(UIImage *)high_lighted_img target:(id)target action:(SEL)action targetSize:(CGSize)targetSize isArcProcessing:(BOOL)isProcessing{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:high_lighted_img forState:UIControlStateHighlighted];
    // 设置尺寸
    if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
        btn.size = btn.currentBackgroundImage.size;
    }else{
        btn.size = targetSize;
        if (isProcessing) {
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:MIN(targetSize.width, targetSize.height)/2];
        }
    }
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


@end
