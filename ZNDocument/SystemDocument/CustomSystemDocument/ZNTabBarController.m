//
//  ZNTabBarController.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/23.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNTabBarController.h"
#import "ZNNavigationController.h"
#import "LeftTabBarController.h"
#import "RightTabBarController.h"
#import "ZNTableViewController.h"
@interface ZNTabBarController ()<UITabBarControllerDelegate>

@end

@implementation ZNTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    // 
    [self addChildVc:[[LeftTabBarController alloc] init] title:@"👈" image:@"shouye1" selectedImage:@"shouye2"];
    [self addChildVc:[[ZNTableViewController alloc] initWithStyle:UITableViewStylePlain] title:@"中间" image:@"gaoshou1" selectedImage:@"gaoshou2"];
    [self addChildVc:[[RightTabBarController alloc] init] title:@"👉" image:@"neican1" selectedImage:@"neican2"];
    
    self.selectedIndex = 1;
    
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

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = MyColor(123, 123, 123);
    textAttrs[NSFontAttributeName] = MyFont(13);
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = MyColor(254, 72, 74);
    selectTextAttrs[NSFontAttributeName] = MyFont(13);
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //    childVc.view.backgroundColor = [UIColor whiteColor];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    ZNNavigationController *nav = [[ZNNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    nav.navigationBar.tintColor = MyColor(254, 72, 74);
    [self addChildViewController:nav];
}

- (void)dealloc
{
    MyLog(@"%@销毁",self);
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}




@end
