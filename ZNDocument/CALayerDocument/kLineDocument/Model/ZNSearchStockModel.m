//
//  ZNSearchStockModel.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/7.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNSearchStockModel.h"

@implementation ZNSearchStockModel


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if ([super init]) {
        self.stockName = [aDecoder decodeObjectForKey:@"stockName"];
        self.stockCode = [aDecoder decodeObjectForKey:@"stockCode"];
        self.stockSymbol = [aDecoder decodeObjectForKey:@"stockSymbol"];
        self.stockPinyin = [aDecoder decodeObjectForKey:@"stockPinyin"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.stockName forKey:@"stockName"];
    [aCoder encodeObject:self.stockCode forKey:@"stockCode"];
    [aCoder encodeObject:self.stockSymbol forKey:@"stockSymbol"];
    [aCoder encodeObject:self.stockPinyin forKey:@"stockPinyin"];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}






@end
