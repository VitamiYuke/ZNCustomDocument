//
//  ZNBasedToolManager.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNBasedToolManager : NSObject

//画线 是否是虚线
+(void)YukeToolDrawline:(CGContextRef)context
             startPoint:(CGPoint)startPoint
              stopPoint:(CGPoint)stopPoint
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWitdth
       withIsDottedline:(BOOL )isDottedLine
ifDottedConfigureDottedLineLength:(CGFloat )length
                padding:(CGFloat )padding;//间距大于0

//获取文字的自适应的大小根据设置的限制 大小
+(CGSize )YukeToolGetFitSizeWithContentFont:(UIFont *)contentFont
                                    content:(NSString *)content
                                  limitSize:(CGSize )limitSize;

//获取图层文本
+(CATextLayer *)YukeToolGetTextLayerWithTextColor:(UIColor *)textColor
                                             font:(UIFont *)textFont
                                    textAlignment:(NSTextAlignment )alignment
                                        isWrapped:(BOOL )isWrapped
                                      orAttString:(NSAttributedString *)attString
                                       layerFrame:(CGRect )frame;

//判断两个颜色值相同
+(BOOL )YukeToolJudgeWetherEqualColor:(UIColor *)firstColor toColor:(UIColor *)secondColor;
//获取当前时间的组件
+(NSDateComponents *)YukeToolGetCurrentDateComponents;
//CAShapeLayer
+(CAShapeLayer *)YukeToolGetShaperLayerWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat )lineWidth path:(UIBezierPath *)path;









@end
