//
//  ZNDownProgress.m
//  ZNDocument
//
//  Created by 张楠 on 17/2/27.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNDownProgress.h"



@interface ZNDownProgress ()
{
    UIColor *_tintColor;
    CGFloat _downingSize;
//    CAShapeLayer *_downingCircleLayer;
}

@property(nonatomic, strong)CAShapeLayer *downingCircleLayer;



@end


@implementation ZNDownProgress

- (CAShapeLayer *)downingCircleLayer{
    if (!_downingCircleLayer) {
        
        _downingCircleLayer = [CAShapeLayer layer];
        
        CGFloat minValue = MIN(self.frame.size.height * 0.5, self.frame.size.width *0.5);
        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        
        [circlePath addArcWithCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2) radius:minValue - 1.0 startAngle:-M_PI_2 endAngle:3 * M_PI_2 clockwise:YES];
        
        _downingCircleLayer.path = circlePath.CGPath;
        _downingCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _downingCircleLayer.strokeColor = _tintColor.CGColor;
        _downingCircleLayer.lineWidth = 1.8;
        _downingCircleLayer.lineCap = kCALineCapButt;
        _downingCircleLayer.lineJoin = kCALineJoinRound;
        _downingCircleLayer.strokeStart = 0;
        _downingCircleLayer.strokeEnd = 0;
        
    }
    return _downingCircleLayer;
}



- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor downState:(ZNDownState)downState{
    if ([super initWithFrame:frame]) {
        _tintColor = tintColor;
        _downingSize = 6;
        self.downState = downState;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDownState)]];
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    
    
    CGContextSetLineWidth(context, 1);
    
    CGFloat minValue = rect.size.width < rect.size.height?rect.size.width:rect.size.height;
    CGFloat circleCenterX = rect.origin.x + rect.size.width/2;
    CGFloat circleCenterY = rect.origin.y + rect.size.height/2;
    
    CGContextAddArc(context, circleCenterX, circleCenterY, minValue/2, 0, 2 * M_PI, NO);
    
    if (_tintColor) {
        [_tintColor setStroke];
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    
    switch (_downState) {
        case ZNDownStateStart:
        {
            UIBezierPath *path = [self drawArrow];
            CGContextAddPath(context, path.CGPath);
            CGContextDrawPath(context, kCGPathStroke);
        }
            break;
        case ZNDownStateDowning:
        {
            if (_tintColor) {
                [_tintColor setFill];
            }
            CGContextFillRect(context, CGRectMake(circleCenterX - _downingSize/2, circleCenterY - _downingSize/2, _downingSize, _downingSize));
            
        }
            
            break;
        case ZNDownStatePause:
        {
            CGPoint leftlines[2];
            leftlines[0].x = circleCenterX - 2;
            leftlines[0].y = rect.size.height/4;
            leftlines[1].x = circleCenterX - 2;
            leftlines[1].y = rect.size.height/4 * 3;
            
            CGContextSetLineWidth(context, 1.5);
            
            CGContextAddLines(context, leftlines, 2);
            
            CGPoint rightLines[2];
            rightLines[0].x = circleCenterX + 2;
            rightLines[0].y = rect.size.height/4;
            rightLines[1].x = circleCenterX + 2;
            rightLines[1].y = rect.size.height/4 * 3;
            
            CGContextAddLines(context, rightLines, 2);
            
            
            CGContextStrokePath(context);
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


//箭头的路径
- (UIBezierPath *)drawArrow {
    CGFloat startPos = self.frame.size.width / 3.f;
    CGFloat centerPos = self.frame.size.height / 2.f;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint: CGPointMake(centerPos, startPos)];
    [path addLineToPoint: CGPointMake(centerPos, 2 * startPos)];
    
    [path moveToPoint: CGPointMake(centerPos, 2 * startPos)];
    [path addLineToPoint: CGPointMake(startPos, centerPos)];
    [path moveToPoint: CGPointMake(centerPos, 2 * startPos)];
    [path addLineToPoint: CGPointMake(2 * startPos, centerPos)];
    return path;
}



- (void)setPerValue:(CGFloat)perValue{
    _perValue = perValue;
    
    if (_downState != ZNDownStateDowning) {
        if (self.downingCircleLayer.strokeEnd != 0) {
            self.downingCircleLayer.strokeEnd = 0;
        }
        
        if (self.downingCircleLayer.superlayer) {
            [self.downingCircleLayer removeFromSuperlayer];
        }
        
        MyLog(@"不是下载状态");
        return;
    }
    
    
    if (!self.downingCircleLayer.superlayer) {
        [self.layer addSublayer:self.downingCircleLayer];
    }
    
    
    if (perValue > 1) {
        if (self.downingCircleLayer.strokeEnd != 1) {
            self.downingCircleLayer.strokeEnd = 1;
        }
    }else if (perValue < 0){
        if (self.downingCircleLayer.strokeEnd != 0) {
            self.downingCircleLayer.strokeEnd = 0;
        }
    }else{
        self.downingCircleLayer.strokeEnd = perValue;
    }
    
    
}

- (void)setDownState:(ZNDownState)downState{
    _downState = downState;
    
    
    switch (_downState) {
        case ZNDownStateStart:
        {
            [self.downingCircleLayer removeFromSuperlayer];
        }
            break;
        case ZNDownStateDowning:
        {
            [self.layer addSublayer:self.downingCircleLayer];
        }
            
            break;
        case ZNDownStatePause:
        {
            [self.downingCircleLayer removeFromSuperlayer];
        }
            break;
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
    
}

//点击播放按钮的操作
- (void)changeDownState{
    MyLog(@"当前的状态:%ld",self.downState);
    switch (self.downState) {
        case ZNDownStateStart:
        {
            self.downState = ZNDownStateDowning;
        }
            break;
        case ZNDownStateDowning:
        {
            self.downState = ZNDownStatePause;
        }
            
            break;
        case ZNDownStatePause:
        {
            self.downState = ZNDownStateDowning;
            
        }
            break;
            
        default:
            break;
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZNDownProgressView:WithState:)]) {
        [self.delegate ZNDownProgressView:self WithState:self.downState];
    }
    
}



@end
