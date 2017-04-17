//
//  AppleInPurchasingTestController.m
//  ZNDocument
//
//  Created by 张楠 on 16/10/29.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "AppleInPurchasingTestController.h"
#import "ZNAppleInPurchasingView.h"
@interface AppleInPurchasingTestController ()

@end

@implementation AppleInPurchasingTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ZNAppleInPurchasingView *inPurchasingView = [[ZNAppleInPurchasingView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, SCREENT_HEIGHT - 64)];
    [self.view addSubview:inPurchasingView];
    
    SEL sell = @selector(method);
    MyLog(@"sel ; %p",sell);

    
}

- (void)method
{
    MyLog(@"good ");
}







@end
