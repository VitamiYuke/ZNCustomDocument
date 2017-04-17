//
//  ZNTestButton.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/9/2.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNTestButton.h"


@interface ZNTestButton ()




@end


@implementation ZNTestButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title action:(ButtonAction)buttonAction
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonAction = buttonAction;
        self.title = title;
        [self configureAtt];
    }
    return self;
}



- (void)configureAtt
{
    self.backgroundColor = MyRandomColor;
    [self setTitleColor:MyRandomColor forState:UIControlStateNormal];
    self.titleLabel.font = MyFont(15);
    [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAction
{
    if (self.buttonAction) {
        self.buttonAction();
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}



@end
