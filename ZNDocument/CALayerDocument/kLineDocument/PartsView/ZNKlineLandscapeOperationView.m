//
//  ZNKlineLandscapeOperationView.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/7.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineLandscapeOperationView.h"



@interface ZNKlineLandscapeOperationView ()

@property(nonatomic, strong)UIButton *beforePriceBtn;
@property(nonatomic, strong)UIButton *afterPriceBtn;
@property(nonatomic, strong)UIButton *selectedBtn;

@end




@implementation ZNKlineLandscapeOperationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIButton *)beforePriceBtn{
    if (!_beforePriceBtn) {
        _beforePriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _beforePriceBtn.titleLabel.font = ZNCustomDinNormalFont(10);
        [_beforePriceBtn setTitle:@"不复权" forState:UIControlStateNormal];
        [_beforePriceBtn setTitleColor:MyColor(112, 127, 139) forState:UIControlStateNormal];
        [_beforePriceBtn setTitleColor:MyColor(35, 125, 251) forState:UIControlStateSelected];
        [_beforePriceBtn addTarget:self action:@selector(notAnswerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beforePriceBtn;
}


- (UIButton *)afterPriceBtn{
    if (!_afterPriceBtn) {
        _afterPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _afterPriceBtn.titleLabel.font = ZNCustomDinNormalFont(10);
        [_afterPriceBtn setTitle:@"前复权" forState:UIControlStateNormal];
        [_afterPriceBtn setTitleColor:MyColor(112, 127, 139) forState:UIControlStateNormal];
        [_afterPriceBtn setTitleColor:MyColor(35, 125, 251) forState:UIControlStateSelected];
        [_afterPriceBtn addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _afterPriceBtn;
}



- (instancetype)init{
    if ([super init]) {
        [self configureUI];
    }
    return self;
}


- (void)configureUI{
    [self.layer setBorderWidth:0.5];
    [self.layer setBorderColor:MyColor(203, 215, 224).CGColor];
    
    [self addSubview:self.beforePriceBtn];
    [self addSubview:self.afterPriceBtn];
    [self.beforePriceBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.beforePriceBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.beforePriceBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.beforePriceBtn autoSetDimension:ALDimensionHeight toSize:20];
    
    [self.afterPriceBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.beforePriceBtn withOffset:5];
    [self.afterPriceBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.afterPriceBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.afterPriceBtn autoSetDimension:ALDimensionHeight toSize:20];
    
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MyColor(203, 215, 224);
    [self addSubview:line];
    [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.afterPriceBtn withOffset:10];
    [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:2];
    [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:2];
    [line autoSetDimension:ALDimensionHeight toSize:0.5];
    
    
    if ([[ZNUserDefault objectForKey:@"Authority"] isEqualToString:@"yes"] || !strIsEmpty([ZNUserDefault objectForKey:@"Authority"])) {//前权
        [self configureSelectedBtnWithBtn:self.afterPriceBtn];
    }else{
         [self configureSelectedBtnWithBtn:self.beforePriceBtn];
    }
    
    
    
}


- (void)notAnswerAction:(UIButton *)sender{
    MyLog(@"不复权");
    if (self.selectedBtn == sender) {
        MyLog(@"就是这个改个锤子🔨");
        return;
    }
    
    
    [ZNUserDefault setObject:@"no" forKey:@"Authority"];
    [self configureSelectedBtnWithBtn:sender];
    [self configureDelegate];
    
}

- (void)answerAction:(UIButton *)sender{
    MyLog(@"前复权");
    if (self.selectedBtn == sender) {
        MyLog(@"就是这个改个锤子🔨");
        return;
    }
    [ZNUserDefault setObject:@"yes" forKey:@"Authority"];
    [self configureSelectedBtnWithBtn:sender];
    [self configureDelegate];
}


- (void)configureDelegate{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZNKlineOperationHaveChanged)]) {
        [self.delegate ZNKlineOperationHaveChanged];
    }
}


- (void)configureSelectedBtnWithBtn:(UIButton *)sender{
    [self.selectedBtn setSelected:NO];
    self.selectedBtn = nil;
    self.selectedBtn = sender;
    [self.selectedBtn setSelected:YES];
}



@end
