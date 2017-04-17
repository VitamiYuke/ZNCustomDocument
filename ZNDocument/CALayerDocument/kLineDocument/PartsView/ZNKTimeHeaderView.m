//
//  ZNKTimeHeaderView.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/20.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKTimeHeaderView.h"
#import "ZNStockTimeSharingModel.h"
#import "ZNStockBasedConfigureLib.h"

#define ZNTipsTextColor MyColor(133, 146, 157)

@interface ZNKTimeHeaderView ()

//分时的数据
@property(nonatomic, strong)CATextLayer *timeLabel;
@property(nonatomic, strong)CATextLayer *priceTipsLabel;
@property(nonatomic, strong)CATextLayer *priceLabel;
@property(nonatomic, strong)CATextLayer *avgPriceTipsLabel;
@property(nonatomic, strong)CATextLayer *avgPriceLabel;
@property(nonatomic, strong)CATextLayer *upTipsLabel;
@property(nonatomic, strong)CATextLayer *upLabel;
@property(nonatomic, strong)CATextLayer *volumeTipsLabel;
@property(nonatomic, strong)CATextLayer *volumeLabel;
@property(nonatomic, strong)UIFont *generalFont;


@property(nonatomic, assign)BOOL isLandscape;

@end


@implementation ZNKTimeHeaderView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIFont *)generalFont{
    if (!_generalFont) {
        _generalFont = (_isLandscape?ZNCustomDinBoldFont(15):ZNCustomDinBoldFont(12));
    }
    return _generalFont;
}


- (CGSize )getFitSizeWithContent:(NSString *)content{
    return [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:self.generalFont content:content limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}



- (CATextLayer *)timeLabel{
    if (!_timeLabel) {
        
        CGSize timeNormalSize = [self getFitSizeWithContent:@"11:11"];
        _timeLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:[UIColor blackColor] font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(10, self.height/2 - timeNormalSize.height/2, timeNormalSize.width + (_isLandscape?50:10), timeNormalSize.height)];
    }
    return _timeLabel;
}

- (CATextLayer *)priceTipsLabel{
    if (!_priceTipsLabel) {
        CGSize size = [self getFitSizeWithContent:@"价"];
        _priceTipsLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame), self.height/2 - size.height/2, size.width+1, size.height)];
        _priceTipsLabel.string = @"价";
    }
    return _priceTipsLabel;
}

- (CATextLayer *)priceLabel{
    if (!_priceLabel) {
        CGSize size = [self getFitSizeWithContent:@"6666.66"];
        _priceLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:[UIColor grayColor] font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.priceTipsLabel.frame), self.height/2 - size.height/2, size.width + (_isLandscape?50:10) , size.height)];
    }
    return _priceLabel;
}


- (CATextLayer *)avgPriceTipsLabel{
    if (!_avgPriceTipsLabel) {
        CGSize size = [self getFitSizeWithContent:@"均"];
        _avgPriceTipsLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame), self.height/2 - size.height/2, size.width+1, size.height)];
        _avgPriceTipsLabel.string = @"均";
    }
    return _avgPriceTipsLabel;
}

- (CATextLayer *)avgPriceLabel{
    if (!_avgPriceLabel) {
        CGSize size = [self getFitSizeWithContent:@"6666.66"];
        _avgPriceLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:[UIColor grayColor] font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.avgPriceTipsLabel.frame), self.height/2 - size.height/2, size.width + (_isLandscape?50:10) , size.height)];
    }
    return _avgPriceLabel;
}

- (CATextLayer *)upTipsLabel{
    if (!_upTipsLabel) {
        CGSize size = [self getFitSizeWithContent:@"涨"];
        _upTipsLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.avgPriceLabel.frame), self.height/2 - size.height/2, size.width+1, size.height)];
        _upTipsLabel.string = @"涨";
    }
    return _upTipsLabel;
}

- (CATextLayer *)upLabel{
    if (!_upLabel) {
        CGSize size = [self getFitSizeWithContent:@"-6.66%"];
        _upLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:[UIColor grayColor] font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.upTipsLabel.frame), self.height/2 - size.height/2, size.width + (_isLandscape?50:10) , size.height)];
    }
    return _upLabel;
}

- (CATextLayer *)volumeTipsLabel{
    if (!_volumeTipsLabel) {
        CGSize size = [self getFitSizeWithContent:@"量"];
        _volumeTipsLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.upLabel.frame), self.height/2 - size.height/2, size.width+1, size.height)];
        _volumeTipsLabel.string = @"量";
    }
    return _volumeTipsLabel;
}

- (CATextLayer *)volumeLabel{
    if (!_volumeLabel) {
        CGSize size = [self getFitSizeWithContent:@"6666手"];
        _volumeLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:[UIColor grayColor] font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.volumeTipsLabel.frame), self.height/2 - size.height/2, size.width + 50 , size.height)];
    }
    return _volumeLabel;
}




- (instancetype)initWithFrame:(CGRect)frame isLandscape:(BOOL)isLandscape
{
    if ([super initWithFrame:frame]) {
        _isLandscape = isLandscape;
        [self configureUI];
    }
    return self;
}


- (void)configureUI{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.layer addSublayer:self.timeLabel];
    [self.layer addSublayer:self.priceTipsLabel];
    [self.layer addSublayer:self.priceLabel];
    [self.layer addSublayer:self.avgPriceTipsLabel];
    [self.layer addSublayer:self.avgPriceLabel];
    [self.layer addSublayer:self.upTipsLabel];
    [self.layer addSublayer:self.upLabel];
    [self.layer addSublayer:self.volumeTipsLabel];
    [self.layer addSublayer:self.volumeLabel];
 
    
}



- (void)refreshShowTimeSharingModelWithModel:(ZNStockTimeSharingModel *)sharingModel yesterdayPrice:(CGFloat)yesterdayPrice{
    self.timeLabel.string = sharingModel.time;
    self.priceLabel.string = sharingModel.price;
    self.avgPriceLabel.string = sharingModel.avg_price;
    CGFloat rate = ([sharingModel.price floatValue]-yesterdayPrice)/yesterdayPrice*100;
    if (rate < 0) {
        self.upTipsLabel.string = @"跌";
    }else{
        self.upTipsLabel.string = @"涨";
    }
    self.upLabel.string = [NSString stringWithFormat:@"%.2f%%",rate];
    
    if ([sharingModel.price floatValue]>yesterdayPrice) {
        self.priceLabel.foregroundColor = MyColor(233, 47, 68).CGColor;
        self.upLabel.foregroundColor = MyColor(233, 47, 68).CGColor;
    }else if ([sharingModel.price floatValue]<yesterdayPrice)
    {
        self.priceLabel.foregroundColor = MyColor(33, 179, 77).CGColor;
        self.upLabel.foregroundColor = MyColor(33, 179, 77).CGColor;
    }else
    {
        self.priceLabel.foregroundColor = [UIColor grayColor].CGColor;
        self.upLabel.foregroundColor = [UIColor grayColor].CGColor;
    }
    
    if ([sharingModel.avg_price floatValue]>yesterdayPrice) {
        self.avgPriceLabel.foregroundColor = MyColor(233, 47, 68).CGColor;
    }else if ([sharingModel.avg_price floatValue]<yesterdayPrice)
    {
        self.avgPriceLabel.foregroundColor = MyColor(33, 179, 77).CGColor;
    }else
    {
        self.avgPriceLabel.foregroundColor = [UIColor grayColor].CGColor;
    }
    //成交量
    self.volumeLabel.string = [NSString stringWithFormat:@"%@%@",[ZNStockBasedConfigureLib configureStockVolumeShowWithVolume:[sharingModel.volume floatValue]],[ZNStockBasedConfigureLib getStockVolumeUnitWithVolume:[sharingModel.volume floatValue]]];
    
}





@end
