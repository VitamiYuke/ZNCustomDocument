//
//  ZNKlineFiveBlockAndTheDetailsView.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineFiveBlockAndTheDetailsView.h"
#import "ZNKlineFiveBlockAndDetailsCell.h"
#import "ZNStockBasedConfigureLib.h"

typedef NS_ENUM(NSInteger, ZNFiveOrDetailsType) {
    ZNFiveOrDetailsTypeFiveBlock = 6,
    ZNFiveOrDetailsTypeTheDetail =7,
};


@interface ZNKlineFiveBlockAndTheDetailsView ()<UITableViewDelegate,UITableViewDataSource>{
    CGRect _oldRect;
    CGRect _newRect;
}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UIButton *topChoiceAction;
//请求的任务
@property(nonatomic, weak)NSURLSessionDataTask *dataTask;
@property(nonatomic, assign)ZNFiveOrDetailsType operationType;
@property(nonatomic, copy)NSString *stockCode;
@property(nonatomic, copy)NSString *yesterdayClosingPrice;
@property(nonatomic, strong)CATextLayer *fiveBlockLabel;
@property(nonatomic, strong)CATextLayer *theDetailsLabel;
@property(nonatomic, strong)CALayer *backLayer;
@end



@implementation ZNKlineFiveBlockAndTheDetailsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CATextLayer *)fiveBlockLabel{
    if (!_fiveBlockLabel) {
        // 35 125 251
        _fiveBlockLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:MyColor(35, 125, 251) font:ZNCustomDinNormalFont(10) textAlignment:NSTextAlignmentCenter isWrapped:NO orAttString:nil layerFrame:CGRectZero];
        _fiveBlockLabel.string = @"五挡";
        _fiveBlockLabel.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _fiveBlockLabel;
}

- (CATextLayer *)theDetailsLabel{
    if (!_theDetailsLabel) {
        _theDetailsLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:MyColor(112, 127, 139) font:ZNCustomDinNormalFont(10) textAlignment:NSTextAlignmentCenter isWrapped:NO orAttString:nil layerFrame:CGRectZero];
        _theDetailsLabel.string = @"明细";
        _theDetailsLabel.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _theDetailsLabel;
}

- (CALayer *)backLayer{
    if (!_backLayer) {
        _backLayer = [CALayer layer];
        _backLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [_backLayer setBorderColor:MyColor(35, 125, 251).CGColor];
        [_backLayer setBorderWidth:0.5];
        
    }
    return _backLayer;
}


- (UIButton *)topChoiceAction{
    if (!_topChoiceAction) {
        _topChoiceAction = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_topChoiceAction.layer setBorderColor:MyColor(213, 223, 223).CGColor];
        [_topChoiceAction.layer setBorderWidth:0.5];
        [_topChoiceAction addTarget:self action:@selector(userToChangeAction) forControlEvents:UIControlEventTouchUpInside];
        _topChoiceAction.layer.backgroundColor = MyColor(240, 244, 250).CGColor;
        
        
        
    }
    return _topChoiceAction;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setEstimatedRowHeight:20];
        [_tableView setRowHeight:20];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userToChangeAction)]];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (instancetype)init{
    if ([super init]) {
        _operationType = ZNFiveOrDetailsTypeFiveBlock;//五挡
    }
    return self;
}

- (void)setIsLandscape:(BOOL)isLandscape{
    _isLandscape = isLandscape;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self configureUI];
}

- (void)configureUI{
    
    [self addSubview:self.topChoiceAction];
    [self addSubview:self.tableView];
    
    
    CGFloat topHeight = 20;
    CGFloat leftMairgin = 10;
    if (self.isLandscape) {
        topHeight = 30;
        leftMairgin = 0;
    }
    
    
    [self.topChoiceAction autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:leftMairgin];
    [self.topChoiceAction autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.topChoiceAction autoSetDimension:ALDimensionHeight toSize:topHeight];
    [self.topChoiceAction autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(topHeight, leftMairgin, 0, 0)];
    
    
    CGFloat unitWidth = (fiveBlockWidth - leftMairgin)/2;
    
    
    _oldRect = CGRectMake(0.5, 0.5, unitWidth - 0.5, topHeight - 1);
    _newRect = CGRectMake(unitWidth, 0.5, unitWidth - 0.5, topHeight - 1);
    self.backLayer.frame = _oldRect;
    [self.topChoiceAction.layer addSublayer:self.backLayer];
    
    
    CGSize tipsZise = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinNormalFont(10) content:@"五挡" limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.fiveBlockLabel.frame = CGRectMake(0, topHeight/2 - tipsZise.height/2, unitWidth, tipsZise.height);
    self.theDetailsLabel.frame = CGRectMake(unitWidth, topHeight/2 - tipsZise.height/2, unitWidth, tipsZise.height);
    [self.topChoiceAction.layer addSublayer:self.fiveBlockLabel];
    [self.topChoiceAction.layer addSublayer:self.theDetailsLabel];
    
    
}




- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.operationType == ZNFiveOrDetailsTypeFiveBlock) {
        return self.dataArray.count;
    }
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.operationType == ZNFiveOrDetailsTypeFiveBlock) {
        id obj = self.dataArray[section];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)obj;
            return array.count;
        }
        return 0;
    }
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZNKlineFiveBlockAndDetailsCell *cell = [ZNKlineFiveBlockAndDetailsCell getZNKlineFiveBlockAndDetailsCellWithTableView:tableView];
    
    if (self.operationType == ZNFiveOrDetailsTypeFiveBlock) {
        cell.fiveBlockModel = self.dataArray[indexPath.section][indexPath.row];
    }
    
    if (self.operationType == ZNFiveOrDetailsTypeTheDetail) {
        cell.detailsModel = self.dataArray[indexPath.row];
    }
    
    return cell;;
}


- (void)dealloc{
    MyLog(@"五挡明细销毁:%@",self);
}


- (void)startLoadingFiveBlockDataWithStockCode:(NSString *)stockCode yesterdayPrice:(NSString *)yesterdayPrice{
    
    self.stockCode = stockCode;
    self.yesterdayClosingPrice = yesterdayPrice;
    if (self.dataTask) {
        [self.dataTask cancel];
    }
    
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    if (self.operationType == ZNFiveOrDetailsTypeFiveBlock) {//五挡
        
        
        [ZNStockBasedConfigureLib getStockKlineFiveBlockDataWithStockCode:stockCode success:^(id responseObject) {
            
            NSDictionary* dictary = responseObject;
            NSString* str = [dictary valueForKey:stockCode];
            if (!(strIsEmpty(str))) {
                NSArray* array = [str componentsSeparatedByString:@","];
                NSMutableArray* buyArray = [[NSMutableArray alloc] init];
                NSMutableArray* sellArray = [[NSMutableArray alloc] init];
                for (int i =0; i <10; i++) {
                    ZNStockFiveBlockModel* fiveModel = [[ZNStockFiveBlockModel alloc] init];
                    if (i<5) {
                        fiveModel.title = [NSString stringWithFormat:@"买%d",i+1];
                        fiveModel.price = [NSString stringWithFormat:@"%.2f",[array[i+11] floatValue]];
                        fiveModel.volum = array[i+16];
                        if ([fiveModel.price floatValue]<[array[1] floatValue]) {
                            fiveModel.color = MyColor(33, 179, 77);
                        }else if([fiveModel.price floatValue]>[array[1] floatValue])
                        {
                            fiveModel.color = MyColor(233, 47, 68);
                        }else
                        {
                            fiveModel.color = [UIColor grayColor];
                        }
                        [buyArray addObject:fiveModel];
                    }else
                    {
                        fiveModel.title = [NSString stringWithFormat:@"卖%d",i-4];
                        fiveModel.price = [NSString stringWithFormat:@"%.2f",[array[i+16] floatValue]];
                        fiveModel.volum = array[i+21];
                        if ([fiveModel.price floatValue]<[array[1] floatValue]) {
                            fiveModel.color = MyColor(33, 179, 77);
                        }else if([fiveModel.price floatValue]>[array[1] floatValue])
                        {
                            fiveModel.color = MyColor(233, 47, 68);
                        }else
                        {
                            fiveModel.color = [UIColor grayColor];
                        }
                        [sellArray addObject:fiveModel];
                    }
                }
                NSArray* sell = [[sellArray reverseObjectEnumerator] allObjects];
                
                [self.dataArray addObject:sell];
                [self.dataArray addObject:buyArray];
                [self.tableView reloadData];
            }

        } failure:^{
            
        }];
        
        
    }
    
    
    
    
    if (self.operationType == ZNFiveOrDetailsTypeTheDetail) {
        [ZNStockBasedConfigureLib getStockKlineTheDetailDataWithStockCode:stockCode success:^(id responseObject) {
            NSDictionary *dict = responseObject;
            if (dict.count > 0) {
                NSMutableArray* tempArray = [[NSMutableArray alloc] init];
                NSArray* keys = [dict allKeys];
                keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    
                    return [obj1 compare:obj2 options:NSNumericSearch];
                }];
                for (int i =0; i < keys.count; i++) {
                    NSDictionary* value = dict[[NSString stringWithFormat:@"%@",keys[i]]];
                    ZNStockDetailsModel* dishModel = [[ZNStockDetailsModel alloc] init];
                    dishModel.time = keys[i];
                    dishModel.price = [NSString stringWithFormat:@"%.2f",[value[@"p"] floatValue]];
                    dishModel.volum = value[@"v"];
                    dishModel.kind = value[@"k"];
                    if ([dishModel.price floatValue]<[self.yesterdayClosingPrice floatValue]) {
                        dishModel.color = MyColor(33, 179, 77);
                    }else if([dishModel.price floatValue]>[self.yesterdayClosingPrice floatValue])
                    {
                        dishModel.color = MyColor(233, 47, 68);
                    }else
                    {
                        dishModel.color = [UIColor grayColor];
                    }
                    [tempArray addObject:dishModel];
                }
                [self.dataArray addObjectsFromArray:[[tempArray reverseObjectEnumerator] allObjects]];
                [self.tableView reloadData];
            }
        } failure:^{
            
        }];
    }
    
}


//切换
- (void)userToChangeAction{
    if (!self.stockCode) {
        return;
    }
    
    if (self.operationType == ZNFiveOrDetailsTypeFiveBlock) {
        self.operationType = ZNFiveOrDetailsTypeTheDetail;
        [UIView animateWithDuration:0.3 animations:^{
            self.fiveBlockLabel.foregroundColor = MyColor(112, 127, 139).CGColor;
            self.theDetailsLabel.foregroundColor = MyColor(35, 125, 251).CGColor;
            self.backLayer.frame = _newRect;
        }];

    }else{
        if (self.operationType == ZNFiveOrDetailsTypeTheDetail) {
            self.operationType = ZNFiveOrDetailsTypeFiveBlock;
            [UIView animateWithDuration:0.3 animations:^{
                self.theDetailsLabel.foregroundColor = MyColor(112, 127, 139).CGColor;
                self.fiveBlockLabel.foregroundColor = MyColor(35, 125, 251).CGColor;
                self.backLayer.frame = _oldRect;
            }];
        }
    }

    
    [self startLoadingFiveBlockDataWithStockCode:self.stockCode yesterdayPrice:self.yesterdayClosingPrice];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.operationType == ZNFiveOrDetailsTypeFiveBlock) {
        if (section == 1) {
            return 10;
        }
        return 5;
    }else
    {
        return 20;
    }
}




-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.operationType == ZNFiveOrDetailsTypeFiveBlock) {
        UIView* view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, tableView.width, 5);
        if (section == 1) {
            view.height = 10;
        }
        return view;
    }else{
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width/3, 20)];
        titleLabel.text = @"时间";
        titleLabel.textColor = MyColor(130, 130, 130);
        titleLabel.font = ZNCustomDinMediumFont(10);
        [view addSubview:titleLabel];
        
        UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.width/3, 0, tableView.width/3, 20)];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = @"价格";
        priceLabel.textColor = MyColor(130, 130, 130);
        priceLabel.font = ZNCustomDinMediumFont(10);
        [view addSubview:priceLabel];
        
        UILabel* volumLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.width/3*2, 0, tableView.width/3, 20)];
        volumLabel.textAlignment = NSTextAlignmentRight;
        volumLabel.text = @"成交量";
        volumLabel.textColor = MyColor(130, 130, 130);
        volumLabel.font = ZNCustomDinMediumFont(10);
        [view addSubview:volumLabel];
        
        return view;
    }
}


@end
