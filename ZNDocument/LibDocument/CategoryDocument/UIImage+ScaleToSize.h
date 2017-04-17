//
//  UIImage+ScaleToSize.h
//  ZNDocument
//
//  Created by 张楠 on 16/11/9.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleToSize)

/**
 重新绘制图片大小
 
 @param image 原始图片
 @param size  需要的大小
 
 @return 返回改变大小后图片
 */
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size;

@end
