//
//  ZNVerticalScreenContainer.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNVerticalScreenContainer : UIView



- (void)startLoadingStockKlineDataWithStockCode:(NSString *)stockCode YesterdayClosingPrice:(NSString *)YesterdayClosingPrice;


- (void)cancelNetworkRequest;





@end
