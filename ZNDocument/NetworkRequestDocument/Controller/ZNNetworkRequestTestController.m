//
//  ZNNetworkRequestTestController.m
//  ZNDocument
//
//  Created by 张楠 on 16/9/29.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNNetworkRequestTestController.h"
#import "ZNNetworkRequestCL.h"
@interface ZNNetworkRequestTestController ()

@end

@implementation ZNNetworkRequestTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    ZNTestButton *requestBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(10, 10, 120, 40) title:@"开始请求" action:^{
        [weakSelf startRequestAction];
    }];
    [self.view addSubview:requestBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startRequestAction
{
//    NSDictionary *parameter = @{@"act":@"login",@"account":@"15011448363",@"passwd":@"qwer1234"};
    [ZNNetworkRequestCL postWithUrl:@"http://120.25.226.186:32812/login" parameter:@"username=520it&pwd=520it&type=JSON" succFinish:^(id responseObject) {
        MyLog(@"请求结果%@",responseObject);
    } faile:^(NSError *error) {
        
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
