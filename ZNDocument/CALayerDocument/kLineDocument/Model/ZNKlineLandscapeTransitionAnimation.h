//
//  ZNKlineLandscapeTransitionAnimation.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/28.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZNTheModalType) {
    ZNTheModalTypePresent = 6,
    ZNTheModalTypeDismiss = 7
};


@interface ZNKlineLandscapeTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign)ZNTheModalType modalType;

@end
