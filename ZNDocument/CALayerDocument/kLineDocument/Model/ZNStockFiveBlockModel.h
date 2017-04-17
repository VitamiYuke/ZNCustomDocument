//
//  ZNStockFiveBlockModel.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>

//五挡数据
@interface ZNStockFiveBlockModel : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* volum;
@property (nonatomic, strong) UIColor* color;
@end
