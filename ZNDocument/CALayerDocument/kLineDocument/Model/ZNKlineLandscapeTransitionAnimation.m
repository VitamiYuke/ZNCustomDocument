//
//  ZNKlineLandscapeTransitionAnimation.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/28.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineLandscapeTransitionAnimation.h"
#import "ZNKlineLandscapeController.h"
@interface ZNKlineLandscapeTransitionAnimation ()<CAAnimationDelegate>

@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;

@end


@implementation ZNKlineLandscapeTransitionAnimation


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.66f;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;


    ZNKlineLandscapeController *operationVC = (ZNKlineLandscapeController *)[transitionContext viewControllerForKey:self.modalType == ZNTheModalTypePresent?UITransitionContextToViewControllerKey:UITransitionContextFromViewControllerKey];
    
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:[transitionContext viewControllerForKey:self.modalType == ZNTheModalTypeDismiss?UITransitionContextToViewControllerKey:UITransitionContextFromViewControllerKey].view];
    
    [containerView addSubview:operationVC.view];
    
   
    CGRect startRect  = CGRectMake(operationVC.touchPoint.x, operationVC.touchPoint.y, 0, 0);
    
    CGPoint finalPoint;
    //判断触发点在哪个象限
    if(startRect.origin.x > (operationVC.view.bounds.size.width / 2)){
        if (startRect.origin.y < (operationVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(startRect.origin.x - 0, startRect.origin.y - CGRectGetMaxY(operationVC.view.bounds));
        }else{
            //第四象限
            finalPoint = CGPointMake(startRect.origin.x - 0, startRect.origin.y - 0);
        }
    }else{
        if (startRect.origin.y < (operationVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(startRect.origin.x - CGRectGetMaxX(operationVC.view.bounds), startRect.origin.y - CGRectGetMaxY(operationVC.view.bounds));
        }else{
            //第三象限
            finalPoint = CGPointMake(startRect.origin.x - CGRectGetMaxX(operationVC.view.bounds), startRect.origin.y - 0);
        }
    }
    
    CGFloat finalRadius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(startRect, -finalRadius, -finalRadius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    [maskLayer setPath:self.modalType == ZNTheModalTypePresent?endPath.CGPath:startPath.CGPath];
    operationVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    if (self.modalType == ZNTheModalTypePresent) {
        animation.fromValue = (__bridge id)startPath.CGPath;
        animation.toValue = (__bridge id)endPath.CGPath;
    }else{
        animation.fromValue = (__bridge id)endPath.CGPath;
        animation.toValue = (__bridge id)startPath.CGPath;
    }
    animation.duration = [self transitionDuration:transitionContext];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    [maskLayer addAnimation:animation forKey:@"transitionAnimation"];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    MyLog(@"过渡动画执行完毕");
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:self.modalType == ZNTheModalTypePresent?UITransitionContextToViewControllerKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    self.transitionContext = nil;
}




@end
