//
//  ExpressTestController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/9.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ExpressTestController.h"
#import "ZNEmoticonsKeyboardView.h"
#import "TYAttributedLabel.h"
@interface ExpressTestController ()<ZNEmoticonsKeyboardViewDelegate,TYAttributedLabelDelegate>

{
    NSMutableString *contentStr;
}

@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)TYAttributedLabel *tyContentLabel;


@end

@implementation ExpressTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    contentStr = [[NSMutableString alloc] init];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            ZNEmoticonsKeyboardView *emoticonView = [ZNEmoticonsKeyboardView defaultZNEmoticonsKeyboardView];
            emoticonView.delegate = self;
            emoticonView.y = SCREENT_HEIGHT - emoticonView.emoticonsKeyboardHeight - 64;
            MyLog(@"表情键盘高度%.0f",emoticonView.emoticonsKeyboardHeight);
            [self.view addSubview:emoticonView];
        });

    });
    
    MyLog(@"先创建显示Label");
    TYAttributedLabel *tyLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(10, 10, SCREENT_WIDTH - 20, 250)];
    tyLabel.backgroundColor = MyRandomColor;
    tyLabel.delegate = self;
    [self.view addSubview:tyLabel];
    _tyContentLabel = tyLabel;
    
    
}



- (void)ZNEmoticonsSelectedExpressionName:(NSString *)expressionStr
{
    MyLog(@"%@",expressionStr);
    [contentStr appendString:expressionStr];
    TYTextContainer *textContainer = [[TYTextContainer alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
//    textContainer.text = contentStr;
    textContainer.attributedText = attStr;
    [ZNExpressionCL operationTYTextContainerEmoticonsWith:textContainer andContent:contentStr];
    self.tyContentLabel.textContainer = textContainer;
    
    
    
}

- (void)ZNEmoticonsExpressionDelete
{
    MyLog(@"删除");
    
    
    
}


//ty点击代理
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point
{
    MyLog(@"%@",textStorage);
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageLongPressed:(id<TYTextStorageProtocol>)textStorage onState:(UIGestureRecognizerState)state atPoint:(CGPoint)point
{
    MyLog(@"%@",textStorage);
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
