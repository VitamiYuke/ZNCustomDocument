//
//  ZNStockDetailsHeaderView.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/10.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Stock_Details_Default_Height (305 + 120)
@class ZNStockDetailsInfoModel;
@class ZNSearchStockModel;
@class ZNStockDetailsHeaderView;
@protocol ZNStockDetailsHeaderDelegate <NSObject>
@optional

- (void)ZNStockDetailsHeaderView:(ZNStockDetailsHeaderView *)headerView didChangeLookDetailsState:(BOOL )isLookDetails;

@end


@interface ZNStockDetailsHeaderView : UIView

@property(nonatomic, strong)ZNSearchStockModel *stockModel;

@property(nonatomic, strong)ZNStockDetailsInfoModel *detailsModel;

@property(nonatomic, weak)id<ZNStockDetailsHeaderDelegate>delegate;

- (void)resetRightIconConfigure;


@end
