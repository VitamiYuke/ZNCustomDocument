//
//  ZNKlineHeaderView.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/20.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZNStockKlineModel;

@interface ZNKlineHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame isLandscape:(BOOL )isLandscape;

- (void)refreshShowTimeSharingModelWithModel:(ZNStockKlineModel *)klineModel beforeClosePrice:(CGFloat )beforeClosePrice;

@end
