//
//  LeftTabBarController.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/23.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "LeftTabBarController.h"
#import "ZNSlideMenu.h"

@interface LeftTabBarController ()<ZNSlideMenuDelegate>

@property(nonatomic,strong)UIButton *trigger;

@property(nonatomic, strong)ZNSlideMenu *slideMenu;

@end

@implementation LeftTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZNTestButton *abnormalBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(20, 20, 60, 30) title:@"异常" action:^{
//        @throw [NSException exceptionWithName:@"异常测试" reason:@"原因" userInfo:@{@"name":@"zhangnanboy"}];
        
    }];
    [self.view addSubview:abnormalBtn];
    
    
    
    znWeakSelf(self);
    ZNTestButton *currentControllerBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(20, 60, 100, 30) title:@"当前控制器" action:^{
        [weakSelf getCurrentController];
        
    }];
    [self.view addSubview:currentControllerBtn];
    
    [self.view addSubview:self.trigger];
    
}





- (UIButton *)trigger{
    if (!_trigger) {
        _trigger = [UIButton buttonWithType:UIButtonTypeCustom];
        _trigger.frame = CGRectMake(SCREENT_WIDTH - 100 - 20, SCREENT_HEIGHT - 50 - 36 - 10 - 64, 100, 36);
        [_trigger setTitle:@"Trigger" forState:UIControlStateNormal];
        [_trigger setTitleColor:MyColor(0, 188, 255) forState:UIControlStateNormal];
        _trigger.titleLabel.font = MyFont(20);
        [_trigger addTarget:self action:@selector(triggerAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _trigger;
}

- (ZNSlideMenu *)slideMenu
{
    if (!_slideMenu) {
        _slideMenu = [[ZNSlideMenu alloc] initWithTitile:@[@"首页",@"消息",@"发布",@"发现",@"个人"]];
        _slideMenu.menuClickBlock = ^(NSInteger index,NSString *title) {
            MyLog(@"第%ld个的标题是%@",index,title);
        };
        _slideMenu.delegate = self;
    }
    return _slideMenu;
}

- (void)triggerAction:(UIButton *)sender
{
    MyLog(@"SlideMenu"); // 只有加载到window上的第一个View才会往上移动
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.slideMenu trigger];
}


- (void)getCurrentController{
    [ZNRegularHelp getCurrentShowViewController];
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


#pragma mark - 侧滑消失
- (void)finishHidden
{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

@end
