//
//  ZNKlineBasedConfigure.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineCanvas.h"


@class ZNStockTimeSharingModel;
@class ZNStockKlineModel;

@protocol ZNStockKlineLongPressProtocol <NSObject>

@optional

//开始长按
- (void)ZNLongPressStartWithCharType:(ZNChartType )charType;
//分时
-(void)ZNKTimeLongPressPointShowWithTimeSharingModel:(ZNStockTimeSharingModel *)timeSharingModel;
-(void)ZNKlineLongPressPointShowWithKlineModel:(ZNStockKlineModel *)KlineModel beforeClosePrice:(CGFloat )beforeClosePrice;
//长按结束
- (void)ZNLongPressEnd;

//切换的统计
- (void)ZNKlineChangeWithCharType:(ZNChartType )charType;



@end


@interface ZNKlineBasedConfigure : ZNKlineCanvas

@property (nonatomic, assign) CGFloat maxPrice;
@property (nonatomic, assign) CGFloat minPrice;
@property (nonatomic, assign) NSInteger maxVolum;
@property (nonatomic, assign) CGFloat rate;//振幅
@property (nonatomic, assign) CGFloat YesterdayClosingPrice;//昨天收盘价格
@property(nonatomic, copy)NSString *stockCode;//股票代码
@property(nonatomic, weak)id<ZNStockKlineLongPressProtocol>delegate;

//请求的数据
@property(nonatomic, strong)NSMutableArray *KlineDataArray;//K线数据
@property(nonatomic, strong)NSMutableArray *KTimeDataArray;//分时的数据
@property(nonatomic, strong)CALayer *StockKTimeOrlinMainLayer;//画图的主要
//时间转换戳
@property(nonatomic, strong)NSDateFormatter *KTimeFormatter;
//分时线
//k线
@property(nonatomic, assign)NSInteger KlineStartIndex;
//请求的任务
@property(nonatomic, weak)NSURLSessionDataTask *dataTask;


//手势
@property(nonatomic, strong)UILongPressGestureRecognizer *longPressGesture;

@property(nonatomic, assign)BOOL isLandscape;//是否是横屏 默认不是

//画坐标轴 竖屏
- (void)drawStockKlineCoordinateWithContext:(CGContextRef )context withIsLandscape:(BOOL )isLandscape;
//画分时的时间轴
- (void)drawKTimeTheXAxisWithContext:(CGContextRef )context;
//价格的单位高度 成交量
- (CGFloat )configurePriceUnitHeight;
- (CGFloat )configureVolumeUnitHeight;
- (CGFloat )configurePriceDifference;
//K线X轴刻度宽度
- (CGSize )configureKlineXAxisDescSize;
//K线距离K线画板上下间距
- (CGFloat )configureKlineYAxisPadding;


////K线的刻度
//- (void)configureKlineXAxisWithPointArray:(NSArray *)pointArray descArray:(NSArray *)descArray superLayer:(CALayer *)superLayer;
#pragma mark -- 竖屏和横屏公用
//k线长按均线的显示
- (void)configureMaxAndMinPriceIsShow:(BOOL )isShow;
//长按军线的价格大小
- (CGSize )configureLongPressMaSize;
//配置 分时的相关数据 和K线的相关数据
- (void)calculateKTimeRelevantData;
- (void)calculateKlineRelevantData;
- (void)loadingklineDataWithStockCode:(NSString *)stockCode
                YesterdayClosingPrice:(CGFloat )YesterdayClosingPrice
                            KlineType:(ZNChartType )chartType;
- (void)prepareToDraw;
//切换的操作
- (void)configureChangeChoiceWithTitle:(NSString *)typeTitle;
//画分时
- (void)drawKTimeLineAndVolume;
- (void)drawKlineLineAndVolume;
//根据数组的位置判断长按点的位置
- (CGPoint )KTimePricePointLocationWithIndexInPoints:(NSInteger )index;
- (CGPoint )KlineClosePricePointLocationWithIndexInPoints:(NSInteger )index;
//横屏
//K线的成交量宽带
- (CGFloat )KlineVolumeUnitWidth;
//切换的处理
- (void)resetSubConfigureBecauseOfChangeChoice;
//横屏的阴阳线宽度
@property(nonatomic, assign)CGFloat KlineLandscapeVolumeWidth;
- (NSInteger )numberOfKlineCanShow;
//k线的宽度
- (CGFloat )KlineFinalVolumeWidth;
@property(nonatomic, assign)NSInteger tempDrawIndex;
//重置最大值
- (void)resetConfigureBcauseOfPanOrPinch;





@end
