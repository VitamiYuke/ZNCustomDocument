//
//  ZNKlineCanvas.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineCanvas.h"


@interface ZNKlineCanvas ()
@property(nonatomic, assign)CGRect drawCanvasFrame;//绘制的画布大小
@end

@implementation ZNKlineCanvas{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)configureDrawRelatedAttInfo{
    _kTimeTheXAxisAtt = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:10],NSBackgroundColorAttributeName:MyColorWithAlpha(255, 255, 255, 0.7),NSForegroundColorAttributeName:MyColor(130, 130, 130)};
    _kTimeTheYAxisAtt = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:10],NSBackgroundColorAttributeName:MyColorWithAlpha(255, 255, 255, 0.7),NSForegroundColorAttributeName:MyColor(130, 130, 130)};
}


- (void)configureDrawCanvasFrameFromEdgeInsets:(UIEdgeInsets)edgeInsets{
    self.drawCanvasFrame = CGRectMake(edgeInsets.left, edgeInsets.top, self.width - edgeInsets.left - edgeInsets.right, self.height - edgeInsets.top - edgeInsets.bottom);
}


- (CGFloat)canvasTop{
    return self.drawCanvasFrame.origin.y;
}

- (CGFloat)canvasLeft{
    return self.drawCanvasFrame.origin.x;
}

- (CGFloat)canvasRight{
    return self.drawCanvasFrame.origin.x + self.drawCanvasFrame.size.width;
}

- (CGFloat)canvasBottom{
    return self.drawCanvasFrame.origin.y + self.drawCanvasFrame.size.height;
}

- (CGFloat)canvasWidth{
    return self.drawCanvasFrame.size.width;
}

- (CGFloat)canvasHeight{
    return self.drawCanvasFrame.size.height;
}

- (CGFloat)canvasWidth_2{
    return self.drawCanvasFrame.size.width/2;
}

- (CGFloat)canvasHeight_2{
    return self.drawCanvasFrame.size.height/2;
}

- (CGFloat)canvasMidX{
    return self.left + self.canvasWidth_2;
}

- (CGFloat)canvasMidY{
    return self.top + self.canvasHeight_2;
}

- (CGFloat)canvasKlineBottom{
    return self.canvasTop + self.canvasKlineHeight;
}

- (CGFloat)canvasVolumeTop{
    return self.canvasTop+self.canvasKlineHeight+xAxisHeitht;
}

- (CGFloat)canvasKlineHeight{
    return lineAccountedHeight*self.canvasHeight;
}

- (CGFloat)canvasVolumeHeight{
    return self.canvasHeight - self.canvasKlineHeight - xAxisHeitht;
}

//画线
- (CGFloat)KTimeVolumeUnitWidth{
    return self.canvasWidth/(4 * 60 + 2);
}


- (CGRect)canvasDrawRect{
    return self.drawCanvasFrame;
}


@end
