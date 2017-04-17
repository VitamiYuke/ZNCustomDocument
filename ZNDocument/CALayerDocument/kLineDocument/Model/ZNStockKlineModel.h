//
//  ZNStockKlineModel.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>
//股票的k线
@interface ZNStockKlineModel : NSObject
/**
 *  成交额
 */
@property (nonatomic, copy) NSString* amount;
/**
 *  涨跌额
 */
@property (nonatomic, copy) NSString* chg;
/**
 *  涨跌幅
 */
@property (nonatomic, copy) NSString* chg_pct;
/**
 *  收盘价
 */
@property (nonatomic, copy) NSString* close;
/**
 *  最高价
 */
@property (nonatomic, copy) NSString* high;
/**
 *  最低价
 */
@property (nonatomic, copy) NSString* low;
/**
 *  10日平均线
 */
@property (nonatomic, copy) NSString* ma10;
/**
 *  20日平均线
 */
@property (nonatomic, copy) NSString* ma20;
/**
 *  5日平均线
 */
@property (nonatomic, copy) NSString* ma5;
/**
 *  开盘价
 */
@property (nonatomic, copy) NSString* open;
/**
 *  成交量
 */
@property (nonatomic, copy) NSString* volume;
/**
 *  日期
 */
@property (nonatomic, copy) NSString* time;

/**
 *  换手率
 */
@property (nonatomic, copy) NSString* turnover;
@end
