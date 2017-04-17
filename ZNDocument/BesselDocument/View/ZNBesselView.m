//
//  ZNBesselView.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/15.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNBesselView.h"

@implementation ZNBesselView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect { // 0.3的比例
    // Drawing code
    
    [super drawRect:rect];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(0, 5)];
    
    [bezierPath addLineToPoint:CGPointMake(0.7 * rect.size.width - 10, 5)];
    
    [bezierPath addLineToPoint:CGPointMake(0.7 * rect.size.width - 5, 0)];
    
    [bezierPath addLineToPoint:CGPointMake(0.7 * rect.size.width, 5)];
    
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, 5)];
    
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    
    [bezierPath addLineToPoint:CGPointMake(0, rect.size.height)];
    [bezierPath addLineToPoint:CGPointMake(0, 5)];
    [bezierPath closePath];
    
    CGContextAddPath(currentContext, bezierPath.CGPath);
    [MyColor(242, 242, 242) setFill];
    CGContextDrawPath(currentContext, kCGPathFill);
    
}







@end
