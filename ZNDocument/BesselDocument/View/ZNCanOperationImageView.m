//
//  ZNCanOperationImageView.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/24.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNCanOperationImageView.h"


@implementation ZNCanOperationImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if ([super init]) {
        [self configureAtt];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self configureAtt];
    }
    return self;
}




- (void)configureAtt
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    [self addGestureRecognizer:longPress];
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (action == @selector(saveImage:)) {
        return YES;
    }
    
    if (action == @selector(copyAction:)) {
        return YES;
    }
    
    
    return [super canPerformAction:action withSender:sender];
}

- (void)longAction:(UILongPressGestureRecognizer *)longGesture
{
    MyLog(@"长按操作");
    
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        MyLog(@"开始");
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *saveItem = [[UIMenuItem alloc] initWithTitle:@"保存" action:@selector(saveImage:)];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)];
        [menu setMenuItems:@[copyItem,saveItem]];
        MyLog(@"ZNCanOperationImageViewBounds:%@",NSStringFromCGRect(self.bounds));
        [self becomeFirstResponder];
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    
    if (longGesture.state == UIGestureRecognizerStateEnded) {
        MyLog(@"结束");
    }
    
}

#pragma mark - 操作
- (void)saveImage:(id)sender
{
    MyLog(@"保存图片");
}

- (void)copyAction:(id)sender
{
    MyLog(@"复制文字");
}



@end
