//
//  ZNAppDelegateConfigureManager.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/7.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNAppDelegateConfigureManager.h"
#import "ZNBasedStockToolManager.h"

@implementation ZNAppDelegateConfigureManager



+ (void)startConfigureAppDelegate{
    
    

    //获取全部股票
    dispatch_queue_t load_stock_info_queue = dispatch_queue_create("loadingAllStockInfo", NULL);
    dispatch_async(load_stock_info_queue, ^{
        [ZNBasedStockToolManager startConfigureAllStockInfoFromInternet];
        [ZNBasedStockToolManager startConfigureHotStockInfoFromInternet];
    });
    
}




@end
