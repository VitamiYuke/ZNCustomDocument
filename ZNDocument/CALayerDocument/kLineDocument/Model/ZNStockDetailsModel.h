//
//  ZNStockDetailsModel.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>
//明细
@interface ZNStockDetailsModel : NSObject
@property (nonatomic, copy) NSString* time;
@property (nonatomic, copy) NSString* volum;
@property (nonatomic, copy) NSString* kind;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, strong) UIColor* color;
@end
