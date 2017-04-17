//
//  ZNKlineCanvas.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNStockBasedConfigureLib.h"

//画布用来绘制股票线


@interface ZNKlineCanvas : UIView

@property(nonatomic, assign)ZNChartType chartType;//
//设置画布的大小
- (void)configureDrawCanvasFrameFromEdgeInsets:(UIEdgeInsets )edgeInsets;

//获取画布的上下左右 高宽
- (CGFloat )canvasTop;
- (CGFloat )canvasBottom;
- (CGFloat )canvasLeft;
- (CGFloat )canvasRight;
- (CGFloat )canvasWidth;
- (CGFloat )canvasHeight;
- (CGFloat )canvasMidX;
- (CGFloat )canvasMidY;
- (CGFloat )canvasWidth_2;
- (CGFloat )canvasHeight_2;
- (CGFloat )canvasVolumeTop;//
- (CGFloat )canvasKlineBottom;
- (CGFloat )canvasKlineHeight;
- (CGFloat )canvasVolumeHeight;
- (CGRect )canvasDrawRect;

//分时成交量的宽度
- (CGFloat )KTimeVolumeUnitWidth;



//属性
- (void)configureDrawRelatedAttInfo;
@property(nonatomic, strong, readonly)NSDictionary *kTimeTheXAxisAtt;
@property(nonatomic, strong, readonly)NSDictionary *kTimeTheYAxisAtt;


@end
