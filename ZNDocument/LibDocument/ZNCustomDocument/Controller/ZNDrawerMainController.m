//
//  ZNDrawerMainController.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/19.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNDrawerMainController.h"

NSString *ZN_DRAWER_SHOW_LEFT  = @"ZN_DRAWER_SHOW_LEFT";
NSString *ZN_DRAWER_SHOW_RIGHT = @"ZN_DRAWER_SHOW_RIGHT";
NSString *ZN_DRAWER_DISMISS    = @"ZN_DRAWER_DISMISS";



typedef NS_ENUM(NSInteger, ZNDrawerShowState) {
    ZNDrawerShowStateNone  = 0,
    ZNDrawerShowStateLeft  = 1,
    ZNDrawerShowStateRight = 2,
};


@interface ZNDrawerMainController ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong)UIScreenEdgePanGestureRecognizer *leftPan;
@property(nonatomic, strong)UIScreenEdgePanGestureRecognizer *rightPan;
@property(nonatomic, strong)UIPanGestureRecognizer *dismissPan;
@property(nonatomic, strong)UITapGestureRecognizer *dismissTap;
@property(nonatomic, strong)UIView *maskView;


@end

@implementation ZNDrawerMainController{
    ZNDrawerShowState _showState;
    
    
    
}

+ (instancetype)zn_drawerViewControllerWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC{
    return [ZNDrawerMainController zn_drawerViewControllerWithLeftViewController:leftVC mainViewController:mainVC rightViewController:nil];
}

+ (instancetype)zn_drawerViewControllerWithMainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC
{
    return [ZNDrawerMainController zn_drawerViewControllerWithLeftViewController:nil mainViewController:mainVC rightViewController:rightVC];
}

+ (instancetype)zn_drawerViewControllerWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC
{
    return [[ZNDrawerMainController alloc] initWithLeftViewController:leftVC mainViewController:mainVC rightViewController:rightVC];
}

- (instancetype)initWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC{
    if ([super init]) {
        _leftViewController = leftVC;
        _mainViewController = mainVC;
        _rightViewController = rightVC;
        [self configureData];
        [self configureUI];
    }
    return self;
}

//初始化数据
- (void)configureData{
    _showState = ZNDrawerShowStateNone;
    _leftViewWidth = 300;
    _rightViewWidth = 300;
    _duration = 0.4;
    _canPan = YES;
    
}

- (void)configureUI{
    
    if (!self.mainViewController) {
        return;
    }
    
    if (self.leftViewController) {
        [self addLeftViewController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zn_showLeft:) name:ZN_DRAWER_SHOW_LEFT object:nil];
    }
    
    
    if (self.rightViewController) {
        [self addRightViewController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zn_showRights:) name:ZN_DRAWER_SHOW_RIGHT object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zn_dismiss:) name:ZN_DRAWER_DISMISS object:nil];
    [self addMainViewController];
    
}


#pragma mark - 显示和消失方法

- (void)_showLeftViewController:(BOOL)animated {
    
    [self configureMaskViewSuperView];
    CGFloat realDuration = _duration * ABS(_leftViewController.view.frame.origin.x / -_leftViewWidth);
    [UIView animateWithDuration:animated?realDuration:0 animations:^{
        CGRect leftFrame    = _leftViewController.view.frame;
        leftFrame.origin.x  = 0;
        _leftViewController.view.frame  = leftFrame;
        self.maskView.alpha = 0.4;
        CGRect mainFrame    = _mainViewController.view.frame;
        mainFrame.origin.x  = _leftViewWidth;
        _mainViewController.view.frame  = mainFrame;
        
    }];
    
    
    _showState = ZNDrawerShowStateLeft;
    [self mainViewControllerAddPan];
}

- (void)_hideViewController:(BOOL)animated {

    
    if (_showState == ZNDrawerShowStateLeft) {
        CGFloat realDuration = _duration * ABS((_leftViewWidth + _leftViewController.view.frame.origin.x) / _leftViewWidth);
        [UIView animateWithDuration:animated?realDuration:0 animations:^{
            CGRect leftFrame    = _leftViewController.view.frame;
            leftFrame.origin.x  = -_leftViewWidth;
            _leftViewController.view.frame  = leftFrame;
            self.maskView.alpha = 0.0;
            CGRect mainFrame    = _mainViewController.view.frame;
            mainFrame.origin.x  = 0;
            _mainViewController.view.frame  = mainFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                if (self.maskView.superview) {
                    [self.maskView removeFromSuperview];
                }
            }
        }];
        
    }
    
    
    
    if (_showState == ZNDrawerShowStateRight) {
        CGFloat realDuration = _duration * ABS(_mainViewController.view.frame.origin.x/ _rightViewWidth);
        [UIView animateWithDuration:animated?realDuration:0 animations:^{
            CGRect rightFrame    = _rightViewController.view.frame;
            rightFrame.origin.x  = self.view.frame.size.width;
            _rightViewController.view.frame  = rightFrame;
            self.maskView.alpha = 0;
            CGRect mainFrame    = _mainViewController.view.frame;
            mainFrame.origin.x  = 0;
            _mainViewController.view.frame  = mainFrame;
            
        } completion:^(BOOL finished) {
            if (finished) {
                if (self.maskView.superview) {
                    [self.maskView removeFromSuperview];
                }
            }
        }];
    }
    
    
    
    _showState = ZNDrawerShowStateNone;
     _mainViewController.view.userInteractionEnabled = YES;
    [self mainViewControllerAddPan];
}


- (void)_showRightViewController:(BOOL)animated {
    
    [self configureMaskViewSuperView];
    CGFloat realDuration = _duration * ABS(_mainViewController.view.frame.origin.x/ _rightViewWidth);
    [UIView animateWithDuration:animated?realDuration:0 animations:^{
        CGRect rightFrame    = _rightViewController.view.frame;
        rightFrame.origin.x  = self.view.frame.size.width - _rightViewWidth;
        _rightViewController.view.frame  = rightFrame;
        self.maskView.alpha = 0.4;
        CGRect mainFrame    = _mainViewController.view.frame;
        mainFrame.origin.x  = -_rightViewWidth;
        _mainViewController.view.frame  = mainFrame;
        
    }];
    
    
    _showState = ZNDrawerShowStateRight;
    [self mainViewControllerAddPan];
    
}


#pragma mark - 通知方法

- (void)zn_showLeft:(NSNotification *)sender{
    BOOL animated = sender.userInfo[@"animated"];
    
    if (_showState == ZNDrawerShowStateNone) {
        [self _showLeftViewController:animated];
    }
}

- (void)zn_showRights:(NSNotification *)sender{
    BOOL animated = sender.userInfo[@"animated"];
    if (_showState == ZNDrawerShowStateNone) {
        [self _showRightViewController:animated];
    }
}

- (void)zn_dismiss:(NSNotification *)sender{
    BOOL animated = sender.userInfo[@"animated"];
    [self _hideViewController:animated];
}

#pragma mark - set方法
- (void)setLeftViewWidth:(CGFloat)leftViewWidth{
    _leftViewWidth = leftViewWidth;
    if (_leftViewController) {
         _leftViewController.view.frame = CGRectMake(-_leftViewWidth, 0, _leftViewWidth, self.view.frame.size.height);
    }
}

- (void)setRightViewWidth:(CGFloat)rightViewWidth{
    _rightViewWidth = rightViewWidth;
    if (_rightViewController) {
       _rightViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, _rightViewWidth, self.view.frame.size.height);
    }
}


#pragma mark - 主控制器添加手势
- (void)mainViewControllerAddPan{
    
    if (_showState == ZNDrawerShowStateNone) {//什么都没显示  这时添加显示的
//        [_mainViewController.view removeGestureRecognizer:self.dismissPan];
//        [_mainViewController.view removeGestureRecognizer:self.dismissTap];
        
        if (self.leftViewController) {
            [_mainViewController.view addGestureRecognizer:self.leftPan];
        }
        
        if (self.rightViewController) {
            [_mainViewController.view addGestureRecognizer:self.rightPan];
        }
        
    }else{
        
//        [_mainViewController.view addGestureRecognizer:self.dismissTap];
//        [_mainViewController.view addGestureRecognizer:self.dismissPan];
        
        if (self.leftViewController) {
            [_mainViewController.view removeGestureRecognizer:self.leftPan];
        }
        
        if (self.rightViewController) {
            [_mainViewController.view removeGestureRecognizer:self.rightPan];
        }
    }
    
}

#pragma mark - 添加控制器
- (void)addMainViewController {
    [self addChildViewController:_mainViewController];
    _mainViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_mainViewController.view];
    [_mainViewController didMoveToParentViewController:self];

    [self mainViewControllerAddPan];
}

- (void)addLeftViewController {
    [self addChildViewController:_leftViewController];

    _leftViewController.view.frame = CGRectMake(-_leftViewWidth, 0, _leftViewWidth, self.view.frame.size.height);
    [self.view addSubview:_leftViewController.view];
    [_leftViewController didMoveToParentViewController:self];
}

- (void)addRightViewController {
    [self addChildViewController:_rightViewController];
 
    _rightViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, _rightViewWidth, self.view.frame.size.height);
    
    [_rightViewController didMoveToParentViewController:self];
    [self.view addSubview:_rightViewController.view];
}




#pragma mark - 手势
- (UIScreenEdgePanGestureRecognizer *)leftPan{
    if (!_leftPan) {
        _leftPan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(showPanAction:)];
        _leftPan.edges = UIRectEdgeLeft;
        _leftPan.delegate = self;
    }
    return _leftPan;
}

- (UIScreenEdgePanGestureRecognizer *)rightPan{
    if (!_rightPan) {
        _rightPan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(showPanAction:)];
        _rightPan.edges = UIRectEdgeRight;
        _rightPan.delegate = self;
    }
    return _rightPan;
}

- (UIPanGestureRecognizer *)dismissPan{
    if (!_dismissPan) {
        _dismissPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPanAction:)];
    }
    return _dismissPan;
}

- (UITapGestureRecognizer *)dismissTap{
    if (!_dismissTap) {
        _dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTapAction:)];
    }
    return _dismissTap;
}

//方法
//显示
- (void)showPanAction:(UIScreenEdgePanGestureRecognizer *)sender{
    if (!self.canPan) {
        MyLog(@"不让有手势");
        return;
    }
    
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        

        if (!_mainViewController.isViewLoaded) {
            MyLog(@"都没加载弄啥咧");
            return;
        }
        
        
        if (!_mainViewController.view.window) {
            MyLog(@"当前没有显示");
            return;
        }
        
        
        

        _mainViewController.view.userInteractionEnabled = NO;
        
        if (sender.edges == UIRectEdgeLeft) {//左视图
            _showState = ZNDrawerShowStateLeft;
        }
        
        if (sender.edges == UIRectEdgeRight) {
            _showState = ZNDrawerShowStateRight;
        }
        
        [self configureMaskViewSuperView];
    }
    
    
    
    
    
    CGPoint pt = [sender translationInView:sender.view];
    MyLog(@"移动的坐标:%@",NSStringFromCGPoint(pt));
    CGRect mainViewFrame = _mainViewController.view.frame;
    mainViewFrame.origin.x += pt.x;
    
    CGFloat WorseThan = 0 ;
    if (sender.edges == UIRectEdgeLeft) {//左视图
        if (mainViewFrame.origin.x > _leftViewWidth) {
            mainViewFrame.origin.x = _leftViewWidth;
        }
        
        if (mainViewFrame.origin.x < 0) {
            mainViewFrame.origin.x = 0;
        }
        
        CGRect leftViewFrame = _leftViewController.view.frame;
        leftViewFrame.origin.x += pt.x;
        
        if (leftViewFrame.origin.x > 0) {
            leftViewFrame.origin.x = 0;
        }
        
        
        if (leftViewFrame.origin.x < -_leftViewWidth) {
            leftViewFrame.origin.x = -_leftViewWidth;
        }
        _leftViewController.view.frame = leftViewFrame;
        
        WorseThan = mainViewFrame.origin.x/_leftViewWidth;
        
    }
    
    if (sender.edges == UIRectEdgeRight) {
        
        if (mainViewFrame.origin.x > 0) {
            mainViewFrame.origin.x = 0;
        }
        
        if (mainViewFrame.origin.x < -_rightViewWidth) {
            mainViewFrame.origin.x = -_rightViewWidth;
        }
        
        
        CGRect rightViewFrame = _rightViewController.view.frame;
        rightViewFrame.origin.x += pt.x;
        
        if (rightViewFrame.origin.x > self.view.frame.size.width) {
            rightViewFrame.origin.x = self.view.frame.size.width;
        }
        
        if (rightViewFrame.origin.x < self.view.frame.size.width - _rightViewWidth) {
            rightViewFrame.origin.x = self.view.frame.size.width - _rightViewWidth;
        }
        
        _rightViewController.view.frame = rightViewFrame;
        
        WorseThan =  - mainViewFrame.origin.x/_rightViewWidth;
    }
    
    _mainViewController.view.frame = mainViewFrame;
    
    self.maskView.alpha = 0.05 + 0.35 * WorseThan;
    

    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (sender.edges == UIRectEdgeLeft) {
            if (_mainViewController.view.frame.origin.x > _leftViewWidth/2.0){
                [self _showLeftViewController:YES];
            }else{
                [self _hideViewController:YES];
            }
        }
        
        
        if (sender.edges == UIRectEdgeRight) {
            if (_mainViewController.view.frame.origin.x < -_rightViewWidth/2.0) {
                [self _showRightViewController:YES];
            } else {
                [self _hideViewController:YES];
            }
        }
        
        _mainViewController.view.userInteractionEnabled = YES;
    }
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
    
}

//消失
- (void)dismissPanAction:(UIPanGestureRecognizer *)sender{
    if (!self.canPan) {
        MyLog(@"不让有手势");
        return;
    }
    
    CGPoint pt = [sender translationInView:sender.view];
    MyLog(@"移动的坐标:%@",NSStringFromCGPoint(pt));
    CGRect mainViewFrame = _mainViewController.view.frame;
    mainViewFrame.origin.x += pt.x;
    
    
    CGFloat WorseThan = 0 ;
    if (_showState == ZNDrawerShowStateLeft) {//左视图
        if (mainViewFrame.origin.x > _leftViewWidth) {
            mainViewFrame.origin.x = _leftViewWidth;
        }
        
        if (mainViewFrame.origin.x < 0) {
            mainViewFrame.origin.x = 0;
        }
        
        CGRect leftViewFrame = _leftViewController.view.frame;
        leftViewFrame.origin.x += pt.x;
        
        if (leftViewFrame.origin.x > 0) {
            leftViewFrame.origin.x = 0;
        }
        
        
        if (leftViewFrame.origin.x < -_leftViewWidth) {
            leftViewFrame.origin.x = -_leftViewWidth;
        }
        _leftViewController.view.frame = leftViewFrame;
        
        WorseThan = mainViewFrame.origin.x/_leftViewWidth;
    }
    
    if (_showState == ZNDrawerShowStateRight) {
        
        if (mainViewFrame.origin.x > 0) {
            mainViewFrame.origin.x = 0;
        }
        
        if (mainViewFrame.origin.x < -_rightViewWidth) {
            mainViewFrame.origin.x = -_rightViewWidth;
        }
        
        CGRect rightViewFrame = _rightViewController.view.frame;
        rightViewFrame.origin.x += pt.x;
        
        if (rightViewFrame.origin.x > self.view.frame.size.width) {
            rightViewFrame.origin.x = self.view.frame.size.width;
        }
        
        if (rightViewFrame.origin.x < self.view.frame.size.width - _rightViewWidth) {
            rightViewFrame.origin.x = self.view.frame.size.width - _rightViewWidth;
        }
        
        _rightViewController.view.frame = rightViewFrame;
        
        WorseThan =  - mainViewFrame.origin.x/_rightViewWidth;
    }
    
    
    _mainViewController.view.frame = mainViewFrame;
    
    self.maskView.alpha = 0.05 + 0.35 * WorseThan;
    if (sender.state == UIGestureRecognizerStateBegan) {
        _mainViewController.view.userInteractionEnabled = NO;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {

        if (_showState == ZNDrawerShowStateLeft) {
            if (_mainViewController.view.frame.origin.x > _leftViewWidth/2.0){
                [self _showLeftViewController:YES];
            }else{
                [self _hideViewController:YES];
            }
        }
        
        
        if (_showState == ZNDrawerShowStateRight) {
            if (_mainViewController.view.frame.origin.x < -_rightViewWidth/2.0) {
                [self _showRightViewController:YES];
            } else {
                [self _hideViewController:YES];
            }
        }
        
        
        _mainViewController.view.userInteractionEnabled = YES;
    }
    
    [sender setTranslation:CGPointZero inView:sender.view];

}

- (void)dismissTapAction:(UITapGestureRecognizer *)sender{
    
    [self _hideViewController:YES];
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


#pragma mark - 遮罩
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.05;
        [_maskView addGestureRecognizer:self.dismissPan];
        [_maskView addGestureRecognizer:self.dismissTap];
    }
    return _maskView;
}

- (void)configureMaskViewSuperView{
    if (!self.maskView.superview) {
        [_mainViewController.view addSubview:self.maskView];
        [self.maskView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)dealloc{
    MyLog(@"销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
