//
//  ZNStartTestController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/9/2.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNStartTestController.h"
#import "ZNGradualChangeStartController.h"
#import "ZNKeepGuidePageController.h"
@interface ZNStartTestController ()

@end

@implementation ZNStartTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    ZNTestButton *gradualChange = [[ZNTestButton alloc] initWithFrame:CGRectMake(10, 10, 60, 30) title:@"渐变" action:^{
        ZNGradualChangeStartController *gradualStart = [[ZNGradualChangeStartController alloc] initWithCoverImageNames:@[@"gradual_index_01txt", @"gradual_index_02txt", @"gradual_index_03txt"] backgroundImageNames:@[@"gradual_index_01bg", @"gradual_index_02bg", @"gradual_index_03bg"]];
        [weakSelf.navigationController pushViewController:gradualStart animated:YES];
    }];

    [self.view addSubview:gradualChange];
    
    
    ZNTestButton *keepBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradualChange.frame) + 10, 10, 60, 30) title:@"keep" action:^{
        [weakSelf.navigationController pushViewController:[[ZNKeepGuidePageController alloc] init] animated:YES];
    }];
    [self.view addSubview:keepBtn];
    

    
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



@end
