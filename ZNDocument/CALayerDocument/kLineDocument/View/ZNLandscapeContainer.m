//
//  ZNLandscapeContainer.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNLandscapeContainer.h"
#import "ZNLandscapeKline.h"
#import "ZNStockTimeSharingModel.h"
#import "ZNStockKlineModel.h"
#import "ZNKTimeHeaderView.h"
#import "ZNKlineHeaderView.h"
#import "ZNKlineFiveBlockAndTheDetailsView.h"
#import "ZNKlineLandscapeOperationView.h"
@interface ZNLandscapeContainer ()<ZNCustomChoiceDelegate,ZNStockKlineLongPressProtocol,ZNKlineOperationChangeDelegate>
@property(nonatomic, strong)ZNCustomChooseSelectedView *chooseView;
@property(nonatomic, strong)ZNLandscapeKline *KlineView;
@property(nonatomic, strong)ZNKTimeHeaderView *KTimeHeader;
@property(nonatomic, strong)ZNKlineHeaderView *KlineHeader;
@property(nonatomic, copy)NSString *yesterdayPrice;
@property(nonatomic, strong)ZNKlineFiveBlockAndTheDetailsView *fiveAndDetailsView;
@property(nonatomic, strong)ZNKlineLandscapeOperationView *operationView;
@property(nonatomic, copy)NSString *stockCode;
@end


@implementation ZNLandscapeContainer


- (ZNCustomChooseSelectedView *)chooseView{
    if (!_chooseView) {
        _chooseView = [[ZNCustomChooseSelectedView alloc] initWithFrame:CGRectMake(0, self.height - choiceFullScreenHeight, self.width, choiceFullScreenHeight) withTitles:@[@"分 时",@"日 K" ,@"周 K",@"月 K"] highlightColor:MyColor(249, 114, 110) normalColor:MyColor(153, 155, 154) choicedIndex:0];
        _chooseView.backgroundColor = MyColor(245, 247, 246);
        [_chooseView configureLineWihtIsHaveTop:YES isHaveBottom:YES lineColor:MyColor(218, 221, 222)];
        _chooseView.delegate = self;
    }
    return _chooseView;
}

- (ZNLandscapeKline *)KlineView{
    if (!_KlineView) {
        _KlineView = [[ZNLandscapeKline alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_KlineView configureDrawRelatedAttInfo];
        _KlineView.delegate = self;
    }
    return _KlineView;
}

- (ZNKTimeHeaderView *)KTimeHeader{
    if (!_KTimeHeader) {
        _KTimeHeader = [[ZNKTimeHeaderView alloc] initWithFrame:CGRectMake(0, 0.5, SCREENT_WIDTH, choiceFullScreenHeight - 1) isLandscape:YES];
        _KTimeHeader.hidden = YES;
    }
    return _KTimeHeader;
}

- (ZNKlineHeaderView *)KlineHeader{
    if (!_KlineHeader) {
        _KlineHeader = [[ZNKlineHeaderView alloc] initWithFrame:CGRectMake(0, 0.5, SCREENT_WIDTH, choiceFullScreenHeight - 1) isLandscape:YES];
        _KlineHeader.hidden = YES;
    }
    return _KlineHeader;
}

- (ZNKlineFiveBlockAndTheDetailsView *)fiveAndDetailsView{
    if (!_fiveAndDetailsView) {
        _fiveAndDetailsView = [[ZNKlineFiveBlockAndTheDetailsView alloc] init];
        _fiveAndDetailsView.hidden = YES;
        _fiveAndDetailsView.isLandscape = NO;
    }
    return _fiveAndDetailsView;
}

- (ZNKlineLandscapeOperationView *)operationView{
    if (!_operationView) {
        _operationView = [[ZNKlineLandscapeOperationView alloc] init];
        _operationView.hidden = YES;
        _operationView.delegate  = self;
    }
    return _operationView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.KlineView];
    [self.KlineView configureDrawCanvasFrameFromEdgeInsets:UIEdgeInsetsMake(choiceFullScreenHeight, canvasMargin, canvasMargin + choiceFullScreenHeight, canvasMargin)];
    [self addSubview:self.chooseView];
    [self addSubview:self.KTimeHeader];
    [self addSubview:self.KlineHeader];
    
    [self addSubview:self.fiveAndDetailsView];
    [self.fiveAndDetailsView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:canvasMargin];
    [self.fiveAndDetailsView autoSetDimension:ALDimensionWidth toSize:fiveBlockWidth];
    [self.fiveAndDetailsView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:(canvasMargin + choiceFullScreenHeight)];
    [self.fiveAndDetailsView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(choiceFullScreenHeight)];
    
    [self addSubview:self.operationView];
    [self.operationView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:canvasMargin];
    [self.operationView autoSetDimension:ALDimensionWidth toSize:40];
    [self.operationView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:(canvasMargin + choiceFullScreenHeight)];
    [self.operationView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(choiceFullScreenHeight)];
    
    

}


#pragma mark - 选择切换的代理
- (void)ZNCustomSelectedViewChoiceTitle:(NSString *)title index:(NSInteger)index{
    [self.KlineView configureChangeChoiceWithTitle:title];
}

#pragma mark - 长按的代理
- (void)ZNKTimeLongPressPointShowWithTimeSharingModel:(ZNStockTimeSharingModel *)timeSharingModel//分时
{
    CGFloat yesPrice = 0;
    if (self.yesterdayPrice && [self.yesterdayPrice isKindOfClass:[NSString class]]) {
        yesPrice = [self.yesterdayPrice floatValue];
    }
    
    [self.KTimeHeader refreshShowTimeSharingModelWithModel:timeSharingModel yesterdayPrice:yesPrice];
    
    
}

- (void)ZNLongPressEnd{
    MyLog(@"结束长按");
    self.KTimeHeader.hidden = YES;
    self.KlineHeader.hidden = YES;
}

- (void)ZNLongPressStartWithCharType:(ZNChartType)charType{
    MyLog(@"开始长按");
    if (charType == ZNChartTimeLine) {
        self.KTimeHeader.hidden = NO;
    }else{
        self.KlineHeader.hidden = NO;
    }
    
}
- (void)ZNKlineLongPressPointShowWithKlineModel:(ZNStockKlineModel *)KlineModel  beforeClosePrice:(CGFloat)beforeClosePrice//k线
{
    [self.KlineHeader refreshShowTimeSharingModelWithModel:KlineModel beforeClosePrice:beforeClosePrice];
}


- (void)ZNKlineChangeWithCharType:(ZNChartType)charType{
    self.fiveAndDetailsView.hidden = YES;
     self.operationView.hidden = YES;
    
    if ([ZNStockBasedConfigureLib isIndexWithStockCode:self.stockCode]) {
        MyLog(@"大盘数据当当当动");
        return;
    }
    
    if (charType == ZNChartTimeLine) {
        self.fiveAndDetailsView.hidden = NO;
        [self.fiveAndDetailsView startLoadingFiveBlockDataWithStockCode:self.stockCode yesterdayPrice:self.yesterdayPrice];
    }else{
       self.operationView.hidden = NO;
    }
}



- (void)dealloc{
    MyLog(@"横屏K线销毁:%@",self);
}


- (void)getKlineDataFromVerticalScreenWithArray:(NSMutableArray *)dataArray chartType:(ZNChartType)chartType stockCode:(NSString *)stockCode yesterdayClosingPrice:(NSString *)yesterdayClosingPrice{
    self.yesterdayPrice = yesterdayClosingPrice;
    self.stockCode = stockCode;
    //配置选择
    switch (chartType) {
        case ZNChartTimeLine:
            [self.chooseView refreshSelectedTypeWithIndex:0];
            break;
        case ZNChartDailyKLine:
            [self.chooseView refreshSelectedTypeWithIndex:1];
            break;
        case ZNChartWeeklyKLine:
            [self.chooseView refreshSelectedTypeWithIndex:2];
            break;
        case ZNChartMonthlyKLine:
            [self.chooseView refreshSelectedTypeWithIndex:3];
            break;
        default:
            break;
    }

    [self.KlineView configureStockKlineDataWithArray:dataArray chartType:chartType stockCode:stockCode yesterdayClosingPrice:yesterdayClosingPrice];
    
    
    if ([ZNStockBasedConfigureLib isIndexWithStockCode:self.stockCode]) {
        return;
    }
    
    if (chartType == ZNChartTimeLine ) {
        self.fiveAndDetailsView.hidden = NO;
        [self.fiveAndDetailsView startLoadingFiveBlockDataWithStockCode:stockCode yesterdayPrice:yesterdayClosingPrice];
    }else{
        self.operationView.hidden = NO;
    }
    
    
}

#pragma mark - 复权调整
- (void)ZNKlineOperationHaveChanged{
    
    [self.KlineView loadingklineDataWithStockCode:self.stockCode YesterdayClosingPrice:[self.yesterdayPrice floatValue] KlineType:self.KlineView.chartType];
}




@end
