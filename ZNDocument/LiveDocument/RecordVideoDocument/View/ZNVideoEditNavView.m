//
//  ZNVideoEditNavView.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/9.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNVideoEditNavView.h"
#import <LCActionSheet.h>


@interface ZNVideoEditNavView ()


@property(nonatomic,strong)UIButton *leftItemBtn;
@property(nonatomic, strong)UIButton *rightItemBtn;



@end



@implementation ZNVideoEditNavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)defaultVideoNav{
    ZNVideoEditNavView *navView = [[ZNVideoEditNavView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, 64)];
    return navView;
}


- (UIButton *)leftItemBtn{
    if (!_leftItemBtn) {
        _leftItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftItemBtn setImage:[UIImage imageNamed:@"navBackRed"] forState:UIControlStateNormal];
        [_leftItemBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _leftItemBtn.frame = CGRectMake(0, 64-8 - 30, 30, 30);
    }
    return _leftItemBtn;
}

- (UIButton *)rightItemBtn{
    if (!_rightItemBtn) {
        _rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightItemBtn setImage:[UIImage imageNamed:@"delete_recored"] forState:UIControlStateNormal];
        [_rightItemBtn addTarget:self action:@selector(editVideoAction) forControlEvents:UIControlEventTouchUpInside];
        _rightItemBtn.frame = CGRectMake(SCREENT_WIDTH - 9.5 - 30, 64-8 - 30, 30, 30);
    }
    return _rightItemBtn;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}


- (void)configureUI{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.leftItemBtn];
//    [self.leftItemBtn autoSetDimensionsToSize:CGSizeMake(30, 30)];
//    [self.leftItemBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//    [self.leftItemBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    
    
    [self addSubview:self.rightItemBtn];
//    [self.rightItemBtn autoSetDimensionsToSize:CGSizeMake(30, 30)];
//    [self.rightItemBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:4.5];
//    [self.rightItemBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
}


- (void)showAnimation{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.height = 64;
        self.leftItemBtn.y = self.height - 30 - 8;
        self.rightItemBtn.y = self.height - 30 - 8;
    }];
    
    
    
    
}

- (void)hiddenAnimation{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.3 animations:^{
        self.height = 0;
        self.leftItemBtn.y = self.height - 30 - 8;
        self.rightItemBtn.y = self.height - 30 - 8;
    }];
}

- (void)backAction{
    UIViewController *controller = [ZNRegularHelp getCurrentShowViewController];
    if (controller) {
        [controller.navigationController popViewControllerAnimated:YES];
    }
}


- (void)restConfigureBecauseOfControllerWillDisappear{
    if (!self.height) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        self.height = 64;
        self.leftItemBtn.y = self.height - 30 - 8;
        self.rightItemBtn.y = self.height - 30 - 8;
    }
}


//编辑视频
- (void)editVideoAction{
    MyLog(@"编辑视频");
    LCActionSheet *editVideoSheet = [[LCActionSheet alloc] initWithTitle:@"要删除此视频嘛?" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.deleteVideoAction) {
                self.deleteVideoAction();
            }
            
            
            [self backAction];
        }
    } otherButtonTitles:@"删除", nil];
    [editVideoSheet show];
}

- (void)dealloc{
    MyLog(@"编辑视频导航销毁");
}

@end
