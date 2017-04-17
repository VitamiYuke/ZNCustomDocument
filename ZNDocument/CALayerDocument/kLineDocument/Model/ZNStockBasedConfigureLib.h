//
//  ZNStockBasedConfigureLib.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNBasedStockToolManager.h"


//画线的配置
//    分时最后一个点的大小 
#define KTimeEndPointSize 4
//      十字线宽度
#define highlightLineWidth 1.0
//      十字线颜色
#define highlightLineColor [UIColor colorWithRed:84/255.0 green:105/255.0 blue:128/255.0 alpha:1.0]
//      分时线宽
#define timeLineWidth 1.0
//      分时均价颜色
#define avgPrineLineColor [UIColor colorWithRed:253/255.0 green:179/255.0 blue:8/255.0 alpha:1.0]
//      分时线颜色
#define timePriceLineColor [UIColor colorWithRed:59/255.0 green:127/255.0 blue:237/255.0 alpha:1.0]
//      边框线宽
#define myBorderWidth .5
//      边框颜色
#define myBorderColor [UIColor colorWithRed:211/255.0 green:221/255.0 blue:228/255.0 alpha:1.0]

//      圆点距离
#define roundDistance 10

//      圆点的宽度
#define roundWidth 3

//      圆点距离文字
#define roundDistabceAttrStr 5
//      画线区域占比
#define lineAccountedHeight 0.7
//      阴阳线最小宽度
#define candleMinWidth 3
//      折线图范围与成交量范围的间距
#define xAxisHeitht 15
//      红色线
#define lineColorWithRed (Stock_Red)
//      灰色线
#define lineColorWithGray (Stock_Gray)
//      绿色线
#define lineColorWithGreen (Stock_Green)
//      5日平均颜色
#define ma5LineColor [UIColor colorWithRed:249/255.0 green:216/255.0 blue:77/255.0 alpha:1.0]
//      10日平均颜色
#define ma10LineColor [UIColor colorWithRed:77/255.0 green:185/255.0 blue:247/255.0 alpha:1.0]
//      20日平均颜色
#define ma20LineColor [UIColor colorWithRed:253/255.0 green:118/255.0 blue:207/255.0 alpha:1.0]
//      价格显示的位置离线的距离
#define priceDistanceLine 1.5

//选择框的高度
#define choiceNormalHeight 35//竖屏
#define choiceFullScreenHeight 40//全屏

//绘制区域的边界
#define canvasMargin 10
//五挡的宽度
#define fiveBlockWidth 100


typedef NS_ENUM(NSInteger, ZNChartType) {
    //分时
    ZNChartTimeLine = 6,
    //K线
    ZNChartDailyKLine =7,
    ZNChartWeeklyKLine =8,
    ZNChartMonthlyKLine =9
};


typedef NS_ENUM(NSInteger, ZNScreenDirection) {
    ZNScreenDirectionVertical = 6,//竖屏
    ZNScreenDirectionLandscape = 7//横屏
};


@interface ZNStockBasedConfigureLib : ZNBasedStockToolManager


//请求分时数据
+(NSURLSessionDataTask *)getStockTimeSharingDateWithStockCode:(NSString *)stockCode
                                    success:(void(^)(id responseObject))succ
                                    failure:(void(^)(void))fail;




//请求K线的数据
+(NSURLSessionDataTask *)getStockKlineDataWithStockCode:(NSString *)stockCode
                                kType:(ZNChartType )kType //daily weekly monthly
                              success:(void(^)(id responseObject))succ
                              failure:(void(^)(void))fail;





//五挡和明细的数据
+(NSURLSessionTask *)getStockKlineFiveBlockDataWithStockCode:(NSString *)stockCode
                                                     success:(void(^)(id responseObject))succ
                                                     failure:(void(^)(void))fail;
//明细
+(NSURLSessionTask *)getStockKlineTheDetailDataWithStockCode:(NSString *)stockCode
                                                     success:(void(^)(id responseObject))succ
                                                     failure:(void(^)(void))fail;




@end
