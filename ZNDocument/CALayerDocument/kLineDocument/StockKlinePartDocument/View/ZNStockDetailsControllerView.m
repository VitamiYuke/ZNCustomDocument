//
//  ZNStockDetailsControllerView.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/10.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNStockDetailsControllerView.h"
#import "ZNSearchStockModel.h"
#import "ZNStockDetailsCustomNavView.h"
#import "ZNStockDetailsInfoToolManager.h"
#import "ZNStockDetailsHeaderView.h"
#import "ZNStockDetailsInfoModel.h"
#import "ZNStockDetailsView.h"
@interface ZNStockDetailsControllerView ()<ZNStockDetailsHeaderDelegate>
@property(nonatomic, strong)ZNStockDetailsCustomNavView *navView;
@property(nonatomic, strong)ZNSearchStockModel *stockModel;
@property(nonatomic, strong)NSDateFormatter *timeDateFormatter;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)ZNStockDetailsHeaderView *headerView;
@property(nonatomic, strong)ZNStockDetailsInfoModel *detailsInfoModel;
@property(nonatomic, strong)UIVisualEffectView *effectView;
@property(nonatomic, strong)ZNStockDetailsView *stockDetailsView;
@end



@implementation ZNStockDetailsControllerView{
    CGFloat _maxDetailsShowHeight;
}

- (ZNStockDetailsInfoModel *)detailsInfoModel{
    if (!_detailsInfoModel) {
        _detailsInfoModel = [[ZNStockDetailsInfoModel alloc] init];
    }
    return _detailsInfoModel;
}


- (UIView *)stockDetailsView{
    if (!_stockDetailsView) {
        _stockDetailsView = [[ZNStockDetailsView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, 0)];
        _stockDetailsView.backgroundColor = [UIColor whiteColor];
    }
    return _stockDetailsView;
}

- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _effectView.backgroundColor = [UIColor clearColor];
        _effectView.hidden = YES;
        _effectView.alpha = 0;
        [_effectView addSubview:self.stockDetailsView];
        [_effectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShowStockDetailsInfo)]];
    }
    return _effectView;
}

#pragma mark - 毛玻璃效果的结束
- (void)cancelShowStockDetailsInfo{
    [self.headerView resetRightIconConfigure];
}

#pragma mark --

- (ZNStockDetailsCustomNavView *)navView{
    if (!_navView) {
        _navView = [[ZNStockDetailsCustomNavView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, 64)];
        _navView.backgroundColor = Stock_Red;
    }
    return _navView;
}

- (NSDateFormatter *)timeDateFormatter{
    if (!_timeDateFormatter) {
        _timeDateFormatter = [[NSDateFormatter alloc] init];
        [_timeDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_timeDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_timeDateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    }
    return _timeDateFormatter;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setTableHeaderView:self.headerView];
        [_tableView setTableFooterView:[UIView new]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = Stock_Red;
        
    }
    return _tableView;
}

- (ZNStockDetailsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ZNStockDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, Stock_Details_Default_Height)];
        _headerView.backgroundColor = Stock_Red;
        _headerView.delegate = self;
    }
    return _headerView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    [self addSubview:self.navView];
    [self addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0)];
    
    [self addSubview:self.effectView];
    [self.effectView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64 + (Stock_Details_Default_Height - 305), 0, 0, 0)];
    
    
    
}



- (void)startLoadingDataWithStockInfo:(ZNSearchStockModel *)stockModel{
    self.stockModel = stockModel;
    self.headerView.stockModel = self.stockModel;
    self.navView.stockModel = self.stockModel;
    BOOL isMarktData = [ZNStockDetailsInfoToolManager isIndexWithStockCode:self.stockModel.stockCode];
    self.stockDetailsView.isTheBroaderMarket = isMarktData;
    _maxDetailsShowHeight = Each_Row_Height * (isMarktData?1:4);
//    [self autoRefreshMarketData];
    [self loadingStockDetailsInfoData];
    if (!isMarktData) {
        [self loadingStockFinanceInfoData];
        [self loadingInAndOutSideDishData];
    }
    
}



#pragma mark - 内部方法 请求详情数据
- (void)loadingStockDetailsInfoData{
    if (!self.stockModel) {
        return;
    }
    [ZNStockDetailsInfoToolManager getStockDetailsInfoWithStockCode:self.stockModel.stockCode OrStocksArray:nil Success:^(id responseObject) {
        NSString *stockInto = responseObject[self.stockModel.stockCode];
        if (stockInto.length) {
            self.detailsInfoModel = [ZNStockDetailsInfoToolManager configureStockDetailsInfoWithDataString:stockInto originalData:self.detailsInfoModel];
            self.detailsInfoModel.date = [self.timeDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.detailsInfoModel.dataStringArray[34] integerValue]]];
            self.detailsInfoModel.time = [self.timeDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.detailsInfoModel.dataStringArray[35] integerValue]]];
            self.headerView.detailsModel = self.detailsInfoModel;
            self.navView.detaisDescString = self.detailsInfoModel.date;
            [self configureBGColorWithDetailsModel:self.detailsInfoModel];
        }
    } Failure:^{
        
    }];
    
}

//内外盘的数据
- (void)loadingInAndOutSideDishData{
    [ZNStockDetailsInfoToolManager getStockInSideAndOutSideDishWithStockCode:self.stockModel.stockCode Success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if (responseDic.count == 3) {
            self.detailsInfoModel.insideDish = [NSString stringWithFormat:@"%@",responseDic[@"s"]];
            self.detailsInfoModel.outsideDish = [NSString stringWithFormat:@"%@",responseDic[@"b"]];  
        }
    } Failure:^{
        
    }];
}

//融资信息
- (void)loadingStockFinanceInfoData{
    [ZNStockDetailsInfoToolManager getStockFinanceWithStockCode:self.stockModel.stockCode Success:^(id responseObject) {
        
    } Failure:^{
        
    }];
}




#pragma mark - 定时刷新行情数据
- (void)autoRefreshMarketData{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoRefreshMarketData) object:nil];
    if ([ZNBasedStockToolManager isWhetherStockTradingTime]){[self loadingStockDetailsInfoData];}
    [self performSelector:@selector(autoRefreshMarketData) withObject:nil afterDelay:10];
}



- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    MyLog(@"股票详情页销毁:%@",self);
}


- (void)configureBGColorWithDetailsModel:(ZNStockDetailsInfoModel *)detailsModel{
    
    if ([detailsModel.forehead floatValue] > 0) {
        self.navView.backgroundColor = Stock_Red;
        self.tableView.backgroundColor = Stock_Red;
        self.headerView.backgroundColor = Stock_Red;
    }else if ([detailsModel.forehead floatValue] < 0){
        self.navView.backgroundColor = Stock_Green;
        self.tableView.backgroundColor = Stock_Green;
        self.headerView.backgroundColor = Stock_Green;
    }else{
        self.navView.backgroundColor = Stock_Gray;
        self.tableView.backgroundColor = Stock_Gray;
        self.headerView.backgroundColor = Stock_Gray;
    }
}

#pragma mark - 头部代理
- (void)ZNStockDetailsHeaderView:(ZNStockDetailsHeaderView *)headerView didChangeLookDetailsState:(BOOL)isLookDetails{
    MyLog(@"查看:%d",isLookDetails);
    if (isLookDetails) {
        MyLog(@"查看");
        self.tableView.scrollEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.effectView.hidden = NO;
            self.effectView.alpha = 1;
            self.stockDetailsView.height = _maxDetailsShowHeight;
        } completion:^(BOOL finished) {
            if (finished) {
                self.stockDetailsView.stockDetailsInfoModel = self.detailsInfoModel;
            }
        }];
        
    }else{
        MyLog(@"不看🙈");
        [UIView animateWithDuration:0.3 animations:^{
            self.stockDetailsView.height = 0;
            self.effectView.alpha = 0;
        } completion:^(BOOL finished) {
            self.effectView.hidden = YES;
            self.tableView.scrollEnabled = YES;
        }];

    }
    
}













@end
