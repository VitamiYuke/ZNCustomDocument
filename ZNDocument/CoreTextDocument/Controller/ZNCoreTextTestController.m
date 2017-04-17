//
//  ZNCoreTextTestController.m
//  ZNDocument
//
//  Created by 张楠 on 16/10/14.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNCoreTextTestController.h"
#import "ZNCoreTextLibCL.h"
#import "TYAttributedLabel.h"
@interface ZNCoreTextTestController ()<TYAttributedLabelDelegate>

@end

@implementation ZNCoreTextTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUI];
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


- (void)configureUI
{
    NSString *htmlString = @"<a style='text-decoration:none;' href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sh600500&name=a到底'>哦哦呃呃呃</a>";
    TYAttributedLabel *tyLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(10, 10, SCREENT_WIDTH - 20, 250)];
    tyLabel.backgroundColor = MyRandomColor;
    tyLabel.delegate = self;
    tyLabel.attributedText = [ZNCoreTextLibCL getRemoveHtmlContentWithHtml:htmlString];
    [self.view addSubview:tyLabel];
    
    
    
    
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point
{
    MyLog(@"%@",textStorage);
}

@end
