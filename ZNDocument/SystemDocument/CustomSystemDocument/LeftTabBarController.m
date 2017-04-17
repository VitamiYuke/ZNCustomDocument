//
//  LeftTabBarController.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/23.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "LeftTabBarController.h"

@interface LeftTabBarController ()

@end

@implementation LeftTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZNTestButton *abnormalBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(20, 20, 60, 30) title:@"异常" action:^{
//        @throw [NSException exceptionWithName:@"异常测试" reason:@"原因" userInfo:@{@"name":@"zhangnanboy"}];
        
    }];
    [self.view addSubview:abnormalBtn];
    
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

@end
