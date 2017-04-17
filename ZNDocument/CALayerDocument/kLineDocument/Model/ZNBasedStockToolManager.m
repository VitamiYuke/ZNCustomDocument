//
//  ZNBasedStockToolManager.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/7.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNBasedStockToolManager.h"
#import "ZNSearchStockModel.h"


@implementation ZNBasedStockToolManager




//股票类工具
+ (NSString *)getStockVolumeUnitWithVolume:(CGFloat)volume{
    volume = volume/100.0;
    if (volume < 10000.0) {
        return @"手 ";
    }else if (volume > 10000.0 && volume < 100000000.0){
        return @"万手 ";
    }else{
        return @"亿手 ";
    }
}

+ (NSString *)configureStockVolumeShowWithVolume:(CGFloat)volume{
    volume = volume/100.0;
    if (volume < 10000.0) {
        return [NSString stringWithFormat:@"%.0f ",volume];
    }else if (volume > 10000.0 && volume < 100000000.0){
        return [NSString stringWithFormat:@"%.2f ",volume/10000.0];
    }else{
        return [NSString stringWithFormat:@"%.2f ",volume/100000000.0];
    }
}



+ (BOOL)isIndexWithStockCode:(NSString *)stockCode{
    
    if ([stockCode isEqualToString:@"sh000001"]||[stockCode isEqualToString:@"sz399001"]||[stockCode isEqualToString:@"sz399006"]) {
        return YES;
    }else
    {
        return NO;
    }
}

+ (BOOL)isWhetherStockTradingTime{
    
    NSDateComponents *dateComps = [self YukeToolGetCurrentDateComponents];
    NSInteger weekDay = [dateComps weekday];
    NSInteger hour = [dateComps hour];
    NSInteger minute = [dateComps minute];
    MyLog(@"周几:%ld",weekDay);
    if (weekDay == 1 || weekDay == 7) {
        MyLog(@"周末");
        return NO;
    }
    
    MyLog(@"小时:%ld 分钟:%ld",hour,minute);
    if (hour < 9 || hour > 14 || hour == 12) {
        return NO;
    }
    
    if (hour == 9 && minute <29) {
        return NO;
    }
    
    if (hour == 11 && minute > 30) {
        return NO;
    }
    
    
    return YES;
}

+ (NSString *)configureFloatStringWithOriginValue:(CGFloat)floatValue{
    return [NSString stringWithFormat:@"%.2f",floatValue];
}

//获取全部股票
+ (NSURLSessionDataTask *)getAllStockInfoSuccess:(void (^)(id))succ failure:(void (^)(void))fail
{
    return [ZNNetworkManager GET:RelatedMarket(@"stock", @"api", @"all") parameter:[ZNBasedParameteManager getEncryptionBasedParameters] downProgress:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"全部股票的数据结果:%@",responseObject);
        succ(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"全部股票请求链接错误:%@",error);
        fail();
    }];
}

+ (NSURLSessionDataTask *)getHotStockInfoSuccess:(void (^)(id))succ failure:(void (^)(void))fail{
    return [ZNNetworkManager GET:RelatedMarket(@"stock", @"api", @"igp_hot") parameter:[ZNBasedParameteManager getEncryptionBasedParameters] downProgress:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"热门股票的数据结果:%@",responseObject);
        succ(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"热门股票请求链接错误:%@",error);
        fail();
    }];
}



+ (void)startConfigureAllStockInfoFromInternet{
    
    [self getAllStockInfoSuccess:^(id responseObject) {
        NSMutableArray *tempArray= @[].mutableCopy;
        NSArray *dataArray = (NSArray *)responseObject;
        if (dataArray.count > 0) {
            for (NSDictionary *dic in dataArray) {
                ZNSearchStockModel *model = [[ZNSearchStockModel alloc] init];
                model.stockCode = [NSString stringWithFormat:@"%@",dic[@"c"]];
                model.stockName = [NSString stringWithFormat:@"%@",dic[@"n"]];
                model.stockSymbol = [NSString stringWithFormat:@"%@",dic[@"s"]];
                model.stockPinyin = [NSString stringWithFormat:@"%@",dic[@"p"]];
                [tempArray addObject:model];
            }

            if (tempArray.count > 0) {
                MyLog(@"全部股票的路径%@",ZNLocalStockPath);
                [NSKeyedArchiver archiveRootObject:tempArray toFile:ZNLocalStockPath];
            }
        }
        
    } failure:^{
        
    }];
}

+ (void)startConfigureHotStockInfoFromInternet{
    [self getHotStockInfoSuccess:^(id responseObject) {
        NSMutableArray *tempArray= @[].mutableCopy;
        NSArray *dataArray = (NSArray *)responseObject;
        if (dataArray.count > 0) {
            for (NSDictionary *dic in dataArray) {
                ZNSearchStockModel *model = [[ZNSearchStockModel alloc] init];
                model.stockCode = dic[@"code"];
                model.stockName = dic[@"name"];
                model.stockSymbol = dic[@"symbol"];
                model.stockPinyin = @"hot";
                [tempArray addObject:model];
            }
            if (tempArray.count > 0) {
                MyLog(@"热门股票的路径%@",ZNLocalHotStockPath);
                [NSKeyedArchiver archiveRootObject:tempArray toFile:ZNLocalHotStockPath];
            }
        }
    } failure:^{
        
    }];
}



+ (NSString *)configureGetSearchResultWithModel:(ZNSearchStockModel *)model{
    return [NSString stringWithFormat:@" %@  %@",model.stockSymbol,model.stockName];
}

+ (ZNSearchStockModel *)configureGetSearchModelWithSearchKeyWord:(NSString *)keyWord{
    
    
    if ([keyWord isEqualToString:@"上证指数"]) {
        ZNSearchStockModel *model = [[ZNSearchStockModel alloc] init];
        model.stockCode = @"sh000001";
        model.stockName = @"上证指数";
        model.stockSymbol = @"000001";
        return model;
    }
    
    if ([keyWord isEqualToString:@"深证指数"]) {
        ZNSearchStockModel *model = [[ZNSearchStockModel alloc] init];
        model.stockCode = @"sz399001";
        model.stockName = @"深证指数";
        model.stockSymbol = @"399001";
        return model;
    }
    
    if ([keyWord isEqualToString:@"创业扳指"]) {
        ZNSearchStockModel *model = [[ZNSearchStockModel alloc] init];
        model.stockCode = @"sz399006";
        model.stockName = @"创业扳指";
        model.stockSymbol = @"399006";
        return model;
    }
    
    NSArray *allArray = [NSKeyedUnarchiver unarchiveObjectWithFile:ZNLocalStockPath];
    if (allArray.count) {
        for (ZNSearchStockModel *model in allArray) {
            if ([keyWord containsString:model.stockName]) {
                return model;
            } 
        }
    }
    return nil;
}

+ (NSURLSessionDataTask *)getStockDetailsInfoWithStockCode:(NSString *)stockCode OrStocksArray:(NSArray<NSString *> *)stocks Success:(void (^)(id))succ Failure:(void (^)(void))fail{
    if (!stockCode && stocks.count == 0 && stockCode.length == 0) {
        MyLog(@"没有请求的必要材料");
        return nil;
    }

    NSMutableDictionary *parameter = [ZNBasedParameteManager getEncryptionBasedParameters];
    if (stockCode && stockCode.length) {
        parameter[@"list"] = stockCode;
    }else{
        if (stocks.count) {
            NSMutableString *listValue = [NSMutableString string];
            for (int i = 0; i < stocks.count; i++) {
                if (i == stocks.count - 1) {
                    [listValue appendString:stocks[i]];
                }else{
                    NSString *tempStock = [NSString stringWithFormat:@"%@,",stocks[i]];
                    [listValue appendString:tempStock];
                }
            }
            
            if (listValue.length) {
                parameter[@"list"] = listValue;
            }
 
        }
    }
    MyLog(@"股票详情数据参数:%@",parameter);
    return [ZNNetworkManager GET:StockDomainName(@"api", @"query") parameter:parameter downProgress:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"股票详情数据结果:%@",responseObject);
        succ(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"股票详情数据错误:%@",error);
        fail();
    }];
}

+ (NSURLSessionDataTask *)getStockInSideAndOutSideDishWithStockCode:(NSString *)stockCode Success:(void (^)(id))succ Failure:(void (^)(void))fail{
    if (!stockCode) {
        MyLog(@"没有请求的必要材料");
        return nil;
    }
    NSMutableDictionary *parameter = [ZNBasedParameteManager getEncryptionBasedParameters];
    parameter[@"code"] = stockCode;
    MyLog(@"内外盘数据的接口参数:%@",parameter);
    return [ZNNetworkManager GET:StockDomainName(@"api", @"stock_trade_bs") parameter:parameter downProgress:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"内外盘情数据结果:%@",responseObject);
        succ(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"内外盘数据错误:%@",error);
        fail();
    }];
}

+ (NSURLSessionDataTask *)getStockFinanceWithStockCode:(NSString *)stockCode Success:(void (^)(id))succ Failure:(void (^)(void))fail{
    if (!stockCode) {
        MyLog(@"没有请求的必要材料");
        return nil;
    }
    NSMutableDictionary *parameter = [ZNBasedParameteManager getEncryptionBasedParameters];
    parameter[@"code"] = stockCode;
    MyLog(@"股票融资信息数据的接口参数:%@",parameter);
    return [ZNNetworkManager GET:StockDomainName(@"api", @"stock_finance") parameter:parameter downProgress:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"股票融资信息数据结果:%@",responseObject);
        succ(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"股票融资信息数据错误:%@",error);
        fail();
    }];
}







@end
