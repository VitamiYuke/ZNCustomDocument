//
//  ZNVerticalScreenKline.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNVerticalScreenKline.h"
#import "ZNStockTimeSharingModel.h"
#import "ZNStockKlineModel.h"
@interface ZNVerticalScreenKline ()

@end


@implementation ZNVerticalScreenKline

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);

    if (self.chartType) {
        if (self.chartType == ZNChartTimeLine && self.KTimeDataArray.count > 0) {
            [self drawStockKlineCoordinateWithContext:context withIsLandscape:NO];
            [self drawKTimeTheXAxisWithContext:context];
        }else{
            
            
        }
    }else{
        
    }
    
    
    
}





#pragma mark - 准备画图
- (void)prepareToDraw{
    [super prepareToDraw];
    [self prepareToConfigureDrawArea];
    
    if (self.chartType == ZNChartTimeLine) {
        [self calculateKTimeRelevantData];
        //配置完毕数据开始画图
        [self drawKTimeLineAndVolume];
    }else{
        [self calculateKlineRelevantData];
        [self drawKlineLineAndVolume];
    }
    
    [ZNStockBasedConfigureLib isWhetherStockTradingTime];
    
    if (!self.longPressGesture.view) {
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    
}


#pragma mark - 配置绘制区域
- (void)prepareToConfigureDrawArea{
    //配置绘画的区域
    if (self.chartType == ZNChartTimeLine && ![ZNStockBasedConfigureLib isIndexWithStockCode:self.stockCode]) {//不是大盘的分时
        [self configureDrawCanvasFrameFromEdgeInsets:UIEdgeInsetsMake(canvasMargin + choiceNormalHeight, canvasMargin, canvasMargin, canvasMargin + fiveBlockWidth)];
    }else{
        [self configureDrawCanvasFrameFromEdgeInsets:UIEdgeInsetsMake(canvasMargin + choiceNormalHeight, canvasMargin, canvasMargin, canvasMargin)];
    }
}


- (void)dealloc{
    MyLog(@"竖屏画线部分销毁:%@",self);
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self configureSysting];
    }
    return self;
}

- (void)configureSysting{
    self.isLandscape = NO;
    
    [self addGestureRecognizer:self.longPressGesture];
    
}

- (NSMutableArray *)currentDataArray{
    return self.chartType==ZNChartTimeLine?self.KTimeDataArray:self.KlineDataArray;
}


@end
