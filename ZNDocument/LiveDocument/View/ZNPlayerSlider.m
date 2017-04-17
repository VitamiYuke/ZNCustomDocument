//
//  ZNPlayerSlider.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/10.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNPlayerSlider.h"

@implementation ZNPlayerSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect )trackRectForBounds:(CGRect)bounds
{
    [super trackRectForBounds:bounds];
    return CGRectMake(-2, (self.frame.size.height - 2.5)/2.0, CGRectGetWidth(bounds) + 4, 2.5);
}

@end
