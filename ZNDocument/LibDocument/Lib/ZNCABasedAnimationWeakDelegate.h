//
//  ZNCABasedAnimationWeakDelegate.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/12.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol ZNBasicAnimationDelegate <NSObject>

@optional

- (void)ZNAnimationDidStart:(CAAnimation *)anim;
- (void)ZNAnimationDidStop:(CAAnimation *)anim finished:(BOOL)finished;

@end



@interface ZNCABasedAnimationWeakDelegate : NSObject<CAAnimationDelegate>




+ (instancetype )ZNBasicAnimationWithDelegate:(id<ZNBasicAnimationDelegate>)delegate;


- (instancetype )initWithDelegate:(id<ZNBasicAnimationDelegate>)delegate;



@end
