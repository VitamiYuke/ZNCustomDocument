//
//  ZNKlineFiveBlockAndTheDetailsView.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNKlineFiveBlockAndTheDetailsView : UIView

@property(nonatomic, assign)BOOL isLandscape;//是否是全屏


- (void)startLoadingFiveBlockDataWithStockCode:(NSString *)stockCode yesterdayPrice:(NSString *)yesterdayPrice;



@end
