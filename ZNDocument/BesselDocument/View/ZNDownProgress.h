//
//  ZNDownProgress.h
//  ZNDocument
//
//  Created by 张楠 on 17/2/27.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZNDownState) {
    ZNDownStateStart = 0,  //没有下载过
    ZNDownStateDowning, ///正在下载的状态
    ZNDownStatePause, ///<暂停状态
};

@class ZNDownProgress;

@protocol ZNDownProgressClickDelegate <NSObject>

- (void)ZNDownProgressView:(ZNDownProgress *)downProgress WithState:(ZNDownState )downState;

@end


@interface ZNDownProgress : UIView


- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor downState:(ZNDownState )downState;


@property(nonatomic, weak)id<ZNDownProgressClickDelegate>delegate;

@property(nonatomic, assign)CGFloat perValue;//如果是正在下载状态则设置这个值

@property(nonatomic, assign)ZNDownState downState;//下载的状态



@end
