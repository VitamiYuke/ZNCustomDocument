//
//  ZNStockDetailsInfoToolManager.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/10.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNBasedStockToolManager.h"
@class ZNStockDetailsInfoModel;
@interface ZNStockDetailsInfoToolManager : ZNBasedStockToolManager




+ (ZNStockDetailsInfoModel *)configureStockDetailsInfoWithDataString:(NSString *)dataString originalData:(ZNStockDetailsInfoModel *)originalModel;

+ (NSString *)configureAppliesAndForeheadWithOriginValue:(NSString *)forehead applies:(NSString *)applies;

+ (NSMutableAttributedString *)configureTurnoverShowWithTurnoverValue:(NSString *)turnover;


@end
