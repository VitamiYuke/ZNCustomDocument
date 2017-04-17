//
//  ZNStockBasedConfigureLib.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNStockBasedConfigureLib.h"

@implementation ZNStockBasedConfigureLib


+ (NSURLSessionDataTask *)getStockTimeSharingDateWithStockCode:(NSString *)stockCode success:(void (^)(id))succ failure:(void (^)(void))fail{
    NSMutableDictionary *parameter = [ZNBasedParameteManager getEncryptionBasedParameters];
    parameter[@"code"] = stockCode;
    MyLog(@"请求分时的参数:%@",parameter);
    return [ZNNetworkManager GET:StockDomainName(@"api", @"stock_min") parameter:parameter downProgress:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"分时请求的结果:%@",responseObject);
        succ(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"分时请求链接错误:%@",error);
        fail();
    }];
}

+ (NSURLSessionDataTask *)getStockKlineDataWithStockCode:(NSString *)stockCode kType:(ZNChartType )kType success:(void (^)(id))succ failure:(void (^)(void))fail
{
    
    NSString *typeString = nil;
    
    switch (kType) {
        case ZNChartDailyKLine:
            typeString = @"daily";
            break;
        case ZNChartWeeklyKLine:
            typeString = @"weekly";
            break;
        case ZNChartMonthlyKLine:
            typeString = @"monthly";
            break;
        default:
            break;
    }
    
    if (!typeString) {
        MyLog(@"没有类型");
        return nil;
    }
    
    // 默认前复权
    NSMutableDictionary *parameter = [ZNBasedParameteManager getEncryptionBasedParameters];
    parameter[@"code"] = stockCode;
    parameter[@"type"] = typeString;
    parameter[@"version"] = @"4";
    parameter[@"number"] = [NSString stringWithFormat:@"%0.f",MAXFLOAT];
    if ([[ZNUserDefault objectForKey:@"Authority"] isEqualToString:@"yes"] || strIsEmpty([ZNUserDefault objectForKey:@"Authority"])) {//前权
        parameter[@"adjust"] = @"forward";
    }
    MyLog(@"请求k线的参数:%@",parameter);
    return [ZNNetworkManager GET:StockDomainName(@"api", @"stock_history") parameter:parameter downProgress:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"分时请求的结果:%@",responseObject);
        succ(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"分时请求链接错误:%@",error);
        fail();
    }];
    

}





//五挡数据
+ (NSURLSessionTask *)getStockKlineFiveBlockDataWithStockCode:(NSString *)stockCode success:(void (^)(id))succ failure:(void (^)(void))fail
{
    if (!stockCode || stockCode.length == 0) {
        MyLog(@"没有数据源");
        return nil;
    }
    
    NSMutableDictionary *parameter = [ZNBasedParameteManager getEncryptionBasedParameters];
    parameter[@"list"] = stockCode;
    MyLog(@"五挡的数据参数:%@",parameter);
    return [ZNNetworkManager GET:StockDomainName(@"api", @"query") parameter:parameter downProgress:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"五挡的数据结果:%@",responseObject);
        succ(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"五挡请求链接错误:%@",error);
        fail();
    }];
}

+ (NSURLSessionTask *)getStockKlineTheDetailDataWithStockCode:(NSString *)stockCode success:(void (^)(id))succ failure:(void (^)(void))fail
{
    if (!stockCode || stockCode.length == 0) {
        MyLog(@"没有数据源");
        return nil;
    }
    
    NSMutableDictionary *parameter = [ZNBasedParameteManager getEncryptionBasedParameters];
    parameter[@"code"] = stockCode;
    MyLog(@"明细的数据参数:%@",parameter);
    return [ZNNetworkManager GET:StockDomainName(@"api", @"stock_trade") parameter:parameter downProgress:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"明细的数据结果:%@",responseObject);
        succ(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"明细请求链接错误:%@",error);
        fail();
    }];
}




@end
