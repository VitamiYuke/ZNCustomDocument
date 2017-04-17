//
//  ZNStockDetailsView.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/12.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>


#define Each_Row_Height (50)


@class ZNStockDetailsInfoModel;

@interface ZNStockDetailsView : UIView

@property(nonatomic, assign)BOOL isTheBroaderMarket;//是否是大盘数据


@property(nonatomic, strong)ZNStockDetailsInfoModel *stockDetailsInfoModel;





@end
