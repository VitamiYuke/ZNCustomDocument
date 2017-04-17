//
//  ZNStockDetailsController.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/7.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNStockDetailsController.h"
#import "ZNStockDetailsControllerView.h"
@interface ZNStockDetailsController ()
@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;
@property(nonatomic, strong)ZNStockDetailsControllerView *controllerView;
@end

@implementation ZNStockDetailsController


- (ZNStockDetailsControllerView *)controllerView{
    if (!_controllerView) {
        _controllerView = [[ZNStockDetailsControllerView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, SCREENT_HEIGHT)];
    }
    return _controllerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    [self.view addSubview:self.controllerView];
    [self.controllerView startLoadingDataWithStockInfo:self.stockModel];
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:self.previousStatusBarStyle animated:YES];
}



@end
