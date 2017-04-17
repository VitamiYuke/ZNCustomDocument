//
//  ZNLandscapeKline.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineBasedConfigure.h"

@interface ZNLandscapeKline : ZNKlineBasedConfigure




- (void)configureStockKlineDataWithArray:(NSMutableArray *)dataArray chartType:(ZNChartType )chartType stockCode:(NSString *)stockCode yesterdayClosingPrice:(NSString *)yesterdayClosingPrice;


@end
