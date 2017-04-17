//
//  ZNLandscapeKline.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNLandscapeKline.h"
#import "ZNStockTimeSharingModel.h"
#import "ZNStockKlineModel.h"
#import <POP.h>
@interface ZNLandscapeKline ()

@property(nonatomic, strong)UIPanGestureRecognizer *panGesture;//滑动手势
@property(nonatomic, strong)UIPinchGestureRecognizer *pinchGesture;//凑合手势

@property(nonatomic, assign)NSInteger tempCount;

@property(nonatomic, assign)NSInteger tempPanCount;





@end



@implementation ZNLandscapeKline



- (UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    }
    return _panGesture;
}

- (UIPinchGestureRecognizer *)pinchGesture{
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    }
    return _pinchGesture;
}



- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    
    if (self.chartType) {
        if (self.chartType == ZNChartTimeLine) {
            [self drawStockKlineCoordinateWithContext:context withIsLandscape:YES];
            [self drawKTimeTheXAxisWithContext:context];
        }else{
            
            
        }
    }else{
        
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self configureInfoAndUI];
    }
    return self;
}

- (void)configureInfoAndUI{
    self.isLandscape = YES;
    [self addGestureRecognizer:self.longPressGesture];
    
    if (self.chartType != ZNChartTimeLine) {
        [self addGestureRecognizer:self.pinchGesture];
        [self addGestureRecognizer:self.panGesture];
    }
    
    
    
}

- (void)resetSubConfigureBecauseOfChangeChoice{
    [super resetSubConfigureBecauseOfChangeChoice];
    [self removeGestureRecognizer:self.pinchGesture];
    [self removeGestureRecognizer:self.panGesture];
}



- (void)prepareToDraw{//准备画图
    [self prepareToConfigureDrawArea];
    [super prepareToDraw];
    if (self.chartType == ZNChartTimeLine) {
        [self calculateKTimeRelevantData];
        //配置完毕数据开始画图
        [self drawKTimeLineAndVolume];
    }else{
        [self calculateKlineRelevantData];
        [self drawKlineLineAndVolume];
    }
    
    
    
    if (!self.longPressGesture.view) {
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    
    [self resetSubConfigureBecauseOfChangeChoice];
    if (self.chartType != ZNChartTimeLine) {
        if (!self.pinchGesture.view) {
            [self addGestureRecognizer:self.pinchGesture];
        }
        if (!self.panGesture.view) {
            [self addGestureRecognizer:self.panGesture];
        }
    }
    
}

#pragma mark - 配置绘制区域
- (void)prepareToConfigureDrawArea{
    //配置绘画的区域
    if (self.chartType == ZNChartTimeLine) {
        [self configureDrawCanvasFrameFromEdgeInsets:UIEdgeInsetsMake(choiceFullScreenHeight, canvasMargin + self.configureLeftYAxisWidth, canvasMargin + choiceFullScreenHeight, canvasMargin + ([ZNStockBasedConfigureLib isIndexWithStockCode:self.stockCode]?0:fiveBlockWidth) + self.configureRightYAxisWidth)];
    }else{
        [self configureDrawCanvasFrameFromEdgeInsets:UIEdgeInsetsMake(choiceFullScreenHeight, canvasMargin + self.configureLeftYAxisWidth, canvasMargin + choiceFullScreenHeight, canvasMargin + ([ZNStockBasedConfigureLib isIndexWithStockCode:self.stockCode]?0:50))];
    }
}

- (void)configureStockKlineDataWithArray:(NSMutableArray *)dataArray chartType:(ZNChartType)chartType stockCode:(NSString *)stockCode yesterdayClosingPrice:(NSString *)yesterdayClosingPrice{
    
    
    self.chartType = chartType;
    self.stockCode = stockCode;
    self.YesterdayClosingPrice = [yesterdayClosingPrice floatValue];
    
    
    if (dataArray.count == 0 ) {
        MyLog(@"没有数据");
        return;
    }
    
    if (self.chartType == ZNChartTimeLine) {
        [self.KTimeDataArray removeAllObjects];
        [self.KTimeDataArray addObjectsFromArray:dataArray];
    }else{
        [self.KlineDataArray removeAllObjects];
        [self.KlineDataArray addObjectsFromArray:dataArray];
    }
    
    [self prepareToDraw];
    
}


- (CGFloat )configureLeftYAxisWidth{
    
    CGFloat leftWidth = 0;
    
    
    
    //配置 左边距
    CGFloat maxPrice = 0;
    NSInteger maxVolum = 0;
    
    if (self.chartType == ZNChartTimeLine) {
        
        for (ZNStockTimeSharingModel *model in self.KTimeDataArray) {
            maxPrice = MAX(maxPrice, [model.price floatValue]);
            maxVolum = MAX(maxVolum, [model.volume integerValue]);
        }
        
    }else{
        for (ZNStockKlineModel *model in self.KlineDataArray) {
            CGFloat highPrice = [model.high floatValue];
            CGFloat ma5Price = [model.ma5 floatValue];
            CGFloat ma10Price = [model.ma10 floatValue];
            CGFloat ma20Price = [model.ma20 floatValue];
            NSInteger volume = [model.volume integerValue];
            //最高价
            maxPrice = MAX(maxPrice, highPrice);
            maxPrice = MAX(maxPrice, ma5Price);
            maxPrice = MAX(maxPrice, ma10Price);
            maxPrice = MAX(maxPrice, ma20Price);
            maxVolum = MAX(maxVolum, volume);
        }
    }
    

    NSString *maxPriceStr = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:maxPrice];
    
    NSString *unitStr = [ZNStockBasedConfigureLib getStockVolumeUnitWithVolume:maxVolum];
    
    NSString *volumeStr = [ZNStockBasedConfigureLib configureStockVolumeShowWithVolume:maxVolum];
    
    
    CGSize maxPriceSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:self.kTimeTheYAxisAtt[NSFontAttributeName] content:maxPriceStr limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize unitSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:self.kTimeTheYAxisAtt[NSFontAttributeName] content:unitStr limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize maxVolumeSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:self.kTimeTheYAxisAtt[NSFontAttributeName] content:volumeStr limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];

    leftWidth = MAX(leftWidth, maxPriceSize.width);
    leftWidth = MAX(leftWidth, unitSize.width);
    leftWidth = MAX(leftWidth, maxVolumeSize.width);

    leftWidth += priceDistanceLine;
    
    return leftWidth;
}



-(CGFloat )configureRightYAxisWidth{
    CGFloat rightWidth = 0;
    //最大振幅
    NSString * minRate = @"-10.02%";
    CGSize minRatePriceSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:self.kTimeTheYAxisAtt[NSFontAttributeName] content:minRate limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    rightWidth = minRatePriceSize.width;
    
    rightWidth += priceDistanceLine;
    
    return rightWidth;
}

//滑动手势
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    MyLog(@"滑动手势");
    
    if (self.chartType == ZNChartTimeLine) {
        MyLog(@"分时");
        return;
    }
    
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
         [self pop_removeAnimationForKey:@"decelerate"];
        self.tempPanCount = self.KlineStartIndex;
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        MyLog(@"滑动位置:%@",NSStringFromCGPoint(translation));
        NSInteger integer = [[NSString stringWithFormat:@"%0.f",fabs(translation.x)/5] integerValue];
        if (translation.x<0) {
            self.KlineStartIndex = self.tempPanCount + integer;
            if (self.KlineDataArray.count < self.numberOfKlineCanShow) {
                self.KlineStartIndex = 0;
            }else
            {
                if (self.KlineStartIndex>self.KlineDataArray.count-self.numberOfKlineCanShow) {
                    self.KlineStartIndex = self.KlineDataArray.count-self.numberOfKlineCanShow;
                }
            }
        }else
        {
            self.KlineStartIndex = self.tempPanCount - integer;
            if (self.KlineStartIndex<0) {
                self.KlineStartIndex = 0;
            }
        }
        
        [self prepareToDrawBecauseOfPinOrPich];
        
        
        
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if (self.chartType == ZNChartWeeklyKLine || self.chartType == ZNChartMonthlyKLine) {
            return;
        }
        
        
        if (self.KlineDataArray.count < self.numberOfKlineCanShow ||self.KlineStartIndex ==0) {
            return;
        }else
        {
            //                if (self.startDrawIndex == self.dataArray.count-self.chartWidth/self.candleWidth) {
            if (self.KlineStartIndex == (self.KlineDataArray.count-self.numberOfKlineCanShow)) {
                return;
            }
            CGPoint velocity = [gesture velocityInView:self];
            velocity.x = -velocity.x/10;
            velocity.y = 0;
            
            POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
            
            POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"com.rounak.bounds.origin" initializer:^(POPMutableAnimatableProperty *prop) {
                prop.readBlock = ^(id obj, CGFloat values[]) {
                    values[0] = self.KlineStartIndex;
                };
                prop.writeBlock = ^(id obj, const CGFloat values[]) {
                    NSInteger integer = [[NSString stringWithFormat:@"%0.f",values[0]] integerValue];
                    if (self.KlineStartIndex != integer) {
                        
                        if (integer <0) {
                            self.KlineStartIndex = 0;
                        }else
                        {
                            //                                if (self.dataArray.count < self.chartWidth/self.candleWidth) {
                            if (self.KlineDataArray.count < self.numberOfKlineCanShow) {
                                self.KlineStartIndex = 0;
                            }else
                            {
                                if (integer>self.KlineDataArray.count - self.numberOfKlineCanShow) {
                                    self.KlineStartIndex = self.KlineDataArray.count-self.numberOfKlineCanShow;
                                    [self prepareToDrawBecauseOfPinOrPich];
                                    
                                }else
                                {
                                    self.KlineStartIndex = integer;
                                }
                            }
                        }
                        self.tempDrawIndex = self.KlineStartIndex+self.numberOfKlineCanShow/2;
                        [self prepareToDrawBecauseOfPinOrPich];
                    }
                };
                prop.threshold = 0.01;
            }];
            decayAnimation.property = prop;
            decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            [self pop_addAnimation:decayAnimation forKey:@"decelerate"];
            [gesture setTranslation:CGPointMake(0, 0) inView:self];
        }
    }
    
}

- (void)prepareToDrawBecauseOfPinOrPich{
    [self resetConfigureBcauseOfPanOrPinch];
    [self calculateKlineRelevantData];
    [self drawKlineLineAndVolume];
}



- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gesture{
    MyLog(@"放大收缩");
    
    if (self.chartType == ZNChartTimeLine) {
        MyLog(@"分时");
        return;
    }
    


    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.KlineLandscapeVolumeWidth = gesture.scale *  self.KlineLandscapeVolumeWidth;
        
        if (self.KlineLandscapeVolumeWidth > self.canvasWidth/20) {
            self.KlineLandscapeVolumeWidth = self.canvasWidth/20;
        }
        
        if (self.KlineLandscapeVolumeWidth < candleMinWidth) {
            self.KlineLandscapeVolumeWidth = candleMinWidth;
        }
        
        self.KlineStartIndex = self.tempDrawIndex - self.numberOfKlineCanShow/2;
        
        if (self.KlineStartIndex+self.numberOfKlineCanShow>=self.KlineDataArray.count) {
            self.KlineStartIndex = self.KlineDataArray.count - self.numberOfKlineCanShow;
        }
        
        if (self.KlineDataArray.count < self.numberOfKlineCanShow) {
            self.KlineStartIndex = 0;
        }
        
        if (self.KlineStartIndex<0) {
            self.KlineStartIndex = 0;
        }
        
        
        
        if (labs(self.tempCount-self.numberOfKlineCanShow)>2) {
            [self resetConfigureBcauseOfPanOrPinch];
            [self calculateKlineRelevantData];
            [self drawKlineLineAndVolume];
            self.tempCount = self.numberOfKlineCanShow;
        }
        
        
    }


}


@end
