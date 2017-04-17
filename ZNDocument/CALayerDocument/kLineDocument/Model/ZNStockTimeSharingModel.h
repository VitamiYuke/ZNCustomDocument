//
//  ZNStockTimeSharingModel.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>

//股票分时数据
@interface ZNStockTimeSharingModel : NSObject
//时间
@property (nonatomic, copy) NSString* time;
//均价
@property (nonatomic, copy) NSString* avg_price;
//价格
@property (nonatomic, copy) NSString* price;
//成交量
@property (nonatomic, copy) NSString* volume;
@end
