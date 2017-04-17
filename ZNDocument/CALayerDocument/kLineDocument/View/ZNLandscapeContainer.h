//
//  ZNLandscapeContainer.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNStockBasedConfigureLib.h"

@interface ZNLandscapeContainer : UIView


- (void)getKlineDataFromVerticalScreenWithArray:(NSMutableArray *)dataArray chartType:(ZNChartType )chartType stockCode:(NSString *)stockCode yesterdayClosingPrice:(NSString *)yesterdayClosingPrice;





@end
