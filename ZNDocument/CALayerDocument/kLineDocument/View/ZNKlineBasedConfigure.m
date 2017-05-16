//
//  ZNKlineBasedConfigure.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineBasedConfigure.h"
#import "ZNStockTimeSharingModel.h"
#import "ZNStockKlineModel.h"
@interface ZNKlineBasedConfigure ()

//最高 最底价格
@property(nonatomic, strong)CATextLayer *minPriceLabel;
@property(nonatomic, strong)CATextLayer *maxPriceLabel;

//长按
@property(nonatomic, assign,readonly)CGRect KlineLongPressMALeftFrame;
@property(nonatomic, assign,readonly)CGRect KlineLongPressMARightFrame;
@property(nonatomic, assign, readonly)CGPoint longPressStartPoint;

//收盘价格
@property(nonatomic, strong)UILabel *KlinePressClosePriceView;
@property(nonatomic, strong)CALayer *KlinePressMAPriceTipsLayer;
@property(nonatomic, strong)CATextLayer *ma5PriceLabel;
@property(nonatomic, strong)CATextLayer *ma10PriceLabel;
@property(nonatomic, strong)CATextLayer *ma20PriceLabel;

//分时的末端点
@property(nonatomic, strong)CALayer *defaultEndPoint;
@property(nonatomic, strong)CALayer *endPointAnimation;
//十字线的图层
@property(nonatomic,strong)CAShapeLayer *reticleLayer;
@property(nonatomic, strong)CAShapeLayer *reticleCenterCircle;
//K线的成交量图层
@property(nonatomic, strong)CATextLayer *KlinePressVolumeLabel;


//横屏长按分时的显示
@property(nonatomic, strong)UILabel *KTimePressPriceView;
@property(nonatomic, strong)UILabel *KTimePressRateView;

@property(nonatomic, assign)BOOL isHaveAnimation;


@property(nonatomic, assign)BOOL isChangeType;

@end



@implementation ZNKlineBasedConfigure{
    NSInteger _KlineMaxCount;
}

/*
// Only override drawRect: if you perform custom drawing.
// An emptyimplementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.isHaveAnimation = YES;
    }
    return self;
}



- (void)drawStockKlineCoordinateWithContext:(CGContextRef )context withIsLandscape:(BOOL )isLandscape{
    
    if (isLandscape) {//全屏状态
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, myBorderColor.CGColor);
        CGContextSetLineWidth(context, myBorderWidth/2);
        CGContextAddRect(context, CGRectMake(self.canvasLeft, self.canvasTop, self.canvasWidth, self.canvasKlineHeight));
        CGContextAddRect(context, CGRectMake(self.canvasLeft, self.canvasVolumeTop, self.canvasWidth, self.canvasVolumeHeight));
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
    }else {
        [self drawSolidline:context startPoint:CGPointMake(self.canvasLeft, self.canvasTop) stopPoint:CGPointMake(self.canvasRight, self.canvasTop) color:myBorderColor lineWidth:myBorderWidth/2];
        [self drawSolidline:context startPoint:CGPointMake(self.canvasLeft, self.canvasKlineBottom) stopPoint:CGPointMake(self.canvasRight, self.canvasKlineBottom) color:myBorderColor lineWidth:myBorderWidth/2];
        [self drawSolidline:context startPoint:CGPointMake(self.canvasLeft, self.canvasVolumeTop) stopPoint:CGPointMake(self.canvasRight, self.canvasVolumeTop) color:myBorderColor lineWidth:myBorderWidth/2];
        [self drawSolidline:context startPoint:CGPointMake(self.canvasLeft, self.canvasBottom) stopPoint:CGPointMake(self.canvasRight, self.canvasBottom) color:myBorderColor lineWidth:myBorderWidth/2];
    }
    
    if (self.chartType == ZNChartTimeLine) {//分时数据
        [self drawDottedline:context startPoint:CGPointMake(self.canvasLeft, self.canvasKlineHeight/2 + self.canvasTop) stopPoint:CGPointMake(self.canvasRight, self.canvasKlineHeight/2 + self.canvasTop) color:MyColor(255, 171, 171) lineWidth:myBorderWidth/2];
        [self drawSolidline:context startPoint:CGPointMake(self.canvasMidX, self.canvasTop) stopPoint:CGPointMake(self.canvasMidX, self.canvasKlineBottom) color:myBorderColor lineWidth:myBorderWidth/2];

    }else{
        
    }
    
}

#pragma mark - 分时
//绘制文本
- (void)configureTextWithContent:(NSString *)content attributeDic:(NSDictionary *)attDic drawText:(void (^)(CGSize, NSString *, NSDictionary *))drawText
{
    UIFont *contentFont = attDic[NSFontAttributeName];
    if (!contentFont || content.length == 0 || !content) {
        MyLog(@"缺少绘制的工具");
        drawText(CGSizeZero,content,attDic);
        return;
    }
    CGSize fitSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:contentFont content:content limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    drawText(fitSize,content,attDic);

}



- (void)drawKTimeTheXAxisWithContext:(CGContextRef )context{
    
    [self configureTextWithContent:@"09:30" attributeDic:self.kTimeTheXAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
        CGRect drawRect = CGRectMake(self.canvasLeft, self.canvasKlineBottom + (xAxisHeitht - contentSize.height)/2, contentSize.width, contentSize.height);
        [drawContent drawInRect:drawRect withAttributes:drawAtt];
    }];
    
    [self configureTextWithContent:@"11:30/13:00" attributeDic:self.kTimeTheXAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
        CGRect drawRect = CGRectMake(self.canvasMidX - contentSize.width/2, self.canvasKlineBottom + (xAxisHeitht - contentSize.height)/2, contentSize.width, contentSize.height);
        [drawContent drawInRect:drawRect withAttributes:drawAtt];
    }];
    
    [self configureTextWithContent:@"15:00" attributeDic:self.kTimeTheXAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
        CGRect drawRect = CGRectMake(self.canvasRight - contentSize.width, self.canvasKlineBottom + (xAxisHeitht - contentSize.height)/2,contentSize.width, contentSize.height);
        [drawContent drawInRect:drawRect withAttributes:drawAtt];
    }];
    
}


#pragma mark -- 画实线🈴️虚线
-(void)drawDottedline:(CGContextRef)context startPoint:(CGPoint)startPoint stopPoint:(CGPoint)stopPoint color:(UIColor *)color lineWidth:(CGFloat)lineWitdth
{
 
    if ([self checkPointWhetherOrNotCrossingThelineWithOriginPoint:startPoint] || [self checkPointWhetherOrNotCrossingThelineWithOriginPoint:stopPoint]) {
        MyLog(@"绘制的点超出绘制区域");
        return;
    }
    
    [ZNStockBasedConfigureLib YukeToolDrawline:context startPoint:startPoint stopPoint:stopPoint color:color lineWidth:lineWitdth withIsDottedline:YES ifDottedConfigureDottedLineLength:2 padding:1];
}
-(void)drawSolidline:(CGContextRef)context startPoint:(CGPoint)startPoint stopPoint:(CGPoint)stopPoint color:(UIColor *)color lineWidth:(CGFloat)lineWitdth
{
    if ([self checkPointWhetherOrNotCrossingThelineWithOriginPoint:startPoint] || [self checkPointWhetherOrNotCrossingThelineWithOriginPoint:stopPoint]) {
        MyLog(@"绘制的点超出绘制区域");
        return;
    }
    [ZNStockBasedConfigureLib YukeToolDrawline:context startPoint:startPoint stopPoint:stopPoint color:color lineWidth:lineWitdth withIsDottedline:NO ifDottedConfigureDottedLineLength:2 padding:1];
}
#pragma mark - 检查一个坐标点有没有超出绘制区域
- (BOOL )checkPointWhetherOrNotCrossingThelineWithOriginPoint:(CGPoint )point{
    if (point.x < self.canvasLeft || point.x > self.canvasRight || point.y < self.canvasTop || point.y > self.canvasBottom) {
        return YES;
    }
    return NO;
}


#pragma mark -

- (CAShapeLayer *)configureCurveLayerWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth path:(UIBezierPath *)path
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = lineWidth;
//    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null],@"strokeStart",[NSNull null],@"strokeEnd", nil];
    
    return shapeLayer;
}

- (CABasicAnimation *)configureLayerAnimationWithLayer:(CAShapeLayer *)layler{
    CABasicAnimation *basedAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basedAnimation.fromValue = @0.f;
    basedAnimation.toValue = @1.f;
    basedAnimation.duration = 1.0f;
    [layler addAnimation:basedAnimation forKey:basedAnimation.keyPath];
    [layler setValue:basedAnimation.toValue forKey:basedAnimation.keyPath];
    return basedAnimation;
}

- (CAGradientLayer *)configureCradientWithFrame:(CGRect)rect{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    gradientLayer.colors = @[(__bridge id)(MyColor(188, 210, 235)).CGColor,(__bridge id)(MyColor(188, 210, 235)).CGColor];
    gradientLayer.locations = @[@0,@1];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    return gradientLayer;
}

//
- (UIColor *)configureVolumeColorWithOldPrice:(CGFloat )oldPrice latestPrice:(CGFloat )latestPrice{
    
    
    
    if (latestPrice > oldPrice) {
        return lineColorWithRed;
    }
    
    
    if (latestPrice < oldPrice) {
        return lineColorWithGreen;
    }
    
    
    if (latestPrice == self.maxPrice || latestPrice == self.minPrice) {
        return lineColorWithRed;
    }
    
    return lineColorWithGray;
}

#pragma mark - 最后一个点的及动画
- (CALayer *)configureKTimeEndPoint
{
    CALayer *endPotionLayer = [CAScrollLayer layer];
    endPotionLayer.backgroundColor = timePriceLineColor.CGColor;
    endPotionLayer.cornerRadius = KTimeEndPointSize/2;
    endPotionLayer.masksToBounds = YES;
    endPotionLayer.borderWidth = 1;
    endPotionLayer.borderColor = timePriceLineColor.CGColor;
    return endPotionLayer;
}

- (CALayer *)configureKTimeEndPointAnimationLayer
{
    
    CALayer *animationLayer = [CAScrollLayer layer];
    animationLayer.backgroundColor = timePriceLineColor.CGColor;
    animationLayer.cornerRadius = KTimeEndPointSize/2;
    animationLayer.masksToBounds = YES;
    animationLayer.borderWidth = 1;
    animationLayer.borderColor = timePriceLineColor.CGColor;
    [animationLayer addAnimation:[self configureBreathAnimationWithTime:2.0f] forKey:@"breathingPoint"];
    return animationLayer;
}


//改变透明度的动画
- (CABasicAnimation *)configureOpacityAnimationWihtTime:(CGFloat )time{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

//组合动画 改变大小和透明度
- (CAAnimationGroup *)configureBreathAnimationWithTime:(CGFloat )time{
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 2.5)];
    scaleAnim.removedOnCompletion = NO;
    
    NSArray * array = @[[self configureOpacityAnimationWihtTime:time],scaleAnim];
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations= array;
    animation.duration=time;
    animation.repeatCount=MAXFLOAT;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}


#pragma mark - 十字线路径
- (UIBezierPath *)configureReticleLineWithCenterPoint:(CGPoint)centerPoint orTipsPrice:(NSString *)tipsPrice{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(centerPoint.x, self.canvasTop)];
    [path addLineToPoint:CGPointMake(centerPoint.x, self.canvasBottom)];

    if (tipsPrice && tipsPrice.length > 0 && !self.isLandscape) {
        
        CGSize size = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinBoldFont(10) content:tipsPrice limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if (centerPoint.x > self.canvasMidX) {
            [path moveToPoint:CGPointMake(self.canvasLeft + size.width, centerPoint.y)];
            [path addLineToPoint:CGPointMake(self.canvasRight, centerPoint.y)];
        }else{
            [path moveToPoint:CGPointMake(self.canvasLeft, centerPoint.y)];
            [path addLineToPoint:CGPointMake(self.canvasRight - size.width, centerPoint.y)];
        }
    }else{
        [path moveToPoint:CGPointMake(self.canvasLeft, centerPoint.y)];
        [path addLineToPoint:CGPointMake(self.canvasRight, centerPoint.y)];
    }
    return path;
}
//圆
- (UIBezierPath *)configureCircleWithRadius:(CGFloat)radius centerPoint:(CGPoint)centerPoint{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    return path;
}

#pragma mark - 代理设置
- (void)configureKTimeDelegateActionWithTimeSharingModel:(ZNStockTimeSharingModel *)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZNKTimeLongPressPointShowWithTimeSharingModel:)]) {
        [self.delegate ZNKTimeLongPressPointShowWithTimeSharingModel:model];
    }
}

- (void)configureKlineDelegateActionWithKlineModel:(ZNStockKlineModel *)model beforeClosePrice:(CGFloat)beforeClosePrice
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZNKlineLongPressPointShowWithKlineModel:beforeClosePrice:)]) {
        [self.delegate ZNKlineLongPressPointShowWithKlineModel:model beforeClosePrice:beforeClosePrice];
    }
}

- (void)configureEndDelegateAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZNLongPressEnd)]) {
        [self.delegate ZNLongPressEnd];
    }
}

- (void)configureStartDelegateAction{ // ZNLongPressStart
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZNLongPressStartWithCharType:)]) {
        [self.delegate ZNLongPressStartWithCharType:self.chartType];
    }
}

- (void)configureChangeType{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZNKlineChangeWithCharType:)]) {
        [self.delegate ZNKlineChangeWithCharType:self.chartType];
    }
}


#pragma mark - 画文字
- (CATextLayer *)configureTextLayerWithAttString:(NSMutableAttributedString *)attString frame:(CGRect)frame{
    if (!attString) {
        return nil;
    }
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = frame;
    textLayer.string = attString;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    return textLayer;
}

#pragma mark - 画Y轴刻度
- (void)configureKtimeYAxisWhetherIsLabndscape:(BOOL)isLandscape superLayer:(CALayer *)superLayer{
    
    if (!superLayer) {
        MyLog(@"没有父视图");
        return;
    }
    
    NSString *maxPriceStr = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:self.maxPrice];
    NSString *minPriceStr = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:self.minPrice];
    [self configureTextWithContent:maxPriceStr attributeDic:self.kTimeTheYAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
        CGRect drawRect = CGRectMake(isLandscape?(self.canvasLeft - contentSize.width - priceDistanceLine):self.canvasLeft, self.canvasTop + priceDistanceLine, contentSize.width, contentSize.height);
        self.maxPriceLabel = [self configureTextLayerWithAttString:[[NSMutableAttributedString alloc] initWithString:drawContent attributes:drawAtt] frame:drawRect];
        [superLayer addSublayer:self.maxPriceLabel ];
    }];
    
    [self configureTextWithContent:minPriceStr attributeDic:self.kTimeTheYAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
        CGRect drawRect = CGRectMake(isLandscape?(self.canvasLeft - contentSize.width - priceDistanceLine):self.canvasLeft, self.canvasKlineBottom - priceDistanceLine - contentSize.height, contentSize.width, contentSize.height);
        self.minPriceLabel = [self configureTextLayerWithAttString:[[NSMutableAttributedString alloc] initWithString:drawContent attributes:drawAtt] frame:drawRect];
        [superLayer addSublayer:self.minPriceLabel];
    }];
    
    
    if (isLandscape) {
        NSString *midPriceStr = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:(self.maxPrice + self.minPrice)*0.5];
        [self configureTextWithContent:midPriceStr attributeDic:self.kTimeTheYAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
            CGRect drawRect = CGRectMake(self.canvasLeft - contentSize.width - priceDistanceLine, self.canvasTop + self.canvasKlineHeight/2 - contentSize.height/2, contentSize.width, contentSize.height);
            [superLayer addSublayer:[self configureTextLayerWithAttString:[[NSMutableAttributedString alloc] initWithString:drawContent attributes:drawAtt] frame:drawRect]];
        }];
        
        NSString *maxVolumeStr =  [ZNStockBasedConfigureLib configureStockVolumeShowWithVolume:self.maxVolum];
        [self configureTextWithContent:maxVolumeStr attributeDic:self.kTimeTheYAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
            CGRect drawRect = CGRectMake(self.canvasLeft - contentSize.width - priceDistanceLine, self.canvasVolumeTop + priceDistanceLine, contentSize.width, contentSize.height);
            [superLayer addSublayer:[self configureTextLayerWithAttString:[[NSMutableAttributedString alloc] initWithString:drawContent attributes:drawAtt] frame:drawRect]];
        }];
        
        NSString *unitStr = [ZNStockBasedConfigureLib getStockVolumeUnitWithVolume:self.maxVolum];
        [self configureTextWithContent:unitStr attributeDic:self.kTimeTheYAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
            CGRect drawRect = CGRectMake(self.canvasLeft - contentSize.width - priceDistanceLine, self.canvasBottom - priceDistanceLine - contentSize.height, contentSize.width, contentSize.height);
            [superLayer addSublayer:[self configureTextLayerWithAttString:[[NSMutableAttributedString alloc] initWithString:drawContent attributes:drawAtt] frame:drawRect]];
        }];

    }
    
    
    if (self.chartType == ZNChartTimeLine) {
        //最大振幅
        NSString * maxRate = [NSString stringWithFormat:@"%@%%",[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:self.rate*100]];
        
        [self configureTextWithContent:maxRate attributeDic:self.kTimeTheYAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
            CGRect drawRect = CGRectMake(isLandscape?(self.canvasRight + priceDistanceLine):(self.canvasRight - priceDistanceLine - contentSize.width), self.canvasTop + priceDistanceLine, contentSize.width, contentSize.height);
            [superLayer addSublayer:[self configureTextLayerWithAttString:[[NSMutableAttributedString alloc] initWithString:drawContent attributes:drawAtt] frame:drawRect]];
        }];
        
        //最小振幅
        NSString * minRate = [NSString stringWithFormat:@"-%@%%",[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:self.rate*100]];
        [self configureTextWithContent:minRate attributeDic:self.kTimeTheYAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
            CGRect drawRect = CGRectMake(isLandscape?(self.canvasRight + priceDistanceLine):(self.canvasRight - priceDistanceLine - contentSize.width), self.canvasKlineBottom - priceDistanceLine - contentSize.height, contentSize.width, contentSize.height);
            [superLayer addSublayer:[self configureTextLayerWithAttString:[[NSMutableAttributedString alloc] initWithString:drawContent attributes:drawAtt] frame:drawRect]];
        }];
        
        if (isLandscape) {
            NSString * zeroRate = @"0.00%";
            [self configureTextWithContent:zeroRate attributeDic:self.kTimeTheYAxisAtt drawText:^(CGSize contentSize, NSString *drawContent, NSDictionary *drawAtt) {
                CGRect drawRect = CGRectMake((self.canvasRight + priceDistanceLine), self.canvasTop + self.canvasKlineHeight/2 - contentSize.height/2, contentSize.width, contentSize.height);
                [superLayer addSublayer:[self configureTextLayerWithAttString:[[NSMutableAttributedString alloc] initWithString:drawContent attributes:drawAtt] frame:drawRect]];
            }];
        }
        
        
    }
    
    
    
}

//配置一个普通的layer
- (CALayer *)configureBasedOrdinaryLayerWithFrame:(CGRect)frame
{
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    return layer;
}

//
- (UIBezierPath *)configureBasedCoordinatePathWithIsLandscape:(BOOL)isLandscape{//是否是全屏
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    
    [path moveToPoint:CGPointMake(self.canvasLeft, self.canvasTop)];
    [path addLineToPoint:CGPointMake(self.canvasRight, self.canvasTop)];
    [path moveToPoint:CGPointMake(self.canvasLeft, self.canvasKlineBottom)];
    [path addLineToPoint:CGPointMake(self.canvasRight, self.canvasKlineBottom)];
    [path moveToPoint:CGPointMake(self.canvasLeft, self.canvasVolumeTop)];
    [path addLineToPoint:CGPointMake(self.canvasRight, self.canvasVolumeTop)];
    [path moveToPoint:CGPointMake(self.canvasLeft, self.canvasBottom)];
    [path addLineToPoint:CGPointMake(self.canvasRight, self.canvasBottom)];
    

    if (isLandscape) {
        [path moveToPoint:CGPointMake(self.canvasLeft, self.canvasTop)];
        [path addLineToPoint:CGPointMake(self.canvasLeft, self.canvasKlineBottom)];
        [path moveToPoint:CGPointMake(self.canvasRight, self.canvasTop)];
        [path addLineToPoint:CGPointMake(self.canvasRight, self.canvasKlineBottom)];

        [path moveToPoint:CGPointMake(self.canvasLeft, self.canvasVolumeTop)];
        [path addLineToPoint:CGPointMake(self.canvasLeft, self.canvasBottom)];
        [path moveToPoint:CGPointMake(self.canvasRight, self.canvasVolumeTop)];
        [path addLineToPoint:CGPointMake(self.canvasRight, self.canvasBottom)];
    }
    
    
    
    if (self.chartType != ZNChartTimeLine) {
        [path moveToPoint:CGPointMake(self.canvasLeft, self.canvasHeight_2)];
        [path addLineToPoint:CGPointMake(self.canvasRight,self.canvasHeight_2)];
    }

    
    
    
    

    return path;
}

- (CAShapeLayer *)configureBasedCoordinateLayer{
    CAShapeLayer *coordinateLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:myBorderColor lineWidth:myBorderWidth/2 path:[UIBezierPath bezierPath]];
    return coordinateLayer;
}


- (CGFloat)configurePriceUnitHeight{

    if (self.configurePriceDifference > 0) {
        
        return (self.canvasKlineHeight - self.configureKlineYAxisPadding*2)/ self.configurePriceDifference ;
    }
    
    return 0;
}


- (CGFloat)configureVolumeUnitHeight{
    if (self.maxVolum > 0) {
        return self.canvasVolumeHeight/self.maxVolum;
    }
    return 0;
}

- (CGFloat)configurePriceDifference{
    return self.maxPrice - self.minPrice;
}

- (CGSize)configureKlineXAxisDescSize{
    return [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:self.kTimeTheXAxisAtt[NSFontAttributeName] content:@"1993-05" limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}


- (CGFloat)configureKlineYAxisPadding{
    
    if (!self.isLandscape && self.chartType == ZNChartDailyKLine) {
        return 12;
    }

    return 1;
}



- (void)configureKlineXAxisWithPointArray:(NSArray *)pointArray descArray:(NSArray *)descArray superLayer:(CALayer *)superLayer
{
    if (!superLayer) {
        return;
    }
    
    CGSize size = self.configureKlineXAxisDescSize;
    
    for (int i = 0; i < MIN(pointArray.count, descArray.count); i++) {
        CGFloat pointX = [pointArray[i] floatValue];
        NSString *desc = descArray[i];
        CGRect descFrame = CGRectMake(pointX - size.width/2, self.canvasKlineBottom + (xAxisHeitht - size.height)/2, size.width, size.height);
         [superLayer addSublayer:[self configureTextLayerWithAttString:[[NSMutableAttributedString alloc] initWithString:desc attributes:self.kTimeTheXAxisAtt] frame:descFrame]];
    }
  
}

- (void)configureMaxAndMinPriceIsShow:(BOOL)isShow{
    
    if (self.isLandscape || self.chartType == ZNChartTimeLine) {
        MyLog(@"一直显示 不用搞这个鸡毛东西");
        return;
    }
    
    if (self.maxPriceLabel && self.minPriceLabel) {
        if (isShow) {
            self.maxPriceLabel.hidden = NO;
            self.minPriceLabel.hidden = NO;
        }else{
            self.maxPriceLabel.hidden = YES;
            self.minPriceLabel.hidden = YES;
        } 
    }
}

- (CGSize)configureLongPressMaSize{
    return [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinNormalFont(10) content:@"MA20 666.66" limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}


#pragma mark -- 公用的属性

- (NSMutableArray *)KTimeDataArray{
    if (!_KTimeDataArray) {
        _KTimeDataArray = @[].mutableCopy;
    }
    return _KTimeDataArray;
}

- (NSMutableArray *)KlineDataArray{
    if (!_KlineDataArray) {
        _KlineDataArray = @[].mutableCopy;
    }
    return _KlineDataArray;
}


- (NSDateFormatter *)KTimeFormatter{
    if (!_KTimeFormatter) {
        _KTimeFormatter = [[NSDateFormatter alloc] init];
        [_KTimeFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_KTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_KTimeFormatter setDateFormat:@"HH:mm"];
    }
    return _KTimeFormatter;
}

//末端点的动画
- (CALayer *)defaultEndPoint{
    if (!_defaultEndPoint) {
        _defaultEndPoint = [self configureKTimeEndPoint];
    }
    return _defaultEndPoint;
}

- (CALayer *)endPointAnimation{
    if (!_endPointAnimation) {
        _endPointAnimation = [self configureKTimeEndPointAnimationLayer];
    }
    return _endPointAnimation;
}

- (CAShapeLayer *)reticleLayer{
    if (!_reticleLayer) {
        _reticleLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:highlightLineColor lineWidth:highlightLineWidth path:[UIBezierPath bezierPath]];
    }
    return _reticleLayer;
}

- (CAShapeLayer *)reticleCenterCircle{
    if (!_reticleCenterCircle) {
        _reticleCenterCircle = [self configureCurveLayerWithFillColor:highlightLineColor strokeColor:[UIColor clearColor] lineWidth:0 path:[UIBezierPath bezierPath]];
    }
    return _reticleCenterCircle;
}

- (CATextLayer *)KlinePressVolumeLabel{
    if (!_KlinePressVolumeLabel) {
        _KlinePressVolumeLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:MyColor(80, 80, 80) font:ZNCustomDinNormalFont(10) textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectZero];
        _KlinePressVolumeLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
        CGSize size = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinNormalFont(10) content:@"6666.66 万手" limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _KlinePressVolumeLabel.frame = CGRectMake(self.canvasLeft + priceDistanceLine, self.canvasVolumeTop + priceDistanceLine , size.width, size.height);
        _KlinePressVolumeLabel.hidden = YES;
    }
    return _KlinePressVolumeLabel;
}


- (UILabel *)KlinePressClosePriceView{
    if (!_KlinePressClosePriceView) {
        _KlinePressClosePriceView = [[UILabel alloc] init];
        _KlinePressClosePriceView.backgroundColor = highlightLineColor;
        _KlinePressClosePriceView.font = ZNCustomDinNormalFont(10);
        _KlinePressClosePriceView.textColor = [UIColor whiteColor];
        _KlinePressClosePriceView.textAlignment = NSTextAlignmentCenter;
    }
    return _KlinePressClosePriceView;
}

- (UILabel *)KTimePressRateView{
    if (!_KTimePressRateView) {
        _KTimePressRateView = [[UILabel alloc] init];
        _KTimePressRateView.backgroundColor = highlightLineColor;
        _KTimePressRateView.font = ZNCustomDinNormalFont(10);
        _KTimePressRateView.textColor = [UIColor whiteColor];
        _KTimePressRateView.textAlignment = NSTextAlignmentCenter;
    }
    return _KTimePressRateView;
}

- (UILabel *)KTimePressPriceView{
    if (!_KTimePressPriceView) {
        _KTimePressPriceView = [[UILabel alloc] init];
        _KTimePressPriceView.backgroundColor = highlightLineColor;
        _KTimePressPriceView.font = ZNCustomDinNormalFont(10);
        _KTimePressPriceView.textColor = [UIColor whiteColor];
        _KTimePressPriceView.textAlignment = NSTextAlignmentCenter;
    }
    return _KTimePressPriceView;
}


- (CALayer *)KlinePressMAPriceTipsLayer{
    if (!_KlinePressMAPriceTipsLayer) {
        _KlinePressMAPriceTipsLayer = [CALayer layer];
        _KlinePressMAPriceTipsLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
        
        CGSize contentSize = self.configureLongPressMaSize;
        CALayer *ma5Round = [CALayer layer];
        [ma5Round setMasksToBounds:YES];
        [ma5Round setCornerRadius:roundWidth];
        ma5Round.backgroundColor = ma5LineColor.CGColor;
        ma5Round.frame = CGRectMake(5, (contentSize.height + 1)/2 - roundWidth, roundWidth*2, roundWidth*2);
        [_KlinePressMAPriceTipsLayer addSublayer:ma5Round];
        
        self.ma5PriceLabel.frame = CGRectMake(CGRectGetMaxX(ma5Round.frame), 0.5, contentSize.width, contentSize.height);
        [_KlinePressMAPriceTipsLayer addSublayer:self.ma5PriceLabel];
        
        
        CALayer *ma10Round = [CALayer layer];
        [ma10Round setMasksToBounds:YES];
        [ma10Round setCornerRadius:roundWidth];
        ma10Round.backgroundColor = ma10LineColor.CGColor;
        ma10Round.frame = CGRectMake(CGRectGetMaxX(self.ma5PriceLabel.frame) + 2, (contentSize.height + 1)/2 - roundWidth, roundWidth*2, roundWidth*2);
        [_KlinePressMAPriceTipsLayer addSublayer:ma10Round];
        
        self.ma10PriceLabel.frame = CGRectMake(CGRectGetMaxX(ma10Round.frame), 0.5, contentSize.width, contentSize.height);
        [_KlinePressMAPriceTipsLayer addSublayer:self.ma10PriceLabel];
        
        
        CALayer *ma20Round = [CALayer layer];
        [ma20Round setMasksToBounds:YES];
        [ma20Round setCornerRadius:roundWidth];
        ma20Round.backgroundColor = ma20LineColor.CGColor;
        ma20Round.frame = CGRectMake(CGRectGetMaxX(self.ma10PriceLabel.frame) + 2, (contentSize.height + 1)/2 - roundWidth, roundWidth*2, roundWidth*2);
        [_KlinePressMAPriceTipsLayer addSublayer:ma20Round];
        
        self.ma20PriceLabel.frame = CGRectMake(CGRectGetMaxX(ma20Round.frame), 0.5, contentSize.width, contentSize.height);
        [_KlinePressMAPriceTipsLayer addSublayer:self.ma20PriceLabel];
        
        CGFloat BGWidth = CGRectGetMaxX(self.ma20PriceLabel.frame);
        
        _KlineLongPressMALeftFrame = CGRectMake(self.canvasLeft, self.canvasTop, BGWidth, contentSize.height + 1);
        _KlineLongPressMARightFrame = CGRectMake(self.canvasRight - BGWidth, self.canvasTop, CGRectGetMaxX(self.ma20PriceLabel.frame), contentSize.height + 1);
        
        _KlinePressMAPriceTipsLayer.frame = _KlineLongPressMALeftFrame;
        _KlinePressMAPriceTipsLayer.hidden = YES;
        
        
    }
    return _KlinePressMAPriceTipsLayer;
}

- (CATextLayer *)ma5PriceLabel{
    if (!_ma5PriceLabel) {
        _ma5PriceLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:MyColor(80, 80, 80) font:ZNCustomDinNormalFont(10) textAlignment:NSTextAlignmentCenter isWrapped:YES orAttString:nil layerFrame:CGRectZero];
        _ma5PriceLabel.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _ma5PriceLabel;
}

- (CATextLayer *)ma10PriceLabel{
    if (!_ma10PriceLabel) {
        _ma10PriceLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:MyColor(80, 80, 80) font:ZNCustomDinNormalFont(10) textAlignment:NSTextAlignmentCenter isWrapped:YES orAttString:nil layerFrame:CGRectZero];
        _ma10PriceLabel.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _ma10PriceLabel;
}

- (CATextLayer *)ma20PriceLabel{
    if (!_ma20PriceLabel) {
        _ma20PriceLabel = [ZNStockBasedConfigureLib YukeToolGetTextLayerWithTextColor:MyColor(80, 80, 80) font:ZNCustomDinNormalFont(10) textAlignment:NSTextAlignmentCenter isWrapped:YES orAttString:nil layerFrame:CGRectZero];
        _ma20PriceLabel.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _ma20PriceLabel;
}


#pragma mark -- 内部计算
//初始化配置
- (void)resetConfigure{
    self.minPrice = MAXFLOAT;
    self.maxPrice = 0;
    self.rate = 0;
    self.maxVolum = 0;
    [self.StockKTimeOrlinMainLayer removeFromSuperlayer];
    self.StockKTimeOrlinMainLayer = nil;
   
    self.StockKTimeOrlinMainLayer = [self configureBasedOrdinaryLayerWithFrame:self.layer.bounds];
    [self.layer addSublayer:self.StockKTimeOrlinMainLayer];
    [self setNeedsDisplay];
    
    
    //K线
    self.KlineStartIndex = 0;
    _KlineMaxCount = 0;
    
    if (self.isLandscape) {
        self.KlinePressVolumeLabel = nil;
        self.KlinePressClosePriceView = nil;
        self.KTimePressPriceView = nil;
        self.KTimePressRateView = nil;
   
        if (self.chartType != ZNChartTimeLine && !self.isChangeType) {
            
            
            self.KlineLandscapeVolumeWidth = self.KlineVolumeUnitWidth;
            
            if (self.KlineDataArray.count > (NSInteger )self.canvasWidth/self.KlineLandscapeVolumeWidth) {
                self.KlineStartIndex = self.KlineDataArray.count - (NSInteger )self.canvasWidth/self.KlineLandscapeVolumeWidth;
            }
            
            
            
            if (self.tempDrawIndex == 0) {
                self.tempDrawIndex = 50 + self.KlineStartIndex;
            }
            
            _KlineMaxCount = self.KlineDataArray.count > (self.KlineStartIndex + self.numberOfKlineCanShow)?(self.KlineStartIndex + self.numberOfKlineCanShow):self.KlineDataArray.count;
            
            if (_KlineMaxCount < self.KlineDataArray.count) {
                _KlineMaxCount += 1;
            }
            
        }
        
    }else{
        
        if (self.chartType != ZNChartTimeLine && !self.isChangeType) {
            if (self.KlineDataArray.count > self.canvasWidth/self.KlineVolumeUnitWidth) {
                self.KlineStartIndex = self.KlineDataArray.count - self.canvasWidth/self.KlineVolumeUnitWidth;
            }
            
            _KlineMaxCount = self.KlineDataArray.count;
        }
 
    }
    
    
}
// 计算分时的相关数据
- (void)calculateKTimeRelevantData{
    
    for (ZNStockTimeSharingModel *timeModel in self.KTimeDataArray) {
        if ([timeModel isKindOfClass:[ZNStockTimeSharingModel class]]) {
            CGFloat price = [timeModel.price floatValue];
            CGFloat avgPrice = [timeModel.avg_price floatValue];
            NSInteger volume = [timeModel.volume integerValue];
            //最大成交量
            self.maxVolum = MAX(self.maxVolum, volume);
            //最高价🈴️最低价
            self.minPrice = MIN(self.minPrice, price);
            self.minPrice = MIN(self.minPrice, avgPrice);
            
            self.maxPrice = MAX(self.maxPrice, price);
            self.maxPrice = MAX(self.maxPrice, avgPrice);
        }
    }
    
    if (self.maxPrice == self.minPrice && self.maxPrice== self.YesterdayClosingPrice) {
        self.maxPrice = self.YesterdayClosingPrice + 0.01;
        self.minPrice = self.YesterdayClosingPrice - 0.01;
    }
    
    if (self.minPrice == 0) {//0停牌
        self.maxPrice = self.YesterdayClosingPrice + 0.01;
        self.minPrice = self.YesterdayClosingPrice - 0.01;
        
    }
    
    
    
    //计算振幅
    CGFloat maxDifferencePrice = fabs(self.maxPrice - self.YesterdayClosingPrice);
    CGFloat minDifferencePrice  = fabs(self.minPrice - self.YesterdayClosingPrice);
    if (maxDifferencePrice > minDifferencePrice) {
        self.rate = maxDifferencePrice /self.YesterdayClosingPrice;
        self.minPrice = (1 - self.rate)*self.YesterdayClosingPrice;
    }else{
        
        self.rate = minDifferencePrice/self.YesterdayClosingPrice;
        
        if (self.minPrice > self.YesterdayClosingPrice) {
            self.minPrice = (1 - self.rate)*self.YesterdayClosingPrice;
        }
        self.maxPrice = (1 + self.rate)*self.YesterdayClosingPrice;
        
    }
    
}


//计算k线的相关数据
- (void)calculateKlineRelevantData{
    
    for (NSInteger i = self.KlineStartIndex; i < _KlineMaxCount; i++) {
        ZNStockKlineModel *model = self.KlineDataArray[i];
        CGFloat highPrice = [model.high floatValue];
        CGFloat lowPrice = [model.low floatValue];
        CGFloat ma5Price = [model.ma5 floatValue];
        CGFloat ma10Price = [model.ma10 floatValue];
        CGFloat ma20Price = [model.ma20 floatValue];
        NSInteger volume = [model.volume integerValue];
        
        //最高价
        self.maxPrice = MAX(self.maxPrice, highPrice);
        self.maxPrice = MAX(self.maxPrice, ma5Price);
        self.maxPrice = MAX(self.maxPrice, ma10Price);
        self.maxPrice = MAX(self.maxPrice, ma20Price);
        //最大成交量
        self.maxVolum = MAX(self.maxVolum, volume);
        //最低价格
        self.minPrice = MIN(self.minPrice, lowPrice);
        self.minPrice = MIN(self.minPrice, ma5Price);
        self.minPrice = MIN(self.minPrice, ma10Price);
        self.minPrice = MIN(self.minPrice, ma20Price);
    }
    
    MyLog(@"最高价,最低价,最大成交量:%ld",self.maxVolum);
}

#pragma mark -- 请求数据
- (void)loadingklineDataWithStockCode:(NSString *)stockCode YesterdayClosingPrice:(CGFloat )YesterdayClosingPrice KlineType:(ZNChartType)chartType
{
    if (!stockCode) {
        MyLog(@"没有股票代码");
        return;
    }
    self.stockCode = stockCode;
    self.chartType = chartType;
    if (YesterdayClosingPrice >= 0) {
        self.YesterdayClosingPrice = YesterdayClosingPrice;
    }
    if (self.dataTask) {
        [self.dataTask cancel];
    }
    MyLog(@"当前的请求任务:%@",self.dataTask);
    if (self.chartType == ZNChartTimeLine) {
        self.dataTask = [ZNStockBasedConfigureLib getStockTimeSharingDateWithStockCode:stockCode success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDic = (NSDictionary *)responseObject;
                if (responseDic.count > 0) {
                    //有值
                    NSArray *timeSortedArray = [[responseDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        return [obj1 compare:obj2 options:NSNumericSearch];
                    }];//对建值进行排序
                    [self.KTimeDataArray removeAllObjects];
                    for (NSString *dateString in timeSortedArray) {
                        ZNStockTimeSharingModel *timeModel = [[ZNStockTimeSharingModel alloc] init];
                        NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[dateString integerValue]*60];
                        timeModel.time = [self.KTimeFormatter stringFromDate:timeDate];
                        NSDictionary *valueDic = responseDic[dateString];
                        timeModel.price = valueDic[@"p"];
                        timeModel.avg_price = valueDic[@"a"];
                        timeModel.volume = valueDic[@"v"];
                        [self.KTimeDataArray addObject:timeModel];
                    }
                    //准备画图
                    [self prepareToDraw];
                }else{
                    MyLog(@"没有数据集");
                }
            }
        } failure:^{
            
        }];
        
    } else{
        self.dataTask =  [ZNStockBasedConfigureLib getStockKlineDataWithStockCode:stockCode kType:self.chartType success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDic = (NSDictionary *)responseObject;
                if (responseDic.count > 0) {
                    //有值
                    NSArray *timeSortedArray = [[responseDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        return [obj1 compare:obj2 options:NSNumericSearch];
                    }];//对建值进行排序
                    [self.KlineDataArray removeAllObjects];
                    for (NSString *dateString in timeSortedArray) {
                        ZNStockKlineModel *lineModel = [[ZNStockKlineModel alloc] init];
                        lineModel.time = dateString;
                        NSDictionary *valueDic = responseDic[dateString];
                        [lineModel setValuesForKeysWithDictionary:valueDic];
                        [self.KlineDataArray addObject:lineModel];
                    }
                    //准备画图
                    [self prepareToDraw];
                }else{
                    MyLog(@"没有数据集");
                }
            }
        } failure:^{
            MyLog(@"请求错误");
        }];
    }
    
}

- (void)prepareToDraw{
    MyLog(@"这个方法要重写");
    [self resetConfigure];
}

- (void)resetSubConfigureBecauseOfChangeChoice{
    MyLog(@"切换的时候重写");
}

- (void)configureChangeChoiceWithTitle:(NSString *)typeTitle{
    [self resetSubConfigureBecauseOfChangeChoice];
    [self removeGestureRecognizer:self.longPressGesture];
    [self configureLongPressEndResetInfo];
    self.isHaveAnimation = YES;
    self.isChangeType = YES;
    if ([typeTitle isEqualToString:@"分 时"]) {
        [self loadingklineDataWithStockCode:self.stockCode YesterdayClosingPrice:self.YesterdayClosingPrice KlineType:ZNChartTimeLine];
    }
    
    if ([typeTitle isEqualToString:@"日 K"]) {
        [self loadingklineDataWithStockCode:self.stockCode YesterdayClosingPrice:self.YesterdayClosingPrice KlineType:ZNChartDailyKLine];
    }
    
    if ([typeTitle isEqualToString:@"周 K"]) {
        [self loadingklineDataWithStockCode:self.stockCode YesterdayClosingPrice:self.YesterdayClosingPrice KlineType:ZNChartWeeklyKLine];
    }
    
    if ([typeTitle isEqualToString:@"月 K"]) {
        [self loadingklineDataWithStockCode:self.stockCode YesterdayClosingPrice:self.YesterdayClosingPrice KlineType:ZNChartMonthlyKLine];
    }
    [self configureChangeType];
    [self resetConfigure];
    self.isChangeType = NO;
    
}

#pragma mark -- 开始绘制线条K线和分时
//绘制分时线
- (void)drawKTimeLineAndVolume{
    
    //配置相关数据
    CGFloat everyDollarHeight = self.configurePriceUnitHeight;
    
    CGFloat unitVolumeHeight = self.configureVolumeUnitHeight;
    
    CGFloat volumeWidth =  0.7 * self.KTimeVolumeUnitWidth;
    
    //设置路径
    UIBezierPath *KTimePricePath = [UIBezierPath bezierPath];
    UIBezierPath *KTimeAvgPricePath = [UIBezierPath bezierPath];
    UIBezierPath *KTimeBackgroundPath = [UIBezierPath bezierPath];
    CGPoint leftGradientLayerOrigin = CGPointZero;
    CGPoint rightGradientLayerOrigin = CGPointZero;
    //最后一个点的坐标
    CGPoint endKTimePoint = CGPointZero;
    //  成交量
    UIBezierPath *KTimeRedVolumePath = [UIBezierPath bezierPath];
    UIBezierPath *kTimeGreentVolumePath = [UIBezierPath bezierPath];
    UIBezierPath *KTimeGrayVolumPath = [UIBezierPath bezierPath];
    for (int i = 0; i < self.KTimeDataArray.count; i++) {
        ZNStockTimeSharingModel *model = self.KTimeDataArray[i];
        CGFloat startDrawPointX = self.KTimeVolumeUnitWidth*i + self.KTimeVolumeUnitWidth/2 + self.canvasLeft;
        CGFloat volumeHeight = [model.volume integerValue] * unitVolumeHeight;
        CGFloat priceY = self.canvasTop + self.canvasKlineHeight/2;
        CGFloat avgPriceY = self.canvasTop + self.canvasKlineHeight/2;
        
        if (self.configurePriceDifference > 0) {
            priceY = (self.maxPrice - [model.price floatValue])*everyDollarHeight + self.canvasTop + self.configureKlineYAxisPadding;
            avgPriceY = (self.maxPrice - [model.avg_price floatValue])*everyDollarHeight + self.canvasTop + self.configureKlineYAxisPadding;
            
        }else {//涨停或者跌停
            if (self.maxPrice > self.YesterdayClosingPrice) {//涨停
                priceY = self.canvasTop + self.configureKlineYAxisPadding;
                avgPriceY = self.canvasTop + self.configureKlineYAxisPadding;
            }
            
            if (self.maxPrice < self.YesterdayClosingPrice) {//跌停
                priceY = self.canvasKlineBottom - self.configureKlineYAxisPadding;
                avgPriceY = self.canvasKlineBottom - self.configureKlineYAxisPadding;
            }
            
        }
        UIColor *finalVolumeColor = [UIColor clearColor];
        //成交价
        if (i == 0) {
            [KTimePricePath moveToPoint:CGPointMake(startDrawPointX, priceY)];
            [KTimeAvgPricePath moveToPoint:CGPointMake(startDrawPointX, avgPriceY)];
            
            //
            [KTimeBackgroundPath moveToPoint:CGPointMake(startDrawPointX, self.canvasKlineBottom)];
            [KTimeBackgroundPath addLineToPoint:CGPointMake(startDrawPointX, priceY)];
            //左侧剃度
            leftGradientLayerOrigin = CGPointMake(startDrawPointX, priceY);
            //成交量
            finalVolumeColor = [self configureVolumeColorWithOldPrice:self.YesterdayClosingPrice latestPrice:[model.price floatValue]];
        }else{
            [KTimePricePath addLineToPoint:CGPointMake(startDrawPointX, priceY)];
            [KTimeAvgPricePath addLineToPoint:CGPointMake(startDrawPointX, avgPriceY)];
            
            [KTimeBackgroundPath addLineToPoint:CGPointMake(startDrawPointX, priceY)];
            if (i == self.KTimeDataArray.count - 1) {
                [KTimeBackgroundPath addLineToPoint:CGPointMake(startDrawPointX, self.canvasKlineBottom)];
                [KTimeBackgroundPath closePath];
                rightGradientLayerOrigin = CGPointMake(startDrawPointX, priceY);
                endKTimePoint = CGPointMake(startDrawPointX, priceY);
                
                
            }
            
            //成交量
            ZNStockTimeSharingModel *oldModel = self.KTimeDataArray[i-1];
            finalVolumeColor = [self configureVolumeColorWithOldPrice:[oldModel.price floatValue] latestPrice:[model.price floatValue]];
            
        }
        //成交量
        if (volumeHeight > 0) {
            if ([ZNStockBasedConfigureLib YukeToolJudgeWetherEqualColor:lineColorWithRed toColor:finalVolumeColor]) {//
                [KTimeRedVolumePath moveToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                [KTimeRedVolumePath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom - volumeHeight)];
            }
            
            if ([ZNStockBasedConfigureLib YukeToolJudgeWetherEqualColor:lineColorWithGreen toColor:finalVolumeColor]) {
                [kTimeGreentVolumePath moveToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                [kTimeGreentVolumePath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom - volumeHeight)];
            }
            
            if ([ZNStockBasedConfigureLib YukeToolJudgeWetherEqualColor:lineColorWithGray toColor:finalVolumeColor]) {
                [KTimeGrayVolumPath moveToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                [KTimeGrayVolumPath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom - volumeHeight)];
            }
        }
    }
    
    //背景
    CAShapeLayer *KTimePriceBackGroundLayer = [self configureCurveLayerWithFillColor:[timePriceLineColor colorWithAlphaComponent:0.2] strokeColor:[UIColor clearColor] lineWidth:0 path:KTimeBackgroundPath];
    //均价
    CAShapeLayer *KTimeAvgPriceLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:avgPrineLineColor lineWidth:timeLineWidth path:KTimeAvgPricePath];
    [self.StockKTimeOrlinMainLayer addSublayer:KTimePriceBackGroundLayer];
    [self.StockKTimeOrlinMainLayer addSublayer:[self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:timePriceLineColor lineWidth:timeLineWidth path:KTimePricePath]];
    [self.StockKTimeOrlinMainLayer addSublayer:KTimeAvgPriceLayer];
    if (self.isHaveAnimation) {
         [self configureLayerAnimationWithLayer:KTimeAvgPriceLayer];
    }
    //添加渐变色
    
    if (self.KTimeDataArray.count > 2) {
        [KTimePriceBackGroundLayer addSublayer:[self configureCradientWithFrame:CGRectMake(leftGradientLayerOrigin.x - timeLineWidth/2, leftGradientLayerOrigin.y, timeLineWidth, self.canvasKlineBottom - leftGradientLayerOrigin.y)]];
        [KTimePriceBackGroundLayer addSublayer:[self configureCradientWithFrame:CGRectMake(rightGradientLayerOrigin.x - timeLineWidth/2, rightGradientLayerOrigin.y, timeLineWidth, self.canvasKlineBottom - rightGradientLayerOrigin.y)]];
    }
    //添加动画
    if (!CGPointEqualToPoint(endKTimePoint, CGPointZero)) {
        self.defaultEndPoint.frame = CGRectMake(endKTimePoint.x - KTimeEndPointSize/2, endKTimePoint.y - KTimeEndPointSize/2, KTimeEndPointSize, KTimeEndPointSize);
        self.endPointAnimation.frame = self.defaultEndPoint.frame;
        [self.StockKTimeOrlinMainLayer addSublayer:self.defaultEndPoint];
        [self.StockKTimeOrlinMainLayer addSublayer:self.endPointAnimation];
    }
    //成交量
    if (!KTimeRedVolumePath.empty) {
        CAShapeLayer *volumeLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithRed lineWidth:volumeWidth path:KTimeRedVolumePath];
        [self.StockKTimeOrlinMainLayer addSublayer:volumeLayer];
        if (self.isHaveAnimation) {
            [self configureLayerAnimationWithLayer:volumeLayer];
        }
        
    }
    
    if (!kTimeGreentVolumePath.empty) {
        CAShapeLayer *volumeLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithGreen lineWidth:volumeWidth path:kTimeGreentVolumePath];
        [self.StockKTimeOrlinMainLayer addSublayer:volumeLayer];
        if (self.isHaveAnimation) {
           [self configureLayerAnimationWithLayer:volumeLayer];
        }
        
    }
    
    if (!KTimeGrayVolumPath.empty) {
        CAShapeLayer *volumeLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithGray lineWidth:volumeWidth path:KTimeGrayVolumPath];
        [self.StockKTimeOrlinMainLayer addSublayer:volumeLayer];
        if (self.isHaveAnimation) {
            [self configureLayerAnimationWithLayer:volumeLayer];
        }
        
    }
    //长按的十字线
    [self.StockKTimeOrlinMainLayer addSublayer:self.reticleLayer];
    //Y轴刻度
    [self configureKtimeYAxisWhetherIsLabndscape:self.isLandscape superLayer:self.StockKTimeOrlinMainLayer];
    self.isHaveAnimation = NO;
    
}

//画k线
- (void)drawKlineLineAndVolume{
    
    CGFloat everyDollarHeight = self.configurePriceUnitHeight;
    CGFloat unitVolumeHeight = self.configureVolumeUnitHeight;
    CGFloat unitVolumeWidth = self.KlineFinalVolumeWidth;
    CGFloat volumeWidth =  0.8 * unitVolumeWidth;
    
    UIBezierPath *KlineMa5Path = [UIBezierPath bezierPath];
    UIBezierPath *KlineMa10Path = [UIBezierPath bezierPath];
    UIBezierPath *KlineMa20Path = [UIBezierPath bezierPath];
    //  成交量
    UIBezierPath *KlineRedVolumePath = [UIBezierPath bezierPath];
    UIBezierPath *klineGreentVolumePath = [UIBezierPath bezierPath];
    UIBezierPath *KlineGrayVolumPath = [UIBezierPath bezierPath];
    //阴阳线
    UIBezierPath *KlineRedFatPath = [UIBezierPath bezierPath];
    UIBezierPath *KlineRedFinePath  = [UIBezierPath bezierPath];
    UIBezierPath *KlineGreenFatPath = [UIBezierPath bezierPath];
    UIBezierPath *KlineGreenFinePath = [UIBezierPath bezierPath];
    UIBezierPath *KlineCoordinatePath = [self configureBasedCoordinatePathWithIsLandscape:self.isLandscape];
    NSString *tempDateString = @"";
    NSDateComponents *dateCompinents = [ZNStockBasedConfigureLib YukeToolGetCurrentDateComponents];
    NSString *currentYear = [NSString stringWithFormat:@"%ld",[dateCompinents year]];
    NSInteger currentMonth = [dateCompinents month];
    //    NSInteger tempDate = 0;
    NSMutableArray *xAxisStartXArray = @[].mutableCopy;
    NSMutableArray *xAxisDesc = @[].mutableCopy;
    CGFloat xAxisDescMinWidth = self.configureKlineXAxisDescSize.width;
    
    
    
    for (NSInteger i = self.KlineStartIndex; i < _KlineMaxCount; i++) {
        ZNStockKlineModel *lineModel = self.KlineDataArray[i];
        CGFloat startDrawPointX = unitVolumeWidth*(i - self.KlineStartIndex) + unitVolumeWidth/2 + self.canvasLeft;
        CGFloat openY = ((self.maxPrice - [lineModel.open floatValue]) * everyDollarHeight) + self.canvasTop+self.configureKlineYAxisPadding;
        CGFloat closeY = ((self.maxPrice - [lineModel.close floatValue]) * everyDollarHeight) + self.canvasTop+self.configureKlineYAxisPadding;
        CGFloat highY = ((self.maxPrice - [lineModel.high floatValue]) * everyDollarHeight) + self.canvasTop+self.configureKlineYAxisPadding;
        CGFloat lowY = ((self.maxPrice - [lineModel.low floatValue]) * everyDollarHeight) + self.canvasTop+self.configureKlineYAxisPadding;
        
        CGFloat ma5Y = ((self.maxPrice - [lineModel.ma5 floatValue])*everyDollarHeight)+self.canvasTop+self.configureKlineYAxisPadding;
        CGFloat ma10Y = ((self.maxPrice - [lineModel.ma10 floatValue])*everyDollarHeight)+self.canvasTop+self.configureKlineYAxisPadding;
        CGFloat ma20Y = ((self.maxPrice - [lineModel.ma20 floatValue])*everyDollarHeight)+self.canvasTop+self.configureKlineYAxisPadding;
        
        
        CGFloat volumeHeight = [lineModel.volume integerValue] * unitVolumeHeight;
        UIColor *finalColor = [UIColor clearColor];
        
        if (openY < closeY) {//开>收
            finalColor = lineColorWithGreen;
        }
        
        if (openY > closeY) {//开<收
            finalColor = lineColorWithRed;
        }
        
        if (openY == closeY) {//相等
            finalColor = lineColorWithRed;
            if (i > 1) {
                ZNStockKlineModel *beforeLineModel = self.KlineDataArray[i - 1];
                if ([beforeLineModel.close floatValue] > [lineModel.close floatValue]) {
                    finalColor = lineColorWithGreen;
                }
            }
        }
        
        
        if ([ZNStockBasedConfigureLib YukeToolJudgeWetherEqualColor:lineColorWithRed toColor:finalColor]) {//
            if (volumeHeight > 0) {
                [KlineRedVolumePath moveToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                [KlineRedVolumePath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom - volumeHeight)];
            }
            [KlineRedFatPath moveToPoint:CGPointMake(startDrawPointX, openY)];
            [KlineRedFatPath addLineToPoint:CGPointMake(startDrawPointX, openY==closeY?(closeY+1):closeY)];
            [KlineRedFinePath moveToPoint:CGPointMake(startDrawPointX, lowY)];
            [KlineRedFinePath addLineToPoint:CGPointMake(startDrawPointX, highY)];
            
        }
        
        if ([ZNStockBasedConfigureLib YukeToolJudgeWetherEqualColor:lineColorWithGreen toColor:finalColor]) {
            if (volumeHeight > 0) {
                [klineGreentVolumePath moveToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                [klineGreentVolumePath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom - volumeHeight)];
            }
            [KlineGreenFatPath moveToPoint:CGPointMake(startDrawPointX, openY)];
            [KlineGreenFatPath addLineToPoint:CGPointMake(startDrawPointX, openY==closeY?(closeY+1):closeY)];
            [KlineGreenFinePath moveToPoint:CGPointMake(startDrawPointX, lowY)];
            [KlineGreenFinePath addLineToPoint:CGPointMake(startDrawPointX, highY)];
        }
        
        if ([lineModel.chg_pct floatValue] == 0) {
            finalColor = lineColorWithGray;
        }
        
        if ([ZNStockBasedConfigureLib YukeToolJudgeWetherEqualColor:lineColorWithGray toColor:finalColor]) {
            if (volumeHeight > 0) {
                [KlineGrayVolumPath moveToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                [KlineGrayVolumPath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom - volumeHeight)];
            }
            
        }
        //均线
        if (i == self.KlineStartIndex) {
            [KlineMa5Path moveToPoint:CGPointMake(startDrawPointX, ma5Y)];
            [KlineMa10Path moveToPoint:CGPointMake(startDrawPointX, ma10Y)];
            [KlineMa20Path moveToPoint:CGPointMake(startDrawPointX, ma20Y)];
            
        }else{
            [KlineMa5Path addLineToPoint:CGPointMake(startDrawPointX, ma5Y)];
            [KlineMa10Path addLineToPoint:CGPointMake(startDrawPointX, ma10Y)];
            [KlineMa20Path addLineToPoint:CGPointMake(startDrawPointX, ma20Y)];
        }
        
        //刻度
        NSString *modelTime = [lineModel.time substringToIndex:self.chartType == ZNChartMonthlyKLine?4:7];
        //        NSInteger modelDate = [[self.monthFormatter dateFromString:[lineModel.time substringFromIndex:7]] timeIntervalSince1970];
        
        
        BOOL isCanDrawXAxis = YES;
        if (xAxisStartXArray.count > 0) {
            NSNumber *floatNumber = [xAxisStartXArray lastObject];
            CGFloat beforStartX = [floatNumber floatValue];
            if (startDrawPointX - beforStartX < 1.5 * xAxisDescMinWidth) {
                isCanDrawXAxis = NO;
            }
            
            if (self.chartType == ZNChartWeeklyKLine) {
                if (startDrawPointX - beforStartX < 3 * xAxisDescMinWidth) {
                    isCanDrawXAxis = NO;
                }
            }
            
        }
        
        if (![tempDateString isEqualToString:modelTime] && isCanDrawXAxis) {
            tempDateString = modelTime;
            if (startDrawPointX > self.canvasLeft + xAxisDescMinWidth && startDrawPointX < self.canvasRight - xAxisDescMinWidth) {
                if (self.chartType == ZNChartMonthlyKLine) {
                    if ([tempDateString isEqualToString:currentYear]) {
                        if (currentMonth > 7) {
                            [KlineCoordinatePath moveToPoint:CGPointMake(startDrawPointX, self.canvasTop)];
                            [KlineCoordinatePath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                            [xAxisStartXArray addObject:[NSNumber numberWithFloat:startDrawPointX]];
                            [xAxisDesc addObject:modelTime];
                        }
                        
                    }else{
                        [KlineCoordinatePath moveToPoint:CGPointMake(startDrawPointX, self.canvasTop)];
                        [KlineCoordinatePath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                        [xAxisStartXArray addObject:[NSNumber numberWithFloat:startDrawPointX]];
                        [xAxisDesc addObject:modelTime];
                    }
                }
                
                
                if (self.chartType == ZNChartDailyKLine) {
                    [KlineCoordinatePath moveToPoint:CGPointMake(startDrawPointX, self.canvasTop)];
                    [KlineCoordinatePath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                    [xAxisStartXArray addObject:[NSNumber numberWithFloat:startDrawPointX]];
                    [xAxisDesc addObject:modelTime];
                }
                
                if (self.chartType == ZNChartWeeklyKLine) {
                    [KlineCoordinatePath moveToPoint:CGPointMake(startDrawPointX, self.canvasTop)];
                    [KlineCoordinatePath addLineToPoint:CGPointMake(startDrawPointX, self.canvasBottom)];
                    [xAxisStartXArray addObject:[NSNumber numberWithFloat:startDrawPointX]];
                    [xAxisDesc addObject:modelTime];
                }
                
                
            }
        }
        
        
    }
    
    CAShapeLayer *KlineCoordinateLayer = [self configureBasedCoordinateLayer];
    [KlineCoordinateLayer setPath:KlineCoordinatePath.CGPath];
    CAShapeLayer *redFatLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithRed lineWidth:volumeWidth path:KlineRedFatPath];
    CAShapeLayer *greenFatLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithGreen lineWidth:volumeWidth path:KlineGreenFatPath];
    CAShapeLayer *redFineLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithRed lineWidth:1 path:KlineRedFinePath];
    CAShapeLayer *greenFineLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithGreen lineWidth:1 path:KlineGreenFinePath];
    CAShapeLayer *KlineMa5Layer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:ma5LineColor lineWidth:timeLineWidth path:KlineMa5Path];
    CAShapeLayer *KlineMa10Layer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:ma10LineColor lineWidth:timeLineWidth path:KlineMa10Path];
    CAShapeLayer *KlineMa20Layer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:ma20LineColor lineWidth:timeLineWidth path:KlineMa20Path];
    [self.StockKTimeOrlinMainLayer addSublayer:KlineCoordinateLayer];
    [self.StockKTimeOrlinMainLayer addSublayer:redFatLayer];
    [self.StockKTimeOrlinMainLayer addSublayer:redFineLayer];
    [self.StockKTimeOrlinMainLayer addSublayer:greenFatLayer];
    [self.StockKTimeOrlinMainLayer addSublayer:greenFineLayer];
    [self.StockKTimeOrlinMainLayer addSublayer:KlineMa5Layer];
    [self.StockKTimeOrlinMainLayer addSublayer:KlineMa10Layer];
    [self.StockKTimeOrlinMainLayer addSublayer:KlineMa20Layer];
    if (self.isHaveAnimation) {
        [self configureLayerAnimationWithLayer:redFatLayer];
        [self configureLayerAnimationWithLayer:redFineLayer];
        [self configureLayerAnimationWithLayer:greenFatLayer];
        [self configureLayerAnimationWithLayer:greenFineLayer];
        [self configureLayerAnimationWithLayer:KlineMa5Layer];
        [self configureLayerAnimationWithLayer:KlineMa10Layer];
        [self configureLayerAnimationWithLayer:KlineMa20Layer];
    }
    //成交量
    if (!KlineRedVolumePath.empty) {
        CAShapeLayer *volumeLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithRed lineWidth:volumeWidth path:KlineRedVolumePath];
        [self.StockKTimeOrlinMainLayer addSublayer:volumeLayer];
        if (self.isHaveAnimation) {
            [self configureLayerAnimationWithLayer:volumeLayer];
        }
    }
    
    if (!klineGreentVolumePath.empty) {
        CAShapeLayer *volumeLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithGreen lineWidth:volumeWidth path:klineGreentVolumePath];
        [self.StockKTimeOrlinMainLayer addSublayer:volumeLayer];
        if (self.isHaveAnimation) {
            [self configureLayerAnimationWithLayer:volumeLayer];
        }
        
    }
    
    if (!KlineGrayVolumPath.empty) {
        CAShapeLayer *volumeLayer = [self configureCurveLayerWithFillColor:[UIColor clearColor] strokeColor:lineColorWithGray lineWidth:volumeWidth path:KlineGrayVolumPath];
        [self.StockKTimeOrlinMainLayer addSublayer:volumeLayer];
        if (self.isHaveAnimation) {
            CABasicAnimation *animation = [self configureLayerAnimationWithLayer:volumeLayer];
            animation.duration = 0.3f;
        }
        
    }
    //X刻度
    [self configureKlineXAxisWithPointArray:xAxisStartXArray descArray:xAxisDesc superLayer:self.StockKTimeOrlinMainLayer];
    //长按的十字线
    [self.StockKTimeOrlinMainLayer addSublayer:self.reticleLayer];
    //    [self.StockKTimeOrlinMainLayer addSublayer:self.KlinePressClosePriceBGLayer];
    //Y轴刻度
    [self configureKtimeYAxisWhetherIsLabndscape:self.isLandscape superLayer:self.StockKTimeOrlinMainLayer];
    [self.StockKTimeOrlinMainLayer addSublayer:self.KlinePressVolumeLabel];
    [self.StockKTimeOrlinMainLayer addSublayer:self.KlinePressMAPriceTipsLayer];
    
    if (self.isLandscape && _KlineMaxCount > 0 && self.KlineDataArray.count > 0) {
        ZNStockKlineModel *lastModel = self.KlineDataArray[_KlineMaxCount - 1];
        self.ma5PriceLabel.string = [@"MA5 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[lastModel.ma5 floatValue]]];
        self.ma10PriceLabel.string = [@"MA10 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[lastModel.ma10 floatValue]]];
        self.ma20PriceLabel.string = [@"MA20 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[lastModel.ma20 floatValue]]];
        self.KlinePressMAPriceTipsLayer.hidden = NO;
    }
    
    self.isHaveAnimation = NO;
    
}


#pragma mark - 寻找点
//根局数数组的位置 判断该点的坐标价格的位置
- (CGPoint )KTimePricePointLocationWithIndexInPoints:(NSInteger )index{
    
    if (index > self.KTimeDataArray.count - 1) {
        return CGPointZero;
    }
    
    CGFloat startPointX = self.KTimeVolumeUnitWidth*index + self.KTimeVolumeUnitWidth/2 + self.canvasLeft;
    CGFloat startPointY = self.canvasTop + self.canvasKlineHeight/2;
    ZNStockTimeSharingModel *model = self.KTimeDataArray[index];
    if (self.maxPrice - self.minPrice> 0) {
        startPointY = (self.maxPrice - [model.price floatValue])*self.configurePriceUnitHeight + self.canvasTop + self.configureKlineYAxisPadding;
    }else {//涨停或者跌停
        if (self.maxPrice > self.YesterdayClosingPrice) {//涨停
            startPointY = self.canvasTop + self.configureKlineYAxisPadding;
        }
        if (self.maxPrice < self.YesterdayClosingPrice) {//跌停
            startPointY = self.canvasKlineBottom - self.configureKlineYAxisPadding;
        }
    }
    
    CGPoint linePoint = CGPointMake(startPointX, startPointY);
    
    MyLog(@"线上的点:%@",NSStringFromCGPoint(linePoint));
    
    return linePoint;
}

//根局数数组的位置 判断该点的坐标价格的位置
- (CGPoint )KlineClosePricePointLocationWithIndexInPoints:(NSInteger )index{
    
    if (index > self.KlineDataArray.count - 1) {
        return CGPointZero;
    }
    
    
    CGFloat startPointX = self.KlineFinalVolumeWidth*(index - self.KlineStartIndex) + self.KlineFinalVolumeWidth/2 + self.canvasLeft;
    
    ZNStockKlineModel *model = self.KlineDataArray[index];
    
    CGFloat startPointY = ((self.maxPrice - [model.close floatValue]) * self.configurePriceUnitHeight) + self.canvasTop+ self.configureKlineYAxisPadding;
    
    
    
    CGPoint linePoint = CGPointMake(startPointX, startPointY);
    
    MyLog(@"线上的点:%@",NSStringFromCGPoint(linePoint));
    
    return linePoint;
}

#pragma mark - 长按手势
- (UILongPressGestureRecognizer *)longPressGesture{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHander:)];
        _longPressGesture.minimumPressDuration = 0.5;
    }
    return _longPressGesture;
}


- (void)longPressHander:(UILongPressGestureRecognizer *)sender{
    
    if (self.chartType == 0 || (self.KlineDataArray.count == 0 && self.KTimeDataArray.count == 0)) {
        MyLog(@"啥都没有按个鬼啊");
        return;
    }
    
    
    CGPoint touchPoint = [sender locationInView:self];
    if (CGRectContainsPoint(CGRectMake(self.canvasLeft, self.canvasTop, self.canvasWidth, self.canvasHeight), touchPoint)) {
        
        NSInteger touchPointIndex = (NSInteger )(touchPoint.x - self.canvasLeft)/(self.chartType==ZNChartTimeLine?self.KTimeVolumeUnitWidth:self.KlineFinalVolumeWidth);
        
        if (sender.state == UIGestureRecognizerStateBegan) {
            MyLog(@"长按的点:%@",NSStringFromCGPoint(touchPoint));
            _longPressStartPoint = touchPoint;
            if (self.chartType == ZNChartTimeLine) {//分时
                if (self.KTimeDataArray.count == 0) {
                    MyLog(@"咩有数据");
                    return;
                }
                
                if (!self.reticleCenterCircle.superlayer) {
                    [self.StockKTimeOrlinMainLayer addSublayer:self.reticleCenterCircle];
                }
                
                
                if (touchPointIndex >= self.KTimeDataArray.count) {
                    touchPointIndex = self.KTimeDataArray.count - 1;
                }
                CGPoint linePoint = [self KTimePricePointLocationWithIndexInPoints:touchPointIndex];
                [self.reticleLayer setPath:[self configureReticleLineWithCenterPoint:linePoint orTipsPrice:nil].CGPath];
                [self.reticleCenterCircle setPath:[self configureCircleWithRadius:2.5 centerPoint:linePoint].CGPath];
                [self configureStartDelegateAction];
                ZNStockTimeSharingModel *model = self.KTimeDataArray[touchPointIndex];
                [self configureKTimeDelegateActionWithTimeSharingModel:model];
                
                
                //横屏显示数据
                if (self.isLandscape) {
                    if (!self.KTimePressPriceView.superview) {
                        [self addSubview:self.KTimePressPriceView];
                    }
                    if (!self.KTimePressRateView.superview) {
                        [self addSubview:self.KTimePressRateView];
                    }
                    
                    CGFloat rate = ([model.price floatValue]-self.YesterdayClosingPrice)/self.YesterdayClosingPrice*100;
                    NSString *rateStr =  [NSString stringWithFormat:@"%.2f%%",rate];
                    NSString *priceStr = model.price;
                    
                    CGSize rateSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinNormalFont(10) content:rateStr limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    CGRect rateRect = CGRectMake(self.canvasRight + priceDistanceLine, linePoint.y - rateSize.height/2, rateSize.width, rateSize.height);
                    
                    CGSize priceSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinNormalFont(10) content:priceStr limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    
                    CGRect priceRect = CGRectMake(self.canvasLeft -  priceDistanceLine - priceSize.width, linePoint.y - priceSize.height/2, priceSize.width, priceSize.height);
                    self.KTimePressRateView.frame = rateRect;
                    self.KTimePressPriceView.frame = priceRect;
                    self.KTimePressPriceView.text = priceStr;
                    self.KTimePressRateView.text = rateStr;
                    
                }
                
            }else{
                
                if (self.KlineDataArray.count == 0) {
                    return;
                }
                
                if (touchPointIndex >= self.KlineDataArray.count) {
                    touchPointIndex = self.KlineDataArray.count - 1;
                }else{
                    touchPointIndex += self.KlineStartIndex;
                }
                ZNStockKlineModel *currentKlineModel = self.KlineDataArray[touchPointIndex];
                NSString *closePrice = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[currentKlineModel.close floatValue]];
                CGPoint linePoint = [self KlineClosePricePointLocationWithIndexInPoints:touchPointIndex];
                [self.reticleLayer setPath:[self configureReticleLineWithCenterPoint:linePoint orTipsPrice:closePrice].CGPath];
                [self configureStartDelegateAction];
                CGFloat beforeClosePrice = 0;
                if (touchPointIndex > 0) {
                    ZNStockKlineModel *beforeModel = self.KlineDataArray[touchPointIndex - 1];
                    beforeClosePrice = [[beforeModel close] floatValue];
                }
                
                [self configureKlineDelegateActionWithKlineModel:currentKlineModel beforeClosePrice:beforeClosePrice];
                
                [self configureMaxAndMinPriceIsShow:NO];
                //成交量显示图
                self.KlinePressVolumeLabel.hidden = NO;
                self.KlinePressMAPriceTipsLayer.hidden = NO;
                NSString *volumeStr = [NSString stringWithFormat:@"%@%@",[ZNStockBasedConfigureLib configureStockVolumeShowWithVolume:[currentKlineModel.volume floatValue]],[ZNStockBasedConfigureLib getStockVolumeUnitWithVolume:[currentKlineModel.volume floatValue]]];
                self.KlinePressVolumeLabel.string = volumeStr;
                
                CGSize closePriceSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinNormalFont(10) content:closePrice limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                
                CGRect closePricerect = CGRectMake(0, linePoint.y - closePriceSize.height/2, closePriceSize.width, closePriceSize.height);
                
                closePricerect.origin.x = self.isLandscape?(self.canvasLeft - closePriceSize.width - priceDistanceLine):(linePoint.x > self.canvasMidX?self.canvasLeft:self.canvasRight-closePriceSize.width);
                MyLog(@"长按价格的位置:%@",NSStringFromCGRect(closePricerect));
                if (!self.KlinePressClosePriceView.superview) {
                    [self addSubview:self.KlinePressClosePriceView];
                }
                self.KlinePressClosePriceView.frame = closePricerect;
                self.KlinePressClosePriceView.text = closePrice;
                
                if (linePoint.x > self.canvasMidX) {
                    if (!CGRectEqualToRect(self.KlinePressMAPriceTipsLayer.frame, self.KlineLongPressMALeftFrame)) {
                        self.KlinePressMAPriceTipsLayer.frame = self.KlineLongPressMALeftFrame;
                    }
                }else{
                    if (!CGRectEqualToRect(self.KlinePressMAPriceTipsLayer.frame, self.KlineLongPressMARightFrame)) {
                        self.KlinePressMAPriceTipsLayer.frame = self.KlineLongPressMARightFrame;
                    }
                }
                
                self.ma5PriceLabel.string = [@"MA5 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[currentKlineModel.ma5 floatValue]]];
                self.ma10PriceLabel.string = [@"MA10 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[currentKlineModel.ma10 floatValue]]];
                self.ma20PriceLabel.string = [@"MA20 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[currentKlineModel.ma20 floatValue]]];
                
            }
            
        }
        
        
        if (sender.state == UIGestureRecognizerStateChanged) {
            if (!CGPointEqualToPoint(touchPoint, _longPressStartPoint)) {
                MyLog(@"移动了%@",NSStringFromCGPoint(touchPoint));
                if (self.chartType == ZNChartTimeLine) {//分时
                    if (self.KTimeDataArray.count == 0) {
                        MyLog(@"咩有数据");
                        return;
                    }
                    if (touchPointIndex >= self.KTimeDataArray.count) {
                        touchPointIndex = self.KTimeDataArray.count - 1;
                    }
                    CGPoint linePoint = [self KTimePricePointLocationWithIndexInPoints:touchPointIndex];
                    [self.reticleLayer setPath:[self configureReticleLineWithCenterPoint:linePoint orTipsPrice:nil].CGPath];
                    [self.reticleCenterCircle setPath:[self configureCircleWithRadius:2.5 centerPoint:linePoint].CGPath];
                    ZNStockTimeSharingModel *model = self.KTimeDataArray[touchPointIndex];
                    [self configureKTimeDelegateActionWithTimeSharingModel:model];
                    //横屏显示数据
                    if (self.isLandscape) {
                        CGFloat rate = ([model.price floatValue]-self.YesterdayClosingPrice)/self.YesterdayClosingPrice*100;
                        NSString *rateStr =  [NSString stringWithFormat:@"%.2f%%",rate];
                        NSString *priceStr = model.price;
                        
                        CGSize rateSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinNormalFont(10) content:rateStr limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                        CGRect rateRect = CGRectMake(self.canvasRight + priceDistanceLine, linePoint.y - rateSize.height/2, rateSize.width, rateSize.height);
                        
                        CGSize priceSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinNormalFont(10) content:priceStr limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                        CGRect priceRect = CGRectMake(self.canvasLeft -  priceDistanceLine - priceSize.width, linePoint.y - priceSize.height/2, priceSize.width, priceSize.height);
                        self.KTimePressRateView.frame = rateRect;
                        self.KTimePressPriceView.frame = priceRect;
                        self.KTimePressPriceView.text = priceStr;
                        self.KTimePressRateView.text = rateStr;
                        
                    }
                    
                    
                    
                    
                }else{
                    if (self.KlineDataArray.count == 0) {
                        return;
                    }
                    
                    if (touchPointIndex >= self.KlineDataArray.count) {
                        touchPointIndex = self.KlineDataArray.count - 1;
                    }else{
                        touchPointIndex += self.KlineStartIndex;
                    }
                    
                    if (touchPointIndex >= self.KlineDataArray.count) {
                        touchPointIndex = self.KlineDataArray.count - 1;
                    }
                    CGPoint linePoint = [self KlineClosePricePointLocationWithIndexInPoints:touchPointIndex];
                    ZNStockKlineModel *currentKlineModel = self.KlineDataArray[touchPointIndex];
                    NSString *closePrice = [ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[currentKlineModel.close floatValue]];
                    [self.reticleLayer setPath:[self configureReticleLineWithCenterPoint:linePoint orTipsPrice:closePrice].CGPath];
                    CGFloat beforeClosePrice = 0;
                    if (touchPointIndex > 0) {
                        ZNStockKlineModel *beforeModel = self.KlineDataArray[touchPointIndex - 1];
                        beforeClosePrice = [beforeModel.close floatValue];
                    }
                    [self configureKlineDelegateActionWithKlineModel:currentKlineModel beforeClosePrice:beforeClosePrice];
                    NSString *volumeStr = [NSString stringWithFormat:@"%@%@",[ZNStockBasedConfigureLib configureStockVolumeShowWithVolume:[currentKlineModel.volume floatValue]],[ZNStockBasedConfigureLib getStockVolumeUnitWithVolume:[currentKlineModel.volume floatValue]]];
                    self.KlinePressVolumeLabel.string = volumeStr;
                    CGSize closePriceSize = [ZNStockBasedConfigureLib YukeToolGetFitSizeWithContentFont:ZNCustomDinNormalFont(10) content:closePrice limitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    CGRect closePricerect = CGRectMake(0, linePoint.y - closePriceSize.height/2, closePriceSize.width, closePriceSize.height);
                    closePricerect.origin.x = self.isLandscape?(self.canvasLeft - closePriceSize.width - priceDistanceLine):(linePoint.x > self.canvasMidX?self.canvasLeft:self.canvasRight-closePriceSize.width);
                    MyLog(@"长按价格的位置:%@",NSStringFromCGRect(closePricerect));
                    self.KlinePressClosePriceView.frame = closePricerect;
                    self.KlinePressClosePriceView.text = closePrice;
                    if (linePoint.x > self.canvasMidX) {
                        if (!CGRectEqualToRect(self.KlinePressMAPriceTipsLayer.frame, self.KlineLongPressMALeftFrame)) {
                            self.KlinePressMAPriceTipsLayer.frame = self.KlineLongPressMALeftFrame;
                        }
                    }else{
                        if (!CGRectEqualToRect(self.KlinePressMAPriceTipsLayer.frame, self.KlineLongPressMARightFrame)) {
                            self.KlinePressMAPriceTipsLayer.frame = self.KlineLongPressMARightFrame;
                        }
                    }
                    self.ma5PriceLabel.string = [@"MA5 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[currentKlineModel.ma5 floatValue]]];
                    self.ma10PriceLabel.string = [@"MA10 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[currentKlineModel.ma10 floatValue]]];
                    self.ma20PriceLabel.string = [@"MA20 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[currentKlineModel.ma20 floatValue]]];
                }
            }
        }
        
        if (sender.state == UIGestureRecognizerStateEnded) {
            MyLog(@"触摸结束%@",NSStringFromCGPoint(touchPoint));
            [self configureLongPressEndResetInfo];
        }
        
    }else{
        MyLog(@"没有在区域内");
        if (sender.state == UIGestureRecognizerStateEnded) {
            [self configureLongPressEndResetInfo];
        }
        
    }
    
}


- (void)configureLongPressEndResetInfo{
    _longPressStartPoint = CGPointZero;
    [self.reticleLayer setPath:[UIBezierPath bezierPath].CGPath];
    if (self.reticleCenterCircle.superlayer) {
        [self.reticleCenterCircle removeFromSuperlayer];
    }
    [self configureEndDelegateAction];
    [self configureMaxAndMinPriceIsShow:YES];
    self.KlinePressVolumeLabel.hidden = YES;
    if (self.chartType != ZNChartTimeLine) {
        if (self.isLandscape) {
            if (!CGRectEqualToRect(self.KlinePressMAPriceTipsLayer.frame, self.KlineLongPressMALeftFrame)) {
                self.KlinePressMAPriceTipsLayer.frame = self.KlineLongPressMALeftFrame;
            }
            ZNStockKlineModel *lastModel = [self.KlineDataArray lastObject];
            self.ma5PriceLabel.string = [@"MA5 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[lastModel.ma5 floatValue]]];
            self.ma10PriceLabel.string = [@"MA10 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[lastModel.ma10 floatValue]]];
            self.ma20PriceLabel.string = [@"MA20 " stringByAppendingString:[ZNStockBasedConfigureLib configureFloatStringWithOriginValue:[lastModel.ma20 floatValue]]];
            self.KlinePressMAPriceTipsLayer.hidden = NO;
        }else{
            self.KlinePressMAPriceTipsLayer.hidden = YES;
        }
    }
    if (self.KlinePressClosePriceView.superview) {
        [self.KlinePressClosePriceView removeFromSuperview];
    }
    
    if (self.KTimePressRateView.superview) {
        [self.KTimePressRateView removeFromSuperview];
    }
    
    if (self.KTimePressPriceView.superview) {
        [self.KTimePressPriceView removeFromSuperview];
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    
}


- (CGFloat)KlineVolumeUnitWidth{
    return self.canvasWidth/(self.isLandscape?100:60);
}

- (NSInteger)numberOfKlineCanShow{
    
    if (!self.isLandscape) {
        return (NSInteger )self.canvasWidth/self.KlineVolumeUnitWidth;
    }
    
    
    if (self.KlineLandscapeVolumeWidth == 0) {
        self.KlineLandscapeVolumeWidth = self.KlineVolumeUnitWidth;
    }
    

    return (NSInteger )self.canvasWidth/self.KlineLandscapeVolumeWidth;;
}


- (CGFloat)KlineFinalVolumeWidth{
    return self.isLandscape?self.KlineLandscapeVolumeWidth:self.KlineVolumeUnitWidth;
}


- (void)resetConfigureBcauseOfPanOrPinch{
    if (self.chartType == ZNChartTimeLine || !self.isLandscape) {
        MyLog(@"什么玩意,乱搞");
        _KlineMaxCount = 0;
        [self.KlineDataArray removeAllObjects];
        return;
    }
    
    
    
    self.minPrice = MAXFLOAT;
    self.maxPrice = 0;
    self.rate = 0;
    self.maxVolum = 0;
    [self.StockKTimeOrlinMainLayer removeFromSuperlayer];
    self.StockKTimeOrlinMainLayer = nil;
    
    self.StockKTimeOrlinMainLayer = [self configureBasedOrdinaryLayerWithFrame:self.layer.bounds];
    [self.layer addSublayer:self.StockKTimeOrlinMainLayer];
    [self setNeedsDisplay];
    
    //K线
    _KlineMaxCount = 0;
    self.KlinePressVolumeLabel = nil;
    self.KlinePressClosePriceView = nil;
    self.KTimePressPriceView = nil;
    self.KTimePressRateView = nil;
    
    self.isHaveAnimation = NO;
    
    _KlineMaxCount = self.KlineDataArray.count > (self.KlineStartIndex + self.numberOfKlineCanShow)?(self.KlineStartIndex + self.numberOfKlineCanShow):self.KlineDataArray.count;
    
    if (_KlineMaxCount < self.KlineDataArray.count) {
        _KlineMaxCount += 1;
    }
    
    
    
}


@end
