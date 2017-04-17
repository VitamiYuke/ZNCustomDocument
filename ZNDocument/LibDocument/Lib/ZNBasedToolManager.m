//
//  ZNBasedToolManager.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNBasedToolManager.h"

@implementation ZNBasedToolManager



+ (void)YukeToolDrawline:(CGContextRef)context startPoint:(CGPoint)startPoint stopPoint:(CGPoint)stopPoint color:(UIColor *)color lineWidth:(CGFloat)lineWitdth withIsDottedline:(BOOL)isDottedLine ifDottedConfigureDottedLineLength:(CGFloat)length padding:(CGFloat)padding{
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextBeginPath(context);
    if (isDottedLine) {
        if (padding < 0) {
            padding = 1;
        }
        if (length < 0) {
            length = 1;
        }
        CGFloat lengths[] = {length,padding};
        CGContextSetLineDash(context, 0, lengths, 1);
    } else{
        CGFloat lengths[] = {1,0};
        CGContextSetLineDash(context, 0, lengths, 2);
    }
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

+ (CGSize)YukeToolGetFitSizeWithContentFont:(UIFont *)contentFont content:(NSString *)content limitSize:(CGSize)limitSize
{
    if (contentFont && content.length > 0 && !CGSizeEqualToSize(limitSize, CGSizeZero)) {
        NSMutableAttributedString *tempAtt = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:contentFont}];
        CGRect fitRect = [tempAtt boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        return fitRect.size;
    } 
    return CGSizeZero;
}


+ (CATextLayer *)YukeToolGetTextLayerWithTextColor:(UIColor *)textColor font:(UIFont *)textFont textAlignment:(NSTextAlignment)alignment isWrapped:(BOOL)isWrapped orAttString:(NSAttributedString *)attString layerFrame:(CGRect)frame
{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.wrapped = isWrapped;
    switch (alignment) {
        case NSTextAlignmentLeft:
            textLayer.alignmentMode = kCAAlignmentLeft;
            break;
        case NSTextAlignmentRight:
            textLayer.alignmentMode = kCAAlignmentRight;
            break;
        case NSTextAlignmentCenter:
            textLayer.alignmentMode = kCAAlignmentCenter;
            break;
        case NSTextAlignmentJustified:
            textLayer.alignmentMode = kCAAlignmentJustified;
            break;
        case NSTextAlignmentNatural:
            textLayer.alignmentMode = kCAAlignmentNatural;
            break;
        default:
            break;
    }
    
    if (attString) {
        textLayer.string = attString;
    }else{
        if (!textColor || !textFont) {
            return nil;
        }
        
        textLayer.foregroundColor = textColor.CGColor;
        
        if (textFont) {
            CFStringRef fontName = (__bridge CFStringRef)textFont.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            textLayer.font = fontRef;
            textLayer.fontSize = textFont.pointSize;
            CGFontRelease(fontRef);
        }
    
    }
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        textLayer.frame = frame;
    }
    return textLayer;
}

+ (BOOL)YukeToolJudgeWetherEqualColor:(UIColor *)firstColor toColor:(UIColor *)secondColor
{
    if (CGColorEqualToColor(firstColor.CGColor, secondColor.CGColor)) {
        return YES;
    }
    return NO;
}

+ (NSDateComponents *)YukeToolGetCurrentDateComponents{
    NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComps = [gregorianCalendar components:unitFlags fromDate:[NSDate date]];
    return dateComps;
}

+ (CAShapeLayer *)YukeToolGetShaperLayerWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth path:(UIBezierPath *)path
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = lineWidth;
    //    shapeLayer.lineCap = kCALineCapRound; 末端点
    shapeLayer.lineJoin = kCALineJoinRound;//拐角
    shapeLayer.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null],@"strokeStart",[NSNull null],@"strokeEnd", nil];
    
    return shapeLayer;
}


@end
