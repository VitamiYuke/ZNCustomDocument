//
//  ZNKTimeHeaderView.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/20.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>




@class ZNStockTimeSharingModel;

@interface ZNKTimeHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame isLandscape:(BOOL )isLandscape;


- (void)refreshShowTimeSharingModelWithModel:(ZNStockTimeSharingModel *)sharingModel yesterdayPrice:(CGFloat )yesterdayPrice;



@end
