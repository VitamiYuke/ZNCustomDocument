//
//  ZNStockDetailsHeaderView.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/10.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNStockDetailsHeaderView.h"
#import "ZNVerticalScreenContainer.h"
#import "ZNStockDetailsInfoModel.h"
#import "ZNSearchStockModel.h"
#import "ZNStockDetailsInfoToolManager.h"
@interface ZNStockDetailsHeaderView ()<ZNBasicAnimationDelegate>
@property(nonatomic, strong)ZNVerticalScreenContainer *verContainer;
@property(nonatomic, strong)UILabel *currentPriceLabel;
@property(nonatomic, strong)UILabel *riseAndFallDescLabel;
@property(nonatomic, strong)UILabel *openPriceLabel;
@property(nonatomic, strong)UILabel *closePriceLabel;
@property(nonatomic, strong)UILabel *volumeLabel;
@property(nonatomic, strong)UILabel *turnoverRateLabel;
//tips
@property(nonatomic, strong)UILabel *openTips;
@property(nonatomic, strong)UILabel *closeTips;
@property(nonatomic, strong)UILabel *volumeTips;
@property(nonatomic, strong)UILabel *turnoverTips;
//action
@property(nonatomic, strong)UIButton *tapAction;

@property(nonatomic, strong)UIImageView *rightIcon;

@property(nonatomic, assign)BOOL isLookDetailsInfo;//是否观看详情


@end




@implementation ZNStockDetailsHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stock_down_white"]];
    }
    return _rightIcon;
}


- (UILabel *)currentPriceLabel{
    if (!_currentPriceLabel) {
        _currentPriceLabel = [self configureLabelWithTextColor:[UIColor whiteColor] font:ZNCustomDinMediumFont(40) alignment:NSTextAlignmentLeft placeHolder:@"---"];
    }
    return _currentPriceLabel;
}

- (UILabel *)riseAndFallDescLabel{
    if (!_riseAndFallDescLabel) {
        _riseAndFallDescLabel = [self configureLabelWithTextColor:[UIColor whiteColor] font:ZNCustomDinMediumFont(20) alignment:NSTextAlignmentLeft placeHolder:@"---"];
    }
    return _riseAndFallDescLabel;
}


- (UILabel *)openPriceLabel{
    if (!_openPriceLabel) {
        _openPriceLabel = [self configureLabelWithTextColor:[UIColor whiteColor] font:ZNCustomDinMediumFont(15) alignment:NSTextAlignmentLeft placeHolder:@"---"];
    }
    return _openPriceLabel;
}


- (UILabel *)closePriceLabel{
    if (!_closePriceLabel) {
        _closePriceLabel = [self configureLabelWithTextColor:[UIColor whiteColor] font:ZNCustomDinMediumFont(15) alignment:NSTextAlignmentLeft placeHolder:@"---"];
    }
    return _closePriceLabel;
}


- (UILabel *)volumeLabel{
    if (!_volumeLabel) {
        _volumeLabel = [self configureLabelWithTextColor:[UIColor whiteColor] font:ZNCustomDinMediumFont(15) alignment:NSTextAlignmentLeft placeHolder:@"---"];
    }
    return _volumeLabel;
}


- (UILabel *)turnoverRateLabel{
    if (!_turnoverRateLabel) {
        _turnoverRateLabel = [self configureLabelWithTextColor:[UIColor whiteColor] font:ZNCustomDinMediumFont(15) alignment:NSTextAlignmentLeft placeHolder:@"---"];
    }
    return _turnoverRateLabel;
}


- (UILabel *)openTips{
    if (!_openTips) {
        _openTips = [self configureLabelWithTextColor:MyColor(240, 240, 240) font:ZNCustomDinNormalFont(12) alignment:NSTextAlignmentLeft placeHolder:@"今开"];
    }
    return _openTips;
}


- (UILabel *)closeTips{
    if (!_closeTips) {
        _closeTips = [self configureLabelWithTextColor:MyColor(240, 240, 240) font:ZNCustomDinNormalFont(12) alignment:NSTextAlignmentLeft placeHolder:@"昨收"];
    }
    return _closeTips;
}


- (UILabel *)volumeTips{
    if (!_volumeTips) {
        _volumeTips = [self configureLabelWithTextColor:MyColor(240, 240, 240) font:ZNCustomDinNormalFont(12) alignment:NSTextAlignmentLeft placeHolder:@"成交量"];
    }
    return _volumeTips;
}


- (UILabel *)turnoverTips{
    if (!_turnoverTips) {
        _turnoverTips = [self configureLabelWithTextColor:MyColor(240, 240, 240) font:ZNCustomDinNormalFont(12) alignment:NSTextAlignmentLeft placeHolder:@"换手率"];
    }
    return _turnoverTips;
}


- (UIButton *)tapAction{
    if (!_tapAction) {
        _tapAction = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        
        
        [_tapAction addSubview:self.currentPriceLabel];
        [_tapAction addSubview:self.riseAndFallDescLabel];
        [_tapAction addSubview:self.openPriceLabel];
        [_tapAction addSubview:self.closePriceLabel];
        [_tapAction addSubview:self.volumeLabel];
        [_tapAction addSubview:self.turnoverRateLabel];
        [_tapAction addSubview:self.openTips];
        [_tapAction addSubview:self.closeTips];
        [_tapAction addSubview:self.volumeTips];
        [_tapAction addSubview:self.turnoverTips];
        [_tapAction addSubview:self.rightIcon];
        
        CGFloat bottomMargin = 20;
        
        
        CGFloat margin = 15;
        [self.currentPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
        [self.currentPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.currentPriceLabel autoSetDimension:ALDimensionHeight toSize:78];
        
        [self.riseAndFallDescLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomMargin];
        [self.riseAndFallDescLabel autoSetDimension:ALDimensionHeight toSize:22];
        [self.riseAndFallDescLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
        
        
        CGFloat otherLeftMargin = SCREENT_WIDTH/2;
        CGFloat otherTopMargin = 10;
        [self.openTips autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:otherTopMargin];
        [self.openTips autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:otherLeftMargin];
        [self.openPriceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.openTips withOffset:0];
        [self.openPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:otherLeftMargin];
        
        [self.closePriceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:otherLeftMargin];
        [self.closePriceLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomMargin];
        [self.closeTips autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:otherLeftMargin];
        [self.closeTips autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.closePriceLabel withOffset:0];
        
        
        
        [self.volumeTips autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:otherTopMargin];
        [self.volumeTips autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:otherLeftMargin + otherLeftMargin/2];
        [self.volumeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.volumeTips withOffset:0];
        [self.volumeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:otherLeftMargin + otherLeftMargin/2];
        
        [self.turnoverRateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:otherLeftMargin + otherLeftMargin/2];
        [self.turnoverRateLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomMargin];
        [self.turnoverTips autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:otherLeftMargin + otherLeftMargin/2];
        [self.turnoverTips autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.turnoverRateLabel withOffset:0];
        
        [self.rightIcon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:margin];
        [self.rightIcon autoSetDimensionsToSize:CGSizeMake(10, 10)];
        [self.rightIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [_tapAction addTarget:self action:@selector(clickLookDetailsStockInfoAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _tapAction;
}



- (UILabel *)configureLabelWithTextColor:(UIColor *)textColor font:(UIFont *)textFont alignment:(NSTextAlignment )alignment placeHolder:(NSString *)placeHolder{
    UILabel *label = [[UILabel alloc] init];
    label.text = placeHolder;
    label.textColor = textColor;
    label.font = textFont;
    label.textAlignment = alignment;
    return label;
}


- (ZNVerticalScreenContainer *)verContainer{
    if (!_verContainer) {
        _verContainer = [[ZNVerticalScreenContainer alloc] initWithFrame:CGRectMake(0, 120, SCREENT_WIDTH, 305)];
    }
    return _verContainer;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
    self.isLookDetailsInfo = NO;
    
    [self addSubview:self.verContainer];
    [self addSubview:self.tapAction];
    [self.tapAction autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 305, 0)];

}



- (void)dealloc{
    [self.verContainer cancelNetworkRequest];
    [self.rightIcon.layer removeAllAnimations];
    MyLog(@"头部销毁:%@",self);
}



- (void)setDetailsModel:(ZNStockDetailsInfoModel *)detailsModel{
    _detailsModel = detailsModel;
    if (detailsModel) {
        
        if (self.stockModel) {
            [self.verContainer startLoadingStockKlineDataWithStockCode:self.stockModel.stockCode YesterdayClosingPrice:detailsModel.close];
            
            if ([ZNStockDetailsInfoToolManager isIndexWithStockCode:self.stockModel.stockCode]) {
                self.turnoverTips.text = @"成交额";
                self.turnoverRateLabel.attributedText = [ZNStockDetailsInfoToolManager configureTurnoverShowWithTurnoverValue:detailsModel.turnover];
            }else{
                self.turnoverTips.text = @"换手率";
                self.turnoverRateLabel.text = @"9.99%";
            }
            
            
        }
        self.currentPriceLabel.text = [ZNStockDetailsInfoToolManager configureFloatStringWithOriginValue:detailsModel.currentPrice.floatValue];
        self.riseAndFallDescLabel.text = [ZNStockDetailsInfoToolManager configureAppliesAndForeheadWithOriginValue:detailsModel.forehead applies:detailsModel.applies];
        
        self.openPriceLabel.text = [ZNStockDetailsInfoToolManager configureFloatStringWithOriginValue:detailsModel.opening.floatValue];
        self.closePriceLabel.text = [ZNStockDetailsInfoToolManager configureFloatStringWithOriginValue:detailsModel.close.floatValue];
        
        CGFloat volumeFloatValue = detailsModel.volume.floatValue;
        NSString *volumeValue = [ZNStockDetailsInfoToolManager configureStockVolumeShowWithVolume:volumeFloatValue];
        NSString *volumeUnitDesc = [ZNStockDetailsInfoToolManager getStockVolumeUnitWithVolume:volumeFloatValue];
        NSMutableAttributedString *volumeAtt = [[NSMutableAttributedString alloc] initWithString:volumeValue];
        [volumeAtt appendAttributedString:[[NSAttributedString alloc] initWithString:volumeUnitDesc attributes:@{NSFontAttributeName:ZNCustomDinNormalFont(11)}]];

        self.volumeLabel.attributedText = volumeAtt;
        
    }
}


- (void)clickLookDetailsStockInfoAction{
    MyLog(@"点击查看详情的事件");
    
    CABasicAnimation *transformRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformRotationAnimation.fromValue = self.isLookDetailsInfo?@(M_PI):@0;
    transformRotationAnimation.toValue = self.isLookDetailsInfo?@0:@(M_PI);
    transformRotationAnimation.delegate = [ZNCABasedAnimationWeakDelegate ZNBasicAnimationWithDelegate:self];
    transformRotationAnimation.duration = 0.3f;
    transformRotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transformRotationAnimation.removedOnCompletion = NO;
    transformRotationAnimation.fillMode = kCAFillModeForwards;
    [self.rightIcon.layer addAnimation:transformRotationAnimation forKey:@"YukeReverseMove"];
    
}

- (void)ZNAnimationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    MyLog(@"自定义动画结束");
    if (finished) {
        self.isLookDetailsInfo = !self.isLookDetailsInfo;
    }
}

- (void)ZNAnimationDidStart:(CAAnimation *)anim{
    MyLog(@"自定义动画开始");
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZNStockDetailsHeaderView:didChangeLookDetailsState:)]) {
        [self.delegate ZNStockDetailsHeaderView:nil didChangeLookDetailsState:!self.isLookDetailsInfo];
    }
}

- (void)resetRightIconConfigure{
    if (self.isLookDetailsInfo) {
        [self clickLookDetailsStockInfoAction];
    }
}








@end
