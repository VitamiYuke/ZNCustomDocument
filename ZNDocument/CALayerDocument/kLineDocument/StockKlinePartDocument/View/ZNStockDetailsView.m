//
//  ZNStockDetailsView.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/12.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNStockDetailsView.h"
#import "ZNStockDetailsCell.h"
#import "ZNStockDetailsInfoModel.h"
#import "ZNStockDetailsInfoToolManager.h"
@interface ZNStockDetailsView ()

@property(nonatomic,strong)ZNStockDetailsCell *indexPathRow0;
@property(nonatomic,strong)ZNStockDetailsCell *indexPathRow1;
@property(nonatomic,strong)ZNStockDetailsCell *indexPathRow2;
@property(nonatomic,strong)ZNStockDetailsCell *indexPathRow3;


@property(nonatomic, strong)NSMutableArray *row0Array;
@property(nonatomic, strong)NSMutableArray *row1Array;
@property(nonatomic, strong)NSMutableArray *row2Array;
@property(nonatomic, strong)NSMutableArray *row3Array;

@property(nonatomic, strong)NSMutableArray *marketRow0Array;


@property(nonatomic, strong)NSArray *keysArray;


@end


@implementation ZNStockDetailsView


- (ZNStockDetailsCell *)indexPathRow0{
    if (!_indexPathRow0) {
        _indexPathRow0 = [[ZNStockDetailsCell alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, Each_Row_Height)];
        _indexPathRow0.backgroundColor = [UIColor whiteColor];
    }
    return _indexPathRow0;
}


- (ZNStockDetailsCell *)indexPathRow1{
    if (!_indexPathRow1) {
        _indexPathRow1 = [[ZNStockDetailsCell alloc] initWithFrame:CGRectMake(0, Each_Row_Height, SCREENT_WIDTH, Each_Row_Height)];
        _indexPathRow1.backgroundColor = MyColor(236, 241, 249);;
    }
    return _indexPathRow1;
}

- (ZNStockDetailsCell *)indexPathRow2{
    if (!_indexPathRow2) {
        _indexPathRow2 = [[ZNStockDetailsCell alloc] initWithFrame:CGRectMake(0, Each_Row_Height * 2, SCREENT_WIDTH, Each_Row_Height)];
        _indexPathRow2.backgroundColor = [UIColor whiteColor];
    }
    return _indexPathRow2;
}

- (ZNStockDetailsCell *)indexPathRow3{
    if (!_indexPathRow3) {
        _indexPathRow3 = [[ZNStockDetailsCell alloc] initWithFrame:CGRectMake(0, Each_Row_Height * 3, SCREENT_WIDTH, Each_Row_Height)];
        _indexPathRow3.backgroundColor = MyColor(236, 241, 249);;
    }
    return _indexPathRow3;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}





- (void)configureUI{
    [self addSubview:self.indexPathRow0];
    [self addSubview:self.indexPathRow1];
    [self addSubview:self.indexPathRow2];
    [self addSubview:self.indexPathRow3];
}


- (void)resetConfigure{
    self.indexPathRow1.hidden = YES;
    self.indexPathRow2.hidden = YES;
    self.indexPathRow3.hidden = YES;
}


- (void)setIsTheBroaderMarket:(BOOL)isTheBroaderMarket{
    _isTheBroaderMarket = isTheBroaderMarket;
    [self resetConfigure];
    if (!isTheBroaderMarket) {
        self.indexPathRow1.hidden = NO;
        self.indexPathRow2.hidden = NO;
        self.indexPathRow3.hidden = NO;
    }
    
    if (isTheBroaderMarket) {
        self.indexPathRow0.keyValueArray = self.marketRow0Array;
    }else{
        
        self.indexPathRow0.keyValueArray = self.row0Array;
        self.indexPathRow1.keyValueArray = self.row1Array;
        self.indexPathRow2.keyValueArray = self.row2Array;
        self.indexPathRow3.keyValueArray = self.row3Array;
        
        
    }
    
    
}

- (NSMutableDictionary *)configureStockInfoDicWithKey:(NSString *)keyName value:(id )valueData{
    if (!valueData) {
        return nil;
    }
    return @{keyName:valueData}.mutableCopy;
}

- (NSAttributedString *)configureStockInfoValueWithValue:(NSString *)value styleDic:(NSDictionary *)dic{
    if (!value) {
        MyLog(@"没有值");
        return nil;
    }
    if (!dic) {
        dic = @{NSForegroundColorAttributeName:MyColor(40, 40, 40),NSFontAttributeName:ZNCustomDinMediumFont(13)};
    }
    return [[NSAttributedString alloc] initWithString:value attributes:dic];
}

- (NSArray *)keysArray{
    if (!_keysArray) {
        _keysArray = @[@[@"最高",@"最低",@"内盘",@"外盘"],
                       @[@"成交额",@"振幅",@"委比",@"委差"],
                       @[@"流通市值",@"总市值",@"市盈率",@"市净率"],
                       @[@"每股收益",@"每股净资产",@"总股本",@"流通股"]];
    }
    return _keysArray;
}


- (NSMutableArray *)row0Array{
    if (!_row0Array) {
        _row0Array = @[[self configureStockInfoDicWithKey:self.keysArray[0][0] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[0][1] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[0][2] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[0][3] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]]].mutableCopy;
    }
    return _row0Array;
}

- (NSMutableArray *)row1Array{
    if (!_row1Array) {
        _row1Array = @[[self configureStockInfoDicWithKey:self.keysArray[1][0] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[1][1] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[1][2] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[1][3] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]]].mutableCopy;
    }
    return _row1Array;
}

- (NSMutableArray *)row2Array{
    if (!_row2Array) {
        _row2Array = @[[self configureStockInfoDicWithKey:self.keysArray[2][0] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[2][1] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[2][2] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[2][3] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]]].mutableCopy;
    }
    return _row2Array;
}

- (NSMutableArray *)row3Array{
    if (!_row3Array) {
        _row3Array = @[[self configureStockInfoDicWithKey:self.keysArray[3][0] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[3][1] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[3][2] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                       [self configureStockInfoDicWithKey:self.keysArray[3][3] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]]].mutableCopy;
    }
    return _row3Array;
}


- (NSMutableArray *)marketRow0Array{
    if (!_marketRow0Array) {
        _marketRow0Array = @[[self configureStockInfoDicWithKey:self.keysArray[0][0] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]],
                             [self configureStockInfoDicWithKey:self.keysArray[0][1] value:[self configureStockInfoValueWithValue:@"---" styleDic:nil]]].mutableCopy;
    }
    return _marketRow0Array;
}


- (void)setStockDetailsInfoModel:(ZNStockDetailsInfoModel *)stockDetailsInfoModel
{
    _stockDetailsInfoModel = stockDetailsInfoModel;

    
    CGFloat yesterClosePrice = [stockDetailsInfoModel.close floatValue];
    CGFloat maxPrice = [stockDetailsInfoModel.maxPrice floatValue];
    CGFloat minPrice = [stockDetailsInfoModel.minPrice floatValue];
    UIColor *maxColor = MyColor(40, 40, 40);
    UIColor *minColor = MyColor(40, 40, 40);
    if (minPrice > yesterClosePrice) {
        minColor = Stock_Red;
        maxColor = Stock_Red;
    }else if (minPrice < yesterClosePrice){
        minColor = Stock_Green;
        if (maxPrice > yesterClosePrice) {
            maxColor = Stock_Red;
        }
        
        if (maxPrice < yesterClosePrice) {
            maxColor = Stock_Green;
        }
    }else{
        if (maxPrice > yesterClosePrice) {
            maxColor = Stock_Red;
        }
        if (maxPrice < yesterClosePrice) {
            maxColor = Stock_Green;
        }
    }
    if (self.isTheBroaderMarket) {
        for (int i = 0; i < self.marketRow0Array.count; i++) {
            NSMutableDictionary *dic = self.marketRow0Array[i];
            NSString *key = [[dic allKeys] lastObject];
            if (i == 0) {
                dic[key] = [self configureStockInfoValueWithValue:[ZNStockDetailsInfoToolManager configureFloatStringWithOriginValue:maxPrice] styleDic:@{NSForegroundColorAttributeName:maxColor,NSFontAttributeName:ZNCustomDinMediumFont(13)}];
            }
            
            if (i == 1) {
                dic[key] = [self configureStockInfoValueWithValue:[ZNStockDetailsInfoToolManager configureFloatStringWithOriginValue:minPrice] styleDic:@{NSForegroundColorAttributeName:minColor,NSFontAttributeName:ZNCustomDinMediumFont(13)}];
            }
            
        }
        self.indexPathRow0.keyValueArray = self.marketRow0Array;
    }else{
        
        NSString *outsideString = @"0";
        if (stockDetailsInfoModel.outsideDish.length) {
            outsideString = stockDetailsInfoModel.outsideDish;
        }
        CGFloat outsideDishFloatValue = outsideString.floatValue;
        NSString *outsideDishValue = [ZNStockDetailsInfoToolManager configureStockVolumeShowWithVolume:outsideDishFloatValue];
        NSString *outsideDishUnitDesc = [ZNStockDetailsInfoToolManager getStockVolumeUnitWithVolume:outsideDishFloatValue];
        UIColor *outsideColor = outsideDishFloatValue>0?Stock_Red:MyColor(40, 40, 40);
        NSMutableAttributedString *outsideDishAtt = [[NSMutableAttributedString alloc] initWithString:outsideDishValue attributes:@{NSForegroundColorAttributeName:outsideColor,NSFontAttributeName:ZNCustomDinMediumFont(13)}];
        [outsideDishAtt appendAttributedString:[[NSAttributedString alloc] initWithString:outsideDishUnitDesc attributes:@{NSFontAttributeName:ZNCustomDinMediumFont(10),NSForegroundColorAttributeName:outsideColor}]];
        NSString *insideString = @"0";
        if (stockDetailsInfoModel.insideDish.length) {
            insideString = stockDetailsInfoModel.insideDish;
        }
        CGFloat insideDishFloatValue = insideString.floatValue;
        NSString *insideDishValue = [ZNStockDetailsInfoToolManager configureStockVolumeShowWithVolume:insideDishFloatValue];
        NSString *insideDishUnitDesc = [ZNStockDetailsInfoToolManager getStockVolumeUnitWithVolume:insideDishFloatValue];
        UIColor *insideColor = insideDishFloatValue>0?Stock_Green:MyColor(40, 40, 40);
        NSMutableAttributedString *insideDishAtt = [[NSMutableAttributedString alloc] initWithString:insideDishValue attributes:@{NSForegroundColorAttributeName:insideColor,NSFontAttributeName:ZNCustomDinMediumFont(13)}];
        [insideDishAtt appendAttributedString:[[NSAttributedString alloc] initWithString:insideDishUnitDesc attributes:@{NSFontAttributeName:ZNCustomDinMediumFont(10),NSForegroundColorAttributeName:insideColor}]];
        
        
        
        for (int i = 0; i < self.row0Array.count; i++) {
            NSMutableDictionary *dic = self.row0Array[i];
            NSString *key = [[dic allKeys] lastObject];
            if (i == 0) {
                dic[key] = [self configureStockInfoValueWithValue:[ZNStockDetailsInfoToolManager configureFloatStringWithOriginValue:maxPrice] styleDic:@{NSForegroundColorAttributeName:maxColor}];
            }
            
            if (i == 1) {
                dic[key] = [self configureStockInfoValueWithValue:[ZNStockDetailsInfoToolManager configureFloatStringWithOriginValue:minPrice] styleDic:@{NSForegroundColorAttributeName:minColor}];
            }
            
            if (i == 2) {
                dic[key] = insideDishAtt;
            }
            
            if (i == 3) {
                dic[key] = outsideDishAtt;
            }
            
            
        }
        self.indexPathRow0.keyValueArray = self.row0Array;
        
        
        
        //成交额 振幅 委比 委差
        NSString *turnover = @"0";
        if (stockDetailsInfoModel.turnover.length) {
            turnover = stockDetailsInfoModel.turnover;
        }
        NSMutableAttributedString *turnoverAtt = [self configureShowWithOriginValue:turnover.floatValue];
        
        
        UIColor *appointThanColor = Stock_Gray;
        if (stockDetailsInfoModel.appointThan.floatValue > 0) {
            appointThanColor = Stock_Red;
        }
        if (stockDetailsInfoModel.appointThan.floatValue < 0){
            appointThanColor = Stock_Green;
        }
        
        //
        NSString *committeePoor = @"0";
        if (stockDetailsInfoModel.committeePoor) {
            committeePoor = stockDetailsInfoModel.committeePoor;
        }
        NSMutableAttributedString *committeeAtt = [self configureShowWithOriginValue:committeePoor.floatValue];
        
        for (int i = 0; i < self.row1Array.count; i++) {
            NSMutableDictionary *dic = self.row1Array[i];
            NSString *key = [[dic allKeys] lastObject];
            if (i == 0) {
                dic[key] = turnoverAtt;
            }
            
            if (i == 1) {
                dic[key] = [self configureStockInfoValueWithValue:stockDetailsInfoModel.rate styleDic:@{NSForegroundColorAttributeName:MyColor(40, 40, 40),NSFontAttributeName:ZNCustomDinMediumFont(13)}];
            }
            
            if (i == 2) {
                dic[key] = [self configureStockInfoValueWithValue:[stockDetailsInfoModel.appointThan stringByAppendingString:@"%"] styleDic:@{NSForegroundColorAttributeName:appointThanColor,NSFontAttributeName:ZNCustomDinMediumFont(13)}];
            }
            
            if (i == 3) {
                dic[key] = committeeAtt;
            }

        }
        self.indexPathRow1.keyValueArray = self.row1Array;
        
        
        //流通市值
        NSString *ltsz = @"0";
        NSString *zsz = @"0";
        if (stockDetailsInfoModel.ltsz.length) {
            ltsz = stockDetailsInfoModel.ltsz;
        }
        
        if (stockDetailsInfoModel.zsz.length) {
            zsz = stockDetailsInfoModel.zsz;
        }
        
        NSMutableAttributedString *ltszAtt = [self configureShowWithOriginValue:ltsz.floatValue];
        NSMutableAttributedString *zszAtt = [self configureShowWithOriginValue:zsz.floatValue];
        
        for (int i = 0; i < self.row2Array.count; i++) {
            NSMutableDictionary *dic = self.row2Array[i];
            NSString *key = [[dic allKeys] lastObject];
            if (i == 0) {
                dic[key] = ltszAtt;
            }
            
            if (i == 1) {
               dic[key] = zszAtt;
            }
            
            if (i == 2) {
                dic[key] = [self configureStockInfoValueWithValue:stockDetailsInfoModel.earnings styleDic:@{NSForegroundColorAttributeName:MyColor(40, 40, 40),NSFontAttributeName:ZNCustomDinMediumFont(13)}];
            }
            
            if (i == 3) {
                dic[key] = [self configureStockInfoValueWithValue:stockDetailsInfoModel.price_to_book styleDic:@{NSForegroundColorAttributeName:MyColor(40, 40, 40),NSFontAttributeName:ZNCustomDinMediumFont(13)}];
            }
            
        }
        self.indexPathRow2.keyValueArray = self.row2Array;
        
        NSString *mgsy = @"0";
        if (stockDetailsInfoModel.mgsy.length) {
            mgsy = stockDetailsInfoModel.mgsy;
        }
        
        NSString *mgjzc = @"0";
        if (stockDetailsInfoModel.mgjzc.length) {
            mgjzc = stockDetailsInfoModel.mgjzc;
        }
        
        NSString *zgb = @"0";
        NSString *ltg = @"0";
        
        if (stockDetailsInfoModel.zgb.length) {
            zgb = stockDetailsInfoModel.zgb;
        }
        
        if (stockDetailsInfoModel.ltg.length) {
            ltg = stockDetailsInfoModel.ltg;
        }
        
        NSMutableAttributedString *zgbAtt = [self configureShowWithOriginValue:zgb.floatValue];
        NSMutableAttributedString *ltgAtt = [self configureShowWithOriginValue:ltg.floatValue];
        
        
        
        for (int i = 0; i < self.row3Array.count; i++) {
            NSMutableDictionary *dic = self.row3Array[i];
            NSString *key = [[dic allKeys] lastObject];
            if (i == 0) {
                dic[key] = [self configureStockInfoValueWithValue:[ZNStockDetailsInfoToolManager configureFloatStringWithOriginValue:mgsy.floatValue] styleDic:@{NSForegroundColorAttributeName:MyColor(40, 40, 40),NSFontAttributeName:ZNCustomDinMediumFont(13)}];
            }
            
            if (i == 1) {
                dic[key] = [self configureStockInfoValueWithValue:[ZNStockDetailsInfoToolManager configureFloatStringWithOriginValue:mgjzc.floatValue] styleDic:@{NSForegroundColorAttributeName:MyColor(40, 40, 40),NSFontAttributeName:ZNCustomDinMediumFont(13)}];
            }
            
            if (i == 2) {
                dic[key] = zgbAtt;
            }
            
            if (i == 3) {
                dic[key] = ltgAtt;
            }
            
            
            
        }
        self.indexPathRow3.keyValueArray = self.row3Array;
        
    }
    
    
    
}


- (NSMutableAttributedString *)configureShowWithOriginValue:(CGFloat )value{
    NSString *tempValue = [ZNStockDetailsInfoToolManager configureMoneyValueWithOriginValue:value];
    NSString *tempUnit = [ZNStockDetailsInfoToolManager configureMoneyUnitWithMoney:value];
    NSMutableAttributedString *tempAtt = [self configureShowValueWithValue:tempValue unitStr:tempUnit textColor:MyColor(40, 40, 40)];
    return tempAtt;
}


- (NSMutableAttributedString *)configureShowValueWithValue:(NSString *)value unitStr:(NSString *)unitStr textColor:(UIColor *)textColor{
    NSMutableAttributedString *tempAtt = [[NSMutableAttributedString alloc] initWithString:value attributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:ZNCustomDinMediumFont(13)}];
    [tempAtt appendAttributedString:[[NSAttributedString alloc] initWithString:unitStr attributes:@{NSFontAttributeName:ZNCustomDinMediumFont(10),NSForegroundColorAttributeName:textColor}]];
    return tempAtt;
}





@end
