//
//  ZNStockDetailsInfoModel.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/10.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNStockDetailsInfoModel : NSObject

@property (nonatomic, copy) NSString* currentPrice;//当前价格
@property (nonatomic, copy) NSString* close;//昨日收盘价
@property (nonatomic, copy) NSString* forehead;//涨跌额
@property (nonatomic, copy) NSString* applies;//涨跌幅

@property (nonatomic, copy) NSString* opening;//今日开盘价
@property (nonatomic, copy) NSString* maxPrice;//最高价
@property (nonatomic, copy) NSString* minPrice;//最低价

@property (nonatomic, copy) NSString* volume;//成交量
@property (nonatomic, copy) NSString* turnover;//成交额
@property (nonatomic, copy) NSString* sellVolume;//卖出量
@property (nonatomic, copy) NSString* buyVolume;//买入量
@property (nonatomic, copy) NSString* nowTheHand;//现手
@property (nonatomic, copy) NSString* date;//行情时间
@property (nonatomic, copy) NSString* time;//更新时间

@property (nonatomic, copy) NSString* rate;//振幅
@property (nonatomic, copy) NSString* appointThan;//委比
@property (nonatomic, copy) NSString* committeePoor;//委差
@property (nonatomic, copy) NSString* earnings;//市盈率
@property (nonatomic, copy) NSString* price_to_book;//市净率
@property (nonatomic, copy) NSString* turnoverRate;//换手率

@property (nonatomic, copy) NSString* mgjzc;//每股净资产
@property (nonatomic, copy) NSString* mgsy;//每股收益
@property (nonatomic, copy) NSString* ltsz;//流通市值
@property (nonatomic, copy) NSString* zsz;//总市值

@property (nonatomic, copy) NSString* zgb;//总股本
@property (nonatomic, copy) NSString* ltg;//流通股

@property (nonatomic, copy) NSString* insideDish;//内盘
@property (nonatomic, copy) NSString* outsideDish;//外盘


@property(nonatomic, strong)NSArray<NSString *>*dataStringArray;//数据源的数组



@property (nonatomic, strong) NSString* bgq;
@property (nonatomic, strong) NSString* jzcsyl;


@end
