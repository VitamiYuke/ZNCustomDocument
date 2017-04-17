//
//  UIBarButtonItem+Extension.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem*)itemWithSpacer;//用于消除左右边距

//获取一个自定义图片的Item
+ (UIBarButtonItem *)itemWithNormalImage:(UIImage *)normalImage HighlightedImage:(UIImage *)high_lighted_img target:(id)target action:(SEL)action;



@end
