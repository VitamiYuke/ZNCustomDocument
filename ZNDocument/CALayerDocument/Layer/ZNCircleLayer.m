//
//  ZNCircleLayer.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/17.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//


#import "ZNCircleLayer.h"
#import <UIKit/UIKit.h>

typedef enum MovingPoint {//移动的点
    POINT_B,
    POINT_D,
}MovingPoint;


#define kTheExternalRectangleSize 90 // 外接矩形的大小

@interface ZNCircleLayer ()
/*
 外接矩形
 */
@property(nonatomic, assign)CGRect outsideRect;
/*
 实时记录滑动方向
 */
@property(nonatomic, assign)MovingPoint movePoint;
/*
 记录上次的progress 方便得出滑动方向
 */
@property(nonatomic, assign)CGFloat lastProgress;



@end


@implementation ZNCircleLayer



- (instancetype)init
{
    if ([super init]) {
        self.progress = 0.5;
    }
    return self;
}



//绘图
- (void)drawInContext:(CGContextRef)ctx
{
    //A-C1、B-C2... 的距离，当设置为正方形边长的1/3.6倍时，画出来的圆弧完美贴合圆形
    /*
     “NOTE: 由于这是我的电子书，所以我会分享自己平时常用的技巧。其中之一就是，我非常善于动笔画草图。 我希望你在看我这本书的同时也能准备好笔纸，勤画草图。每当你的思绪一团糟的时候，请拿出笔在纸上分析一下，立刻就会豁然开朗。这也是我在做动画的过程中额外发现的一些东西。
     
     “ offset 指的是 A-C1,B-C2... 的距离，当该值设置为正方形边长的 1/3.6 倍时，画出来的圆弧近似贴合 1/4 圆。为什么是 3.6 ？这里 有一篇文章。文章里三阶贝塞尔曲线拟合 1/4 圆的时候最佳参数 h=0.552,  表示的意义是：当正方形边长的 1/2 为 1 （ 即正方形边长为 2） 时， offset  等于 0.552  就能使圆弧近似贴近 1/4 圆。所以比例系数为 1/0.552 ，即正方形边长和 offset 的比例系数为：2/0.552 = 3.623。近似于 3.6。其实还有种更直观的近似方法：如果圆心为 O，OC1, OC2  就一定是三等分点，也就是夹角为 30°，那么 AC1 （也就是 offset  ）就等于 1/2的边长 *  tan30° 。
     “顺便解释两个地方。1.为什么要*2? 因为为了让  D 点区别于 A 点，让 D 移动距离比 A 多，你完全可以 *3 ,*2.5，但是不能移动太远。2.为什么要是1/6？这个 1/6 也是自己定的。你可以让 A 移动 1/7 ，1/10 都可以，但是最好不要太靠近 1/2，这时 A 点就移到中点了，形变的样子就不好看了。”
     */
    CGFloat offset = self.outsideRect.size.width / 3.6;
    
    //A.B.C.D实际需要移动的距离.系数为滑块偏离中点0.5的绝对值再乘以2.当滑到两端的时候，movedDistance为最大值：「外接矩形宽度的1/6」. fab() C语言求浮点型绝对值
    CGFloat movedDistance = (self.outsideRect.size.width * 1 / 6) * fabs(self.progress-0.5)*2;
    
    //方便计算 优先计算出外界矩形的中心点
    CGPoint rectCenter = CGPointMake(self.outsideRect.origin.x + self.outsideRect.size.width/2, self.outsideRect.origin.y + self.outsideRect.size.height / 2);
    
    CGPoint pointA = CGPointMake(rectCenter.x, self.outsideRect.origin.y + movedDistance);
    CGPoint pointB = CGPointMake(self.movePoint == POINT_D ? rectCenter.x + self.outsideRect.size.width /2 : rectCenter.x + self.outsideRect.size.width /2 + movedDistance * 2, rectCenter.y);
    CGPoint pointC = CGPointMake(rectCenter.x, rectCenter.y + self.outsideRect.size.height/2 - movedDistance);
    CGPoint pointD = CGPointMake(self.movePoint == POINT_D ? self.outsideRect.origin.x - movedDistance * 2:self.outsideRect.origin.x ,rectCenter.y);
    
    
    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, self.movePoint == POINT_D?pointB.y - offset:pointB.y - offset + movedDistance);
    
    CGPoint c3 = CGPointMake(pointB.x, self.movePoint == POINT_D?pointB.y + offset:pointB.y + offset - movedDistance);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, self.movePoint == POINT_D?pointD.y + offset - movedDistance:pointD.y + offset);
    
    CGPoint c7 = CGPointMake(pointD.x, self.movePoint == POINT_D?pointD.y - offset + movedDistance:pointD.y - offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
    
    
    //外界虚线矩形
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.outsideRect];
    CGContextAddPath(ctx, rectPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGFloat dash[] = {5.0,5.0};
    CGContextSetLineDash(ctx, 0.0, dash, 2);//1
    CGContextStrokePath(ctx);
    
    
    //圆的边界
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalPath closePath];
    
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor purpleColor].CGColor);
    CGContextSetLineDash(ctx, 0, NULL, 0);//2
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    
    //标记出每个点并连线，方便观察，给所有关键点染色 -- 白色,辅助线颜色 -- 白色
    //语法糖：字典@{}，数组@[]，基本数据类型封装成对象@234，@12.0，@YES,@(234+12.0)
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    NSArray *points = @[[NSValue valueWithCGPoint:pointA],[NSValue valueWithCGPoint:pointB],[NSValue valueWithCGPoint:pointC],[NSValue valueWithCGPoint:pointD],[NSValue valueWithCGPoint:c1],[NSValue valueWithCGPoint:c2],[NSValue valueWithCGPoint:c3],[NSValue valueWithCGPoint:c4],[NSValue valueWithCGPoint:c5],[NSValue valueWithCGPoint:c6],[NSValue valueWithCGPoint:c7],[NSValue valueWithCGPoint:c8]];
    [self drawPoint:points withContext:ctx];
    
    //连接辅助线
    UIBezierPath *helperline = [UIBezierPath bezierPath];
    [helperline moveToPoint:pointA];
    [helperline addLineToPoint:c1];
    [helperline addLineToPoint:c2];
    [helperline addLineToPoint:pointB];
    [helperline addLineToPoint:c3];
    [helperline addLineToPoint:c4];
    [helperline addLineToPoint:pointC];
    [helperline addLineToPoint:c5];
    [helperline addLineToPoint:c6];
    [helperline addLineToPoint:pointD];
    [helperline addLineToPoint:c7];
    [helperline addLineToPoint:c8];
    [helperline closePath];
    
    CGContextAddPath(ctx, helperline.CGPath);
    
    CGFloat dash2[] = {2.0, 2.0};
    CGContextSetLineDash(ctx, 0.0, dash2, 2);
    CGContextStrokePath(ctx); //给辅助线条填充颜色
    
    
}



//在某个point位置画一个点，方便观察运动情况
-(void)drawPoint:(NSArray *)points withContext:(CGContextRef)ctx{
    
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        CGContextFillRect(ctx, CGRectMake(point.x - 2,point.y - 2,4,4));
    }
}





- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (progress <= 0.5) {
        self.movePoint = POINT_B;
        MyLog(@"向左移动:B点动");
    } else {
        self.movePoint = POINT_D;
        MyLog(@"向右移动:D点动");
    }
    
    self.lastProgress = progress;
    CGFloat origin_x = self.position.x - kTheExternalRectangleSize/2+ (progress - 0.5)*(self.frame.size.width - kTheExternalRectangleSize);
    CGFloat origin_y = self.position.y - kTheExternalRectangleSize/2;
    self.outsideRect = CGRectMake(origin_x, origin_y, kTheExternalRectangleSize, kTheExternalRectangleSize);
    [self setNeedsDisplay];

}












@end
