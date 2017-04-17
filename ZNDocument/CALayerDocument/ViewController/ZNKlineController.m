//
//  ZNKlineController.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineController.h"
#import "ZNVerticalScreenContainer.h"

@interface ZNKlineController ()


@property(nonatomic, strong)ZNVerticalScreenContainer *verContainer;



@end

@implementation ZNKlineController


- (ZNVerticalScreenContainer *)verContainer{
    if (!_verContainer) {
        _verContainer = [[ZNVerticalScreenContainer alloc] initWithFrame:CGRectMake(0, 60, SCREENT_WIDTH, 305)];
    }
    return _verContainer;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor greenColor];
    
    
    [self.view addSubview:self.verContainer]; // sh000001 sz300104 31.83 3261.61
    [self.verContainer startLoadingStockKlineDataWithStockCode:@"sh601069" YesterdayClosingPrice:@"23.67"];
    
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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.verContainer cancelNetworkRequest];
}




@end
