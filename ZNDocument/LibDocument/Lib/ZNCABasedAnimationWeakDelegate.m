//
//  ZNCABasedAnimationWeakDelegate.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/12.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNCABasedAnimationWeakDelegate.h"


@interface ZNCABasedAnimationWeakDelegate ()


@property(nonatomic, nullable, weak, readonly)id delegate;

@end


@implementation ZNCABasedAnimationWeakDelegate




+ (instancetype)ZNBasicAnimationWithDelegate:(id<ZNBasicAnimationDelegate>)delegate
{
    ZNCABasedAnimationWeakDelegate *weakDelegate = [[ZNCABasedAnimationWeakDelegate alloc] initWithDelegate:delegate];
    return weakDelegate;
}


- (instancetype)initWithDelegate:(id<ZNBasicAnimationDelegate>)delegate
{
    if ([super init]) {
        _delegate = delegate;
    }
    return self;
}


- (void)animationDidStart:(CAAnimation *)anim{
    if (_delegate && [_delegate respondsToSelector:@selector(ZNAnimationDidStart:)]) {
        [_delegate ZNAnimationDidStart:anim];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZNAnimationDidStop:finished:)]) {
        [_delegate ZNAnimationDidStop:anim finished:flag];
    }
}


- (void)dealloc{
    MyLog(@"动画中间代理销毁:%@",self);
}


@end
