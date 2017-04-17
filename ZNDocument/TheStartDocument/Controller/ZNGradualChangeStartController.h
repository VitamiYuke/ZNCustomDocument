//
//  ZNGradualChangeStartController.h
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/9/2.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNViewController.h"

@interface ZNGradualChangeStartController : ZNViewController


/*
 背景图片
 */
@property(nonatomic, strong)NSArray *backGroundImageNames;
/*
 封面图片
 */
@property(nonatomic, strong)NSArray *coverImageNames;

//初始化方法
- (instancetype)initWithCoverImageNames:(NSArray*)coverNames;
- (instancetype)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames;


@end
