//
//  ZNSkinCareCameraController.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/17.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNSkinCareCameraController.h"
#import "ZNSkinCareCamera.h"

@interface ZNSkinCareCameraController ()

@property(nonatomic, strong)ZNSkinCareCamera *skinCareCamera;

@end

@implementation ZNSkinCareCameraController



- (ZNSkinCareCamera *)skinCareCamera{
    if (!_skinCareCamera) {
        _skinCareCamera = [[ZNSkinCareCamera alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, SCREENT_HEIGHT)];
    }
    return _skinCareCamera;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.skinCareCamera];
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}





@end
