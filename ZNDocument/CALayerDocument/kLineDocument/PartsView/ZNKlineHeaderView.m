//
//  ZNKlineHeaderView.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/20.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineHeaderView.h"
#import "ZNStockKlineModel.h"
#import "ZNStockBasedConfigureLib.h"

#define ZNTipsTextColor MyColor(133, 146, 157)


@interface ZNKlineHeaderView (){
    CGFloat _unitHeight;
    CGFloat _unitWidth;
    CGRect _tipsTopFrame;
    CGRect _valueTopFrame;
    CGRect _tipsBottomFrame;
    CGRect _valueBottomFrame;
}


@property(nonatomic, strong)CALayer *leftLayer;
@property(nonatomic, strong)CALayer *middleLayer;
@property(nonatomic, strong)CALayer *middle1Layer;
@property(nonatomic, strong)CALayer *rightLayer;

@property(nonatomic, assign)BOOL isLandscape;

@property(nonatomic, strong)UIFont *generalFont;


//
@property(nonatomic, strong)CATextLayer *openTipsLable;
@property(nonatomic, strong)CATextLayer *openPriceLabel;
@property(nonatomic, strong)CATextLayer *highTipsLable;
@property(nonatomic, strong)CATextLayer *highPriceLabel;
@property(nonatomic, strong)CATextLayer *lowTipsLable;
@property(nonatomic, strong)CATextLayer *lowPriceLabel;
@property(nonatomic, strong)CATextLayer *closeTipsLable;
@property(nonatomic, strong)CATextLayer *closePriceLabel;
@property(nonatomic, strong)CATextLayer *amplitudeTipsLable;
@property(nonatomic, strong)CATextLayer *amplitudeLabel;
@property(nonatomic, strong)CATextLayer *volumeTipsLable;
@property(nonatomic, strong)CATextLayer *volumeLabel;
@property(nonatomic, strong)CATextLayer *timeLabel;
@property(nonatomic, strong)CATextLayer *turnoverTipsLabel;
@property(nonatomic, strong)CATextLayer *turnoverLabel;


@end



@implementation ZNKlineHeaderView

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



- (CALayer *)leftLayer{
    if (!_leftLayer) {
        _leftLayer = [CALayer layer];
        [_leftLayer addSublayer:self.openTipsLable];
        [_leftLayer addSublayer:self.openPriceLabel];
        [_leftLayer addSublayer:self.amplitudeTipsLable];
        [_leftLayer addSublayer:self.amplitudeLabel];
         
    }
    return _leftLayer;
}


- (CALayer *)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [CALayer layer];
        [_middleLayer addSublayer:self.highTipsLable];
        [_middleLayer addSublayer:self.highPriceLabel];
        [_middleLayer addSublayer:self.volumeTipsLable];
        [_middleLayer addSublayer:self.volumeLabel];
    }
    return _middleLayer;
}

- (CALayer *)middle1Layer{
    if (!_middle1Layer) {
        _middle1Layer = [CALayer layer];
        [_middle1Layer addSublayer:self.lowTipsLable];
        [_middle1Layer addSublayer:self.lowPriceLabel];
        [_middle1Layer addSublayer:self.turnoverTipsLabel];
        [_middle1Layer addSublayer:self.turnoverLabel];
    }
    return _middle1Layer;
}

- (CALayer *)rightLayer{
    if (!_rightLayer) {
        _rightLayer = [CALayer layer];
        [_rightLayer addSublayer:self.closeTipsLable];
        [_rightLayer addSublayer:self.closePriceLabel];
        [_rightLayer addSublayer:self.timeLabel];
    }
    return _rightLayer;
}


- (CATextLayer *)openTipsLable{
    if (!_openTipsLable) {
        _openTipsLable = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_tipsTopFrame];
        _openTipsLable.string = @"开";
    }
    return _openTipsLable;
}

- (CATextLayer *)openPriceLabel{
    if (!_openPriceLabel) {
        _openPriceLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_valueTopFrame];
    }
    return _openPriceLabel;
}


- (CATextLayer *)amplitudeTipsLable{
    if (!_amplitudeTipsLable) {
        _amplitudeTipsLable = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_tipsBottomFrame];
        _amplitudeTipsLable.string = @"幅";
    }
    return _amplitudeTipsLable;
}

- (CATextLayer *)amplitudeLabel{
    if (!_amplitudeLabel) {
        _amplitudeLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_valueBottomFrame];
    }
    return _amplitudeLabel;
}

-(CATextLayer *)highTipsLable{
    if (!_highTipsLable) {
        _highTipsLable = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_tipsTopFrame];
        _highTipsLable.string = @"高";
    }
    return _highTipsLable;
}

- (CATextLayer *)highPriceLabel{
    if (!_highPriceLabel) {
        _highPriceLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_valueTopFrame];
    }
    return _highPriceLabel;
}


- (CATextLayer *)volumeTipsLable{
    if (!_volumeTipsLable) {
        _volumeTipsLable = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_tipsBottomFrame];
        _volumeTipsLable.string = @"量";
    }
    return _volumeTipsLable;

}

- (CATextLayer *)volumeLabel{
    if (!_volumeLabel) {
        _volumeLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:MyColor(40, 40, 40) font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_valueBottomFrame];
    }
    return _volumeLabel;

}

-(CATextLayer *)lowTipsLable{
    if (!_lowTipsLable) {
        _lowTipsLable = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_tipsTopFrame];
        _lowTipsLable.string = @"低";
    }
    return _lowTipsLable;
}

- (CATextLayer *)lowPriceLabel{
    if (!_lowPriceLabel) {
        _lowPriceLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_valueTopFrame];
    }
    return _lowPriceLabel;
}

- (CATextLayer *)turnoverTipsLabel{
    if (!_turnoverTipsLabel) {
        _turnoverTipsLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_tipsBottomFrame];
        _turnoverTipsLabel.string = @"换";
    }
    return _turnoverTipsLabel;
    
}

- (CATextLayer *)turnoverLabel{
    if (!_turnoverLabel) {
        _turnoverLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:MyColor(40, 40, 40) font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_valueBottomFrame];
    }
    return _turnoverLabel;
    
}


- (CATextLayer *)closeTipsLable{
    if (!_closeTipsLable) {
        _closeTipsLable = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_tipsTopFrame];
        _closeTipsLable.string = @"收";
    }
    return _closeTipsLable;
}

- (CATextLayer *)closePriceLabel{
    if (!_closePriceLabel) {
        _closePriceLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:ZNTipsTextColor font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:_valueTopFrame];
    }
    return _closePriceLabel;
}


- (CATextLayer *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:MyColor(40, 40, 40) font:self.generalFont textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(0, _valueBottomFrame.origin.y, _unitWidth, _valueBottomFrame.size.height)];
    }
    return _timeLabel;
}



- (instancetype)initWithFrame:(CGRect)frame isLandscape:(BOOL)isLandscape{
    if ([super initWithFrame:frame]) {
        _isLandscape = isLandscape;
        [self configureUI];
    }
    return self;
}


- (void)configureUI{
    
    self.backgroundColor = [UIColor whiteColor];

    
    CGSize size = [self getFitSizeWithContent:@"开"];
    
    
    if (_isLandscape) {
        
        CGFloat self_Height_2 = self.height/2;
        CGFloat normalY = self_Height_2 - size.height/2;
        CGSize timeSize = [self getFitSizeWithContent:@"2017-06-06"];
        CGSize priceSize = [self getFitSizeWithContent:@"666.66"];
        CGFloat priceY = self_Height_2 - priceSize.height/2;
        self.timeLabel.frame = CGRectMake(10, self_Height_2 - timeSize.height/2, timeSize.width, timeSize.height);
        self.openTipsLable.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame), normalY, size.width, size.height);
        self.openPriceLabel.frame = CGRectMake(CGRectGetMaxX(self.openTipsLable.frame), priceY, priceSize.width + 50, priceSize.height);
        self.highTipsLable.frame = CGRectMake(CGRectGetMaxX(self.openPriceLabel.frame), normalY, size.width, size.height);
        self.highPriceLabel.frame = CGRectMake(CGRectGetMaxX(self.highTipsLable.frame), priceY, priceSize.width + 50, priceSize.height);
        self.lowTipsLable.frame = CGRectMake(CGRectGetMaxX(self.highPriceLabel.frame), normalY, size.width, size.height);
        self.lowPriceLabel.frame = CGRectMake(CGRectGetMaxX(self.lowTipsLable.frame), priceY, priceSize.width + 50, priceSize.height);
        self.closeTipsLable.frame = CGRectMake(CGRectGetMaxX(self.lowPriceLabel.frame), normalY, size.width, size.height);
        self.closePriceLabel.frame = CGRectMake(CGRectGetMaxX(self.closeTipsLable.frame), priceY, priceSize.width + 50, priceSize.height);
        self.amplitudeTipsLable.frame = CGRectMake(CGRectGetMaxX(self.closePriceLabel.frame), normalY, size.width, size.height);
        self.amplitudeLabel.frame = CGRectMake(CGRectGetMaxX(self.amplitudeTipsLable.frame), priceY, priceSize.width + 50, priceSize.height);
        
        
        [self.layer addSublayer:self.timeLabel];
        [self.layer addSublayer:self.openTipsLable];
        [self.layer addSublayer:self.openPriceLabel];
        [self.layer addSublayer:self.highTipsLable];
        [self.layer addSublayer:self.highPriceLabel];
        [self.layer addSublayer:self.lowTipsLable];
        [self.layer addSublayer:self.lowPriceLabel];
        [self.layer addSublayer:self.closeTipsLable];
        [self.layer addSublayer:self.closePriceLabel];
        [self.layer addSublayer:self.amplitudeTipsLable];
        [self.layer addSublayer:self.amplitudeLabel];

        return;
    }
    
    
    
    CGFloat unitWidth = (SCREENT_WIDTH - 20)/4;
    CGFloat unitHeight = self.height - 10;
    _unitWidth = unitWidth;
    _unitHeight = unitHeight;
    
    _tipsTopFrame = CGRectMake(0, 0, size.width, size.height);
    _valueTopFrame = CGRectMake(CGRectGetMaxX(_tipsTopFrame) + 2, 0, _unitWidth - CGRectGetMaxX(_tipsTopFrame) - 2, CGRectGetHeight(_tipsTopFrame));
    _tipsBottomFrame = CGRectMake(0, _unitHeight - size.height, size.width, size.height);
    _valueBottomFrame = CGRectMake(CGRectGetMaxX(_tipsBottomFrame) + 2, _unitHeight - size.height, _unitWidth - CGRectGetMaxX(_tipsBottomFrame) - 2, CGRectGetHeight(_tipsBottomFrame));
    
    
    self.leftLayer.frame = CGRectMake(10, 5, unitWidth, unitHeight);
    self.middleLayer.frame = CGRectMake(CGRectGetMaxX(self.leftLayer.frame), 5, unitWidth, unitHeight);
    self.middle1Layer.frame = CGRectMake(CGRectGetMaxX(self.middleLayer.frame), 5, unitWidth, unitHeight);
    self.rightLayer.frame = CGRectMake(CGRectGetMaxX(self.middle1Layer.frame), 5, unitWidth, unitHeight);
    [self.layer addSublayer:self.leftLayer];
    [self.layer addSublayer:self.middleLayer];
    [self.layer addSublayer:self.middle1Layer];
    [self.layer addSublayer:self.rightLayer];

}




- (void)refreshShowTimeSharingModelWithModel:(ZNStockKlineModel *)klineModel beforeClosePrice:(CGFloat)beforeClosePrice
{
    
    self.openPriceLabel.foregroundColor = [klineModel.open floatValue]>beforeClosePrice?MyColor(233, 47, 68).CGColor:MyColor(33, 179, 77).CGColor;
    self.openPriceLabel.string = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[klineModel.open floatValue]];
    self.amplitudeLabel.foregroundColor = [klineModel.chg_pct floatValue]>0?MyColor(233, 47, 68).CGColor:([klineModel.chg_pct floatValue] <0)?MyColor(33, 179, 77).CGColor:MyColor(146, 160, 172).CGColor;
    self.amplitudeLabel.string = [[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[klineModel.chg_pct floatValue]] stringByAppendingString:@"%"];
    self.highPriceLabel.foregroundColor = [klineModel.high floatValue]>beforeClosePrice?MyColor(233, 47, 68).CGColor:MyColor(33, 179, 77).CGColor;
    self.highPriceLabel.string = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[klineModel.high floatValue]];
    self.lowPriceLabel.foregroundColor = [klineModel.low floatValue]>beforeClosePrice?MyColor(233, 47, 68).CGColor:MyColor(33, 179, 77).CGColor;
    self.lowPriceLabel.string = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[klineModel.low floatValue]];
    self.closePriceLabel.foregroundColor = [klineModel.close floatValue]>beforeClosePrice?MyColor(233, 47, 68).CGColor:MyColor(33, 179, 77).CGColor;
    self.closePriceLabel.string = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[klineModel.close floatValue]];

    if (self.isLandscape) {
        self.timeLabel.string = [klineModel.time substringFromIndex:5];
        return;
    }
    
    
    self.timeLabel.string = klineModel.time;
    self.volumeLabel.string = [NSString stringWithFormat:@"%@%@",[ZNStockBasedConfigureLib configureStockVolumeShowWithVolume:[klineModel.volume floatValue]],[ZNStockBasedConfigureLib getStockVolumeUnitWithVolume:[klineModel.volume floatValue]]];
    self.turnoverLabel.hidden = YES;
    self.turnoverTipsLabel.hidden = YES;
    if (klineModel.turnover.length > 0) {
        self.turnoverLabel.hidden = NO;
        self.turnoverTipsLabel.hidden = NO;
        self.turnoverLabel.string = [[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[klineModel.turnover floatValue]] stringByAppendingString:@"%"];

    }
    
    
    
    

    
}



@end
