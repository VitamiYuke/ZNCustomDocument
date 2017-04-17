//
//  ZNStockDetailsCustomNavView.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/10.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNStockDetailsCustomNavView.h"
#import "ZNSearchStockModel.h"
@interface ZNStockDetailsCustomNavView ()
@property(nonatomic, strong)UIButton *disMissBtn;
@property(nonatomic, strong)UILabel *stockInfoLabel;
@property(nonatomic, strong)UILabel *timeInfoLabel;
@end



@implementation ZNStockDetailsCustomNavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIButton *)disMissBtn{
    if (!_disMissBtn) {
        _disMissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disMissBtn setImage:[UIImage imageNamed:@"navBackWhite"] forState:UIControlStateNormal];
        [_disMissBtn setImage:[UIImage imageNamed:@"navBackWhite"] forState:UIControlStateHighlighted];
        [_disMissBtn addTarget:self action:@selector(disMissAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disMissBtn;
}

- (UILabel *)stockInfoLabel{
    if (!_stockInfoLabel) {
        _stockInfoLabel = [[UILabel alloc] init];
        _stockInfoLabel.textColor = [UIColor whiteColor];
        _stockInfoLabel.font = ZNCustomDinMediumFont(15);
        _stockInfoLabel.text = @"-----";
        _stockInfoLabel.backgroundColor = [UIColor clearColor];
    }
    return _stockInfoLabel;
}

- (UILabel *)timeInfoLabel{
    if (!_timeInfoLabel) {
        _timeInfoLabel = [[UILabel alloc] init];
        _timeInfoLabel.textColor = [UIColor whiteColor];
        _timeInfoLabel.font = ZNCustomDinMediumFont(12);
        _timeInfoLabel.text = @"-----";
        _timeInfoLabel.backgroundColor = [UIColor clearColor];
    }
    return _timeInfoLabel;
}



- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
    [self addSubview:self.disMissBtn];
    [self.disMissBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [self.disMissBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:22];
    [self.disMissBtn autoSetDimensionsToSize:CGSizeMake(30, 30)];
    
    [self addSubview:self.stockInfoLabel];
    [self.stockInfoLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:22];
    [self.stockInfoLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
    [self addSubview:self.timeInfoLabel];
    [self.timeInfoLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [self.timeInfoLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
}


- (void)disMissAction{
    MyLog(@"消失的方法");
    UIViewController *showController = [ZNRegularHelp getCurrentShowViewController];
    if (showController) {
        [showController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}


- (void)setStockModel:(ZNSearchStockModel *)stockModel{
    _stockModel = stockModel;
    self.stockInfoLabel.text = [NSString stringWithFormat:@"%@（%@）",stockModel.stockName,stockModel.stockSymbol];
}

- (void)setDetaisDescString:(NSString *)detaisDescString{
    _detaisDescString = detaisDescString;
    self.timeInfoLabel.text = detaisDescString;
}




@end
