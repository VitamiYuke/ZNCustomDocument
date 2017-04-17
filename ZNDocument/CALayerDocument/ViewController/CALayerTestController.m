//
//  CALayerTestController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/17.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "CALayerTestController.h"
#import "CircleView.h"
#import "ZNMenuButton.h"
#import "ZNKlineController.h"
@interface CALayerTestController ()

@property(nonatomic, strong)CircleView *circleView;



@end

@implementation CALayerTestController

- (CircleView *)circleView
{
    if (!_circleView) {
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(SCREENT_WIDTH/ - 320/2, 64, 320, 320)];
    }
    return _circleView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.circleView.circleLayer.progress = 0.5;
    [self.view addSubview:self.circleView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 400, SCREENT_WIDTH - 100, 30)];
    slider.maximumValue = 1.0;
    slider.minimumValue = 0.0;
    slider.value = 0.5;
    [slider addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    
    ZNMenuButton *menuButton = [[ZNMenuButton alloc] initWithTitle:@"首页"];
    menuButton.frame = CGRectMake(10, 10, 80, 40);
    menuButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:menuButton];
    
    znWeakSelf(self);
    ZNTestButton *kLine = [[ZNTestButton alloc] initWithFrame:CGRectMake(30, SCREENT_HEIGHT - 100 - 64, 60, 50) title:@"K线" action:^{
        [weakSelf.navigationController pushViewController:[[ZNKlineController alloc] init] animated:YES];
    }];
    [self.view addSubview:kLine];
    
    ZNTestButton *fontNameBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(100, SCREENT_HEIGHT - 100 - 64, 80, 50) title:@"字体名称" action:^{
        [weakSelf searchAllFontName];
    }];
    [self.view addSubview:fontNameBtn];
    
    
    ZNTestButton *systemBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fontNameBtn.frame) + 10, SCREENT_HEIGHT - 100 - 64, 80, 50) title:@"系统字体" action:^{
        [weakSelf systemFontName];
    }];
    [self.view addSubview:systemBtn];
    
}

- (void)changeAction:(UISlider *)sender
{
    self.circleView.circleLayer.progress = sender.value;
}



- (void)searchAllFontName{
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames )
    {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames )
        {
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
    
    
}


- (void)systemFontName{
    UIFont *normalFont = [UIFont systemFontOfSize:16];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:16];
    MyLog(@"正常字体名:%s \n 粗体字体名字:%s",[normalFont.fontName UTF8String],[boldFont.fontName UTF8String]);
    
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
