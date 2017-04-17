//
//  ZNCustomChooseSelectedView.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNCustomChooseSelectedView.h"



@interface ZNCustomChooseSelectedView ()
{
    UIColor *_highlightColor;
    UIColor *_normalColor;
    NSArray *_titlesArray;
    CGFloat defaultHeight;
    CGFloat unitWidth;
    NSInteger choicedIndex;
}

@property(nonatomic, strong)UIView *bottomAnimationView;

@property(nonatomic, strong)UIButton *selectedBtn;

@property(nonatomic, strong)NSMutableArray *configureBtn;//配置的按钮

@property(nonatomic, strong)UIView *topLine;
@property(nonatomic, strong)UIView *bottomLine;


@end


@implementation ZNCustomChooseSelectedView


- (NSMutableArray *)configureBtn{
    if (!_configureBtn) {
        _configureBtn = [NSMutableArray array];
    }
    return _configureBtn;
}

- (void)refreshSelectedTypeWithIndex:(NSInteger)index{
    if (index >= 0 && index < self.configureBtn.count) {
        UIButton *sender = self.configureBtn[index];
        
        if (sender == self.selectedBtn) {
            MyLog(@"没有改变选择");
            return;
        }
        [self refreshBecauseOfActionBtn:sender];
    }
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _topLine.backgroundColor = MyColor(223, 223, 223);
    }
    return _topLine;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, defaultHeight - 0.5, self.width, 0.4)];
        _bottomLine.backgroundColor = MyColor(223, 223, 223);
    }
    return _bottomLine;
}



- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray<NSString *> *)titlesArray highlightColor:(UIColor *)highlightColor normalColor:(UIColor *)normalColor choicedIndex:(NSInteger)index
{
    if ([super initWithFrame:frame]) {
        _highlightColor = highlightColor;
        _normalColor = normalColor;
        _titlesArray = titlesArray;
        defaultHeight = frame.size.height;
        choicedIndex = index;
        [self configureUI];
    }
    return self;
}


- (void)configureUI{
    
    CGFloat width = self.frame.size.width;
    
    if (_titlesArray.count > 0) {
        unitWidth = width / _titlesArray.count;
        
        for (int i = 0; i < _titlesArray.count; i++) {
            NSString *title = _titlesArray[i];
            UIButton *operationBtn = [self configureOperationBtnWithTitle:title];
            operationBtn.frame = CGRectMake(unitWidth * i, 2, unitWidth, defaultHeight - 4);
            operationBtn.tag = 6666 + i;
            [self addSubview:operationBtn];
            [self.configureBtn addObject:operationBtn];
            
            if (i == choicedIndex) {
                [self.selectedBtn setSelected:NO];
                self.selectedBtn = operationBtn;
                [self.selectedBtn setSelected:YES];
            }
            
        }
        
        
        //底部动画
        self.bottomAnimationView.x = unitWidth/2 - 30 + CGRectGetMinX(self.selectedBtn.frame);
        [self addSubview:self.bottomAnimationView];
        
    }
    
}

- (UIButton *)configureOperationBtnWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:_normalColor forState:UIControlStateNormal];
    [btn setTitleColor:_highlightColor forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)operationAction:(UIButton *)sender
{
    if (sender == self.selectedBtn) {
        MyLog(@"根本没有改变选择");
        return;
    }
    
    MyLog(@"选择的操作:%@",sender.currentTitle);
    NSString *currentTitle = sender.currentTitle;
    CGFloat selectedX = CGRectGetMinX(sender.frame);
    [self.selectedBtn setSelected:NO];
    self.selectedBtn = sender;
    [self.selectedBtn setSelected:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomAnimationView.x = unitWidth/2 - 30 + selectedX;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZNCustomSelectedViewChoiceTitle:index:)]) {
        [self.delegate ZNCustomSelectedViewChoiceTitle:currentTitle index:sender.tag - 6666];
    }
    
    
}

- (void)refreshBecauseOfActionBtn:(UIButton *)sender
{
    CGFloat selectedX = CGRectGetMinX(sender.frame);
    [self.selectedBtn setSelected:NO];
    self.selectedBtn = sender;
    [self.selectedBtn setSelected:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomAnimationView.x = unitWidth/2 - 30 + selectedX;
    }];
}



- (UIView *)bottomAnimationView
{
    if (!_bottomAnimationView) {
        _bottomAnimationView = [[UIView alloc] initWithFrame:CGRectMake(0, defaultHeight - 2, 60, 1.5)];
        _bottomAnimationView.backgroundColor = _highlightColor;
    }
    return _bottomAnimationView;
}

- (void)configureLineWihtIsHaveTop:(BOOL)top isHaveBottom:(BOOL)bottom lineColor:(UIColor *)color{
    
    [self.topLine removeFromSuperview];
    [self.bottomLine removeFromSuperview];
    
    if (top) {
        self.topLine.backgroundColor = color;
        [self addSubview:self.topLine];
    }
    
    if (bottom) {
        self.bottomLine.backgroundColor = color;
        [self addSubview:self.bottomLine];
    }
    
}



@end
