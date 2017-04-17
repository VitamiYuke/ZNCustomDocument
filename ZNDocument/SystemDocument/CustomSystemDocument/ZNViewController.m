//
//  ZNViewController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/8.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNViewController.h"

@interface ZNViewController ()

@end

@implementation ZNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    MyLog(@"%@完成加载",self);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MyLog(@"%s:将要显示",object_getClassName(self));
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MyLog(@"%@显示完毕",[ZNRegularHelp getCurrentShowViewController]);
}


- (void)dealloc
{
    MyLog(@"%s销毁",object_getClassName(self));
}






@end
