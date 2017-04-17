//
//  ZNNavigationController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/8.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNNavigationController.h"
#import "ZNTableViewController.h"
@interface ZNNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property(nonatomic, weak)UIViewController *currentShowVC;

@end

@implementation ZNNavigationController

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


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    MyLog(@"将要push进来的控制器%@",viewController);
    
    if (self.viewControllers.count > 0) {
        if (![viewController isKindOfClass:[ZNTableViewController class]]) { // 第一个tableView界面
            viewController.navigationItem.leftBarButtonItems = @[[UIBarButtonItem itemWithSpacer],[UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"navBackRed"] HighlightedImage:[UIImage imageNamed:@"navBackRed"] target:self action:@selector(clickBackAction)]];
        }
        
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        
    }
    [super pushViewController:viewController animated:animated];
}


- (void)clickBackAction
{
    [self popViewControllerAnimated:YES];
}



+ (void)initialize
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = CommonRed;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置全局的navBar
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionary];
    titleAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [navBar setTitleTextAttributes:titleAttrs];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.tintColor = MyColor(254, 72, 74);
        [self.navigationBar setTranslucent:NO];
        self.delegate = self;
        self.interactivePopGestureRecognizer.delegate = self;
    }
    return self;
}

#pragma mark - 侧滑手势的重构
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    MyLog(@"%@已经push完毕",viewController);
    if (navigationController.viewControllers.count == 1) {
        MyLog(@"根控制器");
        self.currentShowVC = nil;
    } else {
        self.currentShowVC = viewController;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        
        if (self.currentShowVC == self.topViewController) {
            return YES;
        }
        //如果 currentShowVC 不存在，禁用侧滑手势。如果在根控制器中不禁用侧滑手势，而且不小心触发了侧滑手势，会导致存放控制器的堆栈混乱，直接的效果就是你发现你的应用假死了，点哪都没反应，感兴趣是神马效果的朋友可以自己试试 = =。
        return NO;
    }
    
    return YES;
}

//获取侧滑返回手势




@end
