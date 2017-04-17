//
//  ZNKlineLandscapeController.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/28.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNViewController.h"
#import "ZNStockBasedConfigureLib.h"
@interface ZNKlineLandscapeController : ZNViewController

@property(nonatomic, assign)CGPoint touchPoint;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)ZNChartType chartType;


//
@property(nonatomic, copy)NSString *stockCode;
@property(nonatomic, copy)NSString *yesterdayClosingPrice;



@end
