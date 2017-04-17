//
//  ZNSearchStockModel.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/7.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNSearchStockModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString* stockName;
@property (nonatomic, copy) NSString* stockCode;
@property (nonatomic, copy) NSString* stockSymbol;
@property (nonatomic, copy) NSString* stockPinyin;
@end
