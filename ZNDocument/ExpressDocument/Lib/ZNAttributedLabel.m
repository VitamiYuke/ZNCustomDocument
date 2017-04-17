//
//  ZNAttributedLabel.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/11.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNAttributedLabel.h"

@implementation ZNAttributedLabel


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = MyColor(202, 210, 222);
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = [UIColor clearColor];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = [UIColor clearColor];
}


- (void)setZnTextContainer:(ZNTextContainer *)znTextContainer
{
    _znTextContainer = znTextContainer;
    self.textContainer = znTextContainer;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)init
{
    if ([self init]) {
        
    }
    return self;
}


- (void)addGesture // 添加手势
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    
    
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    MyLog(@"点击");
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    MyLog(@"长按");
}







@end
