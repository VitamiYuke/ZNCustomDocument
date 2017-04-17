//
//  ZNStockDetailsCustomNavView.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/10.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZNSearchStockModel;
@interface ZNStockDetailsCustomNavView : UIView

@property(nonatomic, strong)ZNSearchStockModel *stockModel;


@property(nonatomic, copy)NSString *detaisDescString;



@end
