//
//  ZNTestCell.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/24.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNTestCell.h"


@interface ZNTestCell ()

@property(nonatomic, strong)UILabel *testLabel;

@end

@implementation ZNTestCell


- (UILabel *)testLabel
{
    if (!_testLabel) {
        _testLabel = [[UILabel alloc] init];
        _testLabel.textColor = MyColor(50, 50, 50);
        _testLabel.font = [UIFont boldSystemFontOfSize:17];
        
    }
    return _testLabel;
}


+ (instancetype)getZNTestCellWith:(UITableView *)tableView
{
    static NSString *indentifier = @"ZNTestCellIndentifier";
    ZNTestCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[ZNTestCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *seletedView = [[UIView alloc] init];
        seletedView.backgroundColor = MyColor(243, 245, 247);
        self.selectedBackgroundView = seletedView;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
        [self addGestureRecognizer:longPress];
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    [self addSubview:self.testLabel];
    [self.testLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [self.testLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MyColor(220, 220, 220);
    [self addSubview:line];
    [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [line autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [line autoSetDimension:ALDimensionHeight toSize:0.5];
    
}


- (void)setTestTitle:(NSString *)testTitle
{
    _testTitle = testTitle;
    self.testLabel.text = testTitle;
    
}


#pragma mark - 给cell添加复制等功能
- (void)longAction:(UILongPressGestureRecognizer *)longGesture
{
    MyLog(@"长按操作");
    
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        MyLog(@"开始");
        [self becomeFirstResponder];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *saveItem = [[UIMenuItem alloc] initWithTitle:@"保存" action:@selector(saveImage:)];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)];
        [menu setMenuItems:@[copyItem,saveItem]];
        MyLog(@"CellBounds:%@",NSStringFromCGRect(self.bounds));
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    
    if (longGesture.state == UIGestureRecognizerStateEnded) {
        MyLog(@"结束");
    }
    
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
