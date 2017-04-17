//
//  CircleView.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/17.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.circleLayer = [ZNCircleLayer layer];
        self.circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.circleLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}




@end
