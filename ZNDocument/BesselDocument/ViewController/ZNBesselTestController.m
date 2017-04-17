//
//  ZNBesselTestController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/15.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNBesselTestController.h"
#import "ZNBesselView.h"
#import "ZNCanOperationImageView.h"
#import "ZNDownProgress.h"
@interface ZNBesselTestController ()<ZNDownProgressClickDelegate>

@property(nonatomic, strong)ZNDownProgress *progressView;


@end

@implementation ZNBesselTestController

- (ZNDownProgress *)progressView{
    if (!_progressView) {
        _progressView = [[ZNDownProgress alloc] initWithFrame:CGRectMake(50, 230, 20, 20) tintColor:MyColor(255, 105, 107) downState:ZNDownStateStart];
        _progressView.delegate = self;
    }
    return _progressView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZNBesselView *besselView = [[ZNBesselView alloc] initWithFrame:CGRectMake(12, 50, SCREENT_WIDTH - 24, 70)];
    besselView.backgroundColor = [UIColor whiteColor];
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, SCREENT_HEIGHT - 64)];
//    scrollView.contentSize = CGSizeMake(SCREENT_WIDTH * 2, 0);
//    [self.view addSubview:scrollView];
//    [scrollView addSubview:besselView];
    [self.view addSubview:besselView];
    
    ZNCanOperationImageView *operationView = [[ZNCanOperationImageView alloc] initWithFrame:CGRectMake(30, 150, 80, 40)];
    operationView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:operationView];
    
    
    [self.view addSubview:self.progressView];
    
    self.progressView.perValue = 0.8;
    
}

- (void)ZNDownProgressView:(ZNDownProgress *)downProgress WithState:(ZNDownState)downState{
    if (downState == ZNDownStateDowning) {
        downProgress.perValue = 0.66;
    }
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
