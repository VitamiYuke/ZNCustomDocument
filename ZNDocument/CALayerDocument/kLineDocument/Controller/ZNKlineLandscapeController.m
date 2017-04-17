//
//  ZNKlineLandscapeController.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/28.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineLandscapeController.h"
#import "ZNLandscapeContainer.h"
#import "ZNKlineLandscapeTransitionAnimation.h"

@interface ZNKlineLandscapeController ()<UIViewControllerTransitioningDelegate>
@property(nonatomic, strong)ZNKlineLandscapeTransitionAnimation *animationProtocol;
@property(nonatomic, strong)ZNLandscapeContainer *landscapeContainer;

@end

@implementation ZNKlineLandscapeController


- (ZNLandscapeContainer *)landscapeContainer{
    if (!_landscapeContainer) {
        _landscapeContainer = [[ZNLandscapeContainer alloc] initWithFrame:CGRectMake(0, 0, SCREENT_HEIGHT, SCREENT_WIDTH)];
    }
    return _landscapeContainer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.transitioningDelegate = self;
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:bgView];
    bgView.transform = CGAffineTransformMakeRotation(M_PI_2);
    bgView.frame = CGRectMake(0, 0, SCREENT_WIDTH, SCREENT_HEIGHT);
    
    MyLog(@"bounds:%@ frame:%@",NSStringFromCGRect(bgView.bounds),NSStringFromCGRect(bgView.frame));
    
    [bgView addSubview:self.landscapeContainer];
    
    znWeakSelf(self);
    CGFloat closeSize = 30;
    ZNTestButton *closeBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(bgView.bounds.size.width - closeSize - 10,choiceFullScreenHeight/2 - closeSize/2, closeSize, closeSize) title:@"" action:^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    closeBtn.backgroundColor = [UIColor whiteColor];
    UIBezierPath *crossPath = [UIBezierPath bezierPath];
    CGFloat pointStandard = closeSize>15?(closeSize-15)/2:0;
    [crossPath moveToPoint:CGPointMake(pointStandard, pointStandard)];
    [crossPath addLineToPoint:CGPointMake(closeSize - pointStandard, closeSize - pointStandard)];
    [crossPath moveToPoint:CGPointMake(closeSize - pointStandard, pointStandard)];
    [crossPath addLineToPoint:CGPointMake(pointStandard, closeSize - pointStandard)];
    [closeBtn.layer addSublayer:[ZNStockBasedConfigureLib YukeToolGetShaperLayerWithFillColor:[UIColor clearColor] strokeColor:MyColor(240, 70, 80) lineWidth:1.5 path:crossPath]];
    [bgView addSubview:closeBtn];
    
    [self.landscapeContainer getKlineDataFromVerticalScreenWithArray:self.dataArray chartType:self.chartType stockCode:self.stockCode yesterdayClosingPrice:self.yesterdayClosingPrice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

#pragma mark - 跳转动画
- (ZNKlineLandscapeTransitionAnimation *)animationProtocol{
    if (!_animationProtocol) {
        _animationProtocol = [[ZNKlineLandscapeTransitionAnimation alloc] init];
    }
    return _animationProtocol;
}

//魔胎
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if ([presented isKindOfClass:[ZNKlineLandscapeController class]]) {
        self.animationProtocol.modalType = ZNTheModalTypePresent;
        return self.animationProtocol;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([dismissed isKindOfClass:[ZNKlineLandscapeController class]]) {
        self.animationProtocol.modalType = ZNTheModalTypeDismiss;
        return self.animationProtocol;
    }
    return nil;
}



@end
