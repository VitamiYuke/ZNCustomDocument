//
//  UIImage+ScaleToSize.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/9.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "UIImage+ScaleToSize.h"

@implementation UIImage (ScaleToSize)

-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size
{
    //size为CGSize类型，即你所需要的图片尺寸
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
