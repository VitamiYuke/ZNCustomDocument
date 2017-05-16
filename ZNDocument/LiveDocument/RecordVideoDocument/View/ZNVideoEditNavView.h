//
//  ZNVideoEditNavView.h
//  ZNDocument
//
//  Created by 张楠 on 2017/5/9.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNVideoEditNavView : UIView



+ (instancetype)defaultVideoNav;



- (void)showAnimation;
- (void)hiddenAnimation;

- (void)restConfigureBecauseOfControllerWillDisappear;

@property(nonatomic, copy)void(^deleteVideoAction)(void);



@end
