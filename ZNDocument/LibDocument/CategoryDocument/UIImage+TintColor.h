//
//  UIImage+TintColor.h
//  ZNDocument
//
//  Created by 张楠 on 16/11/9.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TintColor)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

@end
