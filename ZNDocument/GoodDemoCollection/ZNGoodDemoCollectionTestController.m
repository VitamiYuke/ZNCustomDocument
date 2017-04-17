//
//  ZNGoodDemoCollectionTestController.m
//  ZNDocument
//
//  Created by 张楠 on 17/2/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNGoodDemoCollectionTestController.h"
#import "YYRootViewController.h"
@interface ZNGoodDemoCollectionTestController ()

@end

@implementation ZNGoodDemoCollectionTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    znWeakSelf(self);
    ZNTestButton *previewAction = [[ZNTestButton alloc] initWithFrame:CGRectMake(50, 50, 80, 60) title:@"YYKit" action:^{
        [weakSelf goToUITableViewOptimize];
    }];
    [self.view addSubview:previewAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//列表优化的界面
- (void)goToUITableViewOptimize{
    MyLog(@"去列表优化");

    
    YYRootViewController *root = [YYRootViewController new];
    YYExampleNavController *nav = [[YYExampleNavController alloc] initWithNavigationBarClass:[YYExampleNavBar class] toolbarClass:[UIToolbar class]];
    if ([nav respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        nav.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [nav addChildViewController:root];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
