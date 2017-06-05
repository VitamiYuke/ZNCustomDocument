//
//  ZNVerticalScreenContainer.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNVerticalScreenContainer.h"
#import "ZNCustomChooseSelectedView.h"
#import "ZNVerticalScreenKline.h"
#import "ZNStockKlineModel.h"
#import "ZNStockTimeSharingModel.h"
#import "ZNKTimeHeaderView.h"
#import "ZNKlineHeaderView.h"
#import "ZNKlineLandscapeController.h"
#import "ZNKlineFiveBlockAndTheDetailsView.h"
@interface ZNVerticalScreenContainer ()<ZNCustomChoiceDelegate,ZNStockKlineLongPressProtocol>
@property(nonatomic, strong)ZNCustomChooseSelectedView *chooseView;
@property(nonatomic, strong)ZNVerticalScreenKline *KlineView;
@property(nonatomic, strong)ZNKTimeHeaderView *KTimeHeader;
@property(nonatomic, copy)NSString *yesterdayPrice;
@property(nonatomic, strong)ZNKlineHeaderView *KlineHeader;
@property(nonatomic, copy)NSString *stockCode;
@property(nonatomic, strong)ZNKlineFiveBlockAndTheDetailsView *fiveAndDetailsView;
@end

@implementation ZNVerticalScreenContainer

- (ZNCustomChooseSelectedView *)chooseView{
    if (!_chooseView) {
        _chooseView = [[ZNCustomChooseSelectedView alloc] initWithFrame:CGRectMake(0, 0, self.width, choiceNormalHeight) withTitles:@[@"分 时",@"日 K" ,@"周 K",@"月 K"] highlightColor:MyColor(249, 114, 110) normalColor:MyColor(153, 155, 154) choicedIndex:0];
        _chooseView.backgroundColor = MyColor(245, 247, 246);
        [_chooseView configureLineWihtIsHaveTop:YES isHaveBottom:YES lineColor:MyColor(218, 221, 222)];
        _chooseView.delegate = self;
    }
    return _chooseView;
}

- (ZNVerticalScreenKline *)KlineView{
    if (!_KlineView) {
        _KlineView = [[ZNVerticalScreenKline alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_KlineView configureDrawRelatedAttInfo];
        _KlineView.delegate = self;
        [_KlineView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickKlineAction:)]];
    }
    return _KlineView;
}


- (ZNKTimeHeaderView *)KTimeHeader{
    if (!_KTimeHeader) {
        _KTimeHeader = [[ZNKTimeHeaderView alloc] initWithFrame:CGRectMake(0, 0.5, SCREENT_WIDTH, choiceNormalHeight + 9) isLandscape:NO];
        _KTimeHeader.hidden = YES;
    }
    return _KTimeHeader;
}

- (ZNKlineHeaderView *)KlineHeader{
    if (!_KlineHeader) {
        _KlineHeader = [[ZNKlineHeaderView alloc] initWithFrame:CGRectMake(0, 0.5, SCREENT_WIDTH, choiceNormalHeight + 9) isLandscape:NO];
        _KlineHeader.hidden = YES;
    }
    return _KlineHeader;
}

- (ZNKlineFiveBlockAndTheDetailsView *)fiveAndDetailsView{
    if (!_fiveAndDetailsView) {
        _fiveAndDetailsView = [[ZNKlineFiveBlockAndTheDetailsView alloc] init];
        _fiveAndDetailsView.isLandscape = NO;
        _fiveAndDetailsView.hidden = YES;
    }
    return _fiveAndDetailsView;
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
    [self.KlineView configureDrawCanvasFrameFromEdgeInsets:UIEdgeInsetsMake(canvasMargin + choiceNormalHeight, canvasMargin, canvasMargin, canvasMargin)];
    
    [self addSubview:self.chooseView];
    
    [self addSubview:self.KTimeHeader];
    [self addSubview:self.KlineHeader];
    
    
    [self addSubview:self.fiveAndDetailsView];
    [self.fiveAndDetailsView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:canvasMargin];
    [self.fiveAndDetailsView autoSetDimension:ALDimensionWidth toSize:fiveBlockWidth];
    [self.fiveAndDetailsView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:canvasMargin];
    [self.fiveAndDetailsView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(canvasMargin + choiceNormalHeight)];
    
 
}

#pragma mark - 选择切换的代理
- (void)ZNCustomSelectedViewChoiceTitle:(NSString *)title index:(NSInteger)index{
    [self.KlineView configureChangeChoiceWithTitle:title];
}

- (void)startLoadingStockKlineDataWithStockCode:(NSString *)stockCode YesterdayClosingPrice:(NSString *)YesterdayClosingPrice{
    self.yesterdayPrice = YesterdayClosingPrice;
    self.stockCode = stockCode;
    
    
    if (!self.KlineView.chartType) {
        self.KlineView.chartType = ZNChartTimeLine;
    }
    
    if (self.KlineView.chartType != ZNChartTimeLine) {
        MyLog(@"不是分时数据不用一直刷新");
        return;
    }
    
    
    [self.KlineView loadingklineDataWithStockCode:stockCode YesterdayClosingPrice:[YesterdayClosingPrice floatValue] KlineType:ZNChartTimeLine];
    
    
    self.fiveAndDetailsView.hidden = YES;
    if (![ZNStockBasedConfigureLib isIndexWithStockCode:stockCode]) {
        self.fiveAndDetailsView.hidden = NO;
        [self.fiveAndDetailsView startLoadingFiveBlockDataWithStockCode:stockCode yesterdayPrice:YesterdayClosingPrice];
    }
    
    
}
#pragma mark - 长按的代理
- (void)ZNKTimeLongPressPointShowWithTimeSharingModel:(ZNStockTimeSharingModel *)timeSharingModel//分时
{
    MyLog(@"当前的价格:%@  时间:%@",timeSharingModel.price,timeSharingModel.time);
    
    
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
    if (charType == ZNChartTimeLine && ![ZNStockBasedConfigureLib isIndexWithStockCode:self.stockCode]) {
        self.fiveAndDetailsView.hidden = NO;
        [self.fiveAndDetailsView startLoadingFiveBlockDataWithStockCode:self.stockCode yesterdayPrice:self.yesterdayPrice];
    }
}


- (void)dealloc{
    MyLog(@"竖屏K线销毁:%@",self);
}


#pragma mark - 点击跳转的方法

- (void)clickKlineAction:(UITapGestureRecognizer *)gesture{
    
    NSMutableArray *dataArray = self.KlineView.currentDataArray;
    if (dataArray.count == 0) {
        MyLog(@"没有数据源");
        return;
    }
    
    UIViewController *currentControlelr = [ZNRegularHelp getViewControllerWithOriginView:self];
    
    CGPoint controllerPoint = [gesture locationInView:currentControlelr.view];
    MyLog(@"当前控制器的位置:%@",NSStringFromCGPoint(controllerPoint));
    CGFloat touchY = controllerPoint.y;
    if (currentControlelr.navigationController && !currentControlelr.navigationController.navigationBar.hidden) {
        touchY += 64;
    }
    ZNKlineLandscapeController *landscapeController = [[ZNKlineLandscapeController alloc] init];
    landscapeController.touchPoint = CGPointMake(controllerPoint.x, touchY);
    landscapeController.dataArray = self.KlineView.currentDataArray;
    landscapeController.chartType = self.KlineView.chartType;
    landscapeController.yesterdayClosingPrice = self.yesterdayPrice;
    landscapeController.stockCode = self.stockCode;
    [currentControlelr presentViewController:landscapeController animated:YES completion:^{
        
    }];
    
}

- (void)cancelNetworkRequest{
    [self.KlineView.dataTask cancel];
}






@end
