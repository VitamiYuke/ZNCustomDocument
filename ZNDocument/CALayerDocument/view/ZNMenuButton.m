//
//  ZNMenuButton.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/22.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNMenuButton.h"



@interface ZNMenuButton ()

@property(nonatomic, copy)NSString *buttonTitle;

@end

@implementation ZNMenuButton





- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.buttonTitle = title;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self.backgroundColor set];
    CGContextFillPath(context);
    
    /*
     CGRectInset(CGRect rect, CGFloat dx, CGFloat dy) 相对于源矩形 进行缩小 具体缩小 要根据 参数dx 和 dy 进行决定
     CGRectOffset(CGRect rect, CGFloat dx, CGFloat dy) 相对于源矩形的坐标原点 即左上角 进行偏移 偏移 x y轴 偏移多少根据 dx dy决定
     */
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:rect.size.height/2];
    [self.backgroundColor setFill];
    [roundedRectanglePath fill];
    if (!self.tintColor) {
        self.tintColor = [UIColor whiteColor];
    }
    [self.tintColor setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    //画文字
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:24.0f],NSForegroundColorAttributeName:self.tintColor,NSParagraphStyleAttributeName:paragraphStyle};
    if (!self.buttonTitle) {
        self.buttonTitle = @"";
    }
    
    CGSize size = [self.buttonTitle sizeWithAttributes:attr];
    CGRect titleRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - size.height)/2, rect.size.width, size.height);
    [self.buttonTitle drawInRect:titleRect withAttributes:attr];
    
}







@end
