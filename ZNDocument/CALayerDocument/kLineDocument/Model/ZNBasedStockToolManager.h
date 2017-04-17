//
//  ZNBasedStockToolManager.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/7.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNBasedToolManager.h"



#define Stock_Red ([UIColor colorWithRed:239/255.0 green:75/255.0 blue:90/255.0 alpha:1.0])
#define Stock_Green ([UIColor colorWithRed:43/255.0 green:189/255.0 blue:100/255.0 alpha:1.0])
#define Stock_Gray ([UIColor colorWithRed:146/255.0 green:160/255.0 blue:172/255.0 alpha:1.0])

#define ShangZ_Symbol @"sh000001_s"
#define ShenZ_Symbol @"sz399001_s"
#define ChuangY_Symbol @"sz399006_s"






@class ZNSearchStockModel;

@interface ZNBasedStockToolManager : ZNBasedToolManager


//股票相关工具

//成交量的单位
+(NSString *)getStockVolumeUnitWithVolume:(CGFloat )volume;

//处理成交量的显示
+(NSString *)configureStockVolumeShowWithVolume:(CGFloat )volume;

//判断是否是大盘指数
+(BOOL)isIndexWithStockCode:(NSString *)stockCode;

//判断是否在股票交易时间
+(BOOL)isWhetherStockTradingTime;

//处理浮点型的字符串变成保留两位小数
+(NSString *)configureFloatStringWithOriginValue:(CGFloat )floatValue;





//获取全部股票
+ (NSURLSessionDataTask *)getAllStockInfoSuccess:(void(^)(id responseObject))succ
                                         failure:(void(^)(void))fail;
//热门股票
+ (NSURLSessionDataTask *)getHotStockInfoSuccess:(void(^)(id responseObject))succ
                                         failure:(void(^)(void))fail;




+ (void)startConfigureAllStockInfoFromInternet;
+ (void)startConfigureHotStockInfoFromInternet;



+ (NSString *)configureGetSearchResultWithModel:(ZNSearchStockModel *)model;
+(ZNSearchStockModel *)configureGetSearchModelWithSearchKeyWord:(NSString *)keyWord;



//获取 股票信息
+ (NSURLSessionDataTask *)getStockDetailsInfoWithStockCode:(NSString *)stockCode
                                             OrStocksArray:(NSArray<NSString *> *)stocks
                                                   Success:(void(^)(id responseObject))succ
                                                   Failure:(void(^)(void))fail;



//获取股票内外盘的数据
+ (NSURLSessionDataTask *)getStockInSideAndOutSideDishWithStockCode:(NSString *)stockCode
                                                   Success:(void(^)(id responseObject))succ
                                                   Failure:(void(^)(void))fail;


//获取融资信息
+ (NSURLSessionDataTask *)getStockFinanceWithStockCode:(NSString *)stockCode
                                                            Success:(void(^)(id responseObject))succ
                                                            Failure:(void(^)(void))fail;




@end
