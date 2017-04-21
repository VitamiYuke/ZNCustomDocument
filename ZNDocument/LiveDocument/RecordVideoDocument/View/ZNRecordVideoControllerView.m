//
//  ZNRecordVideoControllerView.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/19.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNRecordVideoControllerView.h"
#import "ZNRecordVideoToolManager.h"
#import "ZNBasedToolManager.h"
@interface ZNRecordVideoControllerView ()<UIAlertViewDelegate>
@property(nonatomic, strong)UIButton *dismissBtn;
@property(nonatomic, strong)ZNRecordVideoToolManager *videoManager;
@property(nonatomic, strong)UIButton *changeCameraBtn;
@property(nonatomic, assign)BOOL isFrontCamera;
@property(nonatomic, strong)CAShapeLayer *outSideCirce;
@property(nonatomic, strong)CAShapeLayer *inSideCircle;
@property(nonatomic, strong)UILongPressGestureRecognizer *longPressGesture;
@property(nonatomic, strong)CAShapeLayer *theRingCircle;
@property(nonatomic, strong)UIAlertView *noAccessPermissionsAlert;
@property(nonatomic, strong)UILabel *tipsLabel;
@property(nonatomic, strong)UIButton *cancelBtn;
@property(nonatomic, strong)UIButton *commitBtn;
@end


@implementation ZNRecordVideoControllerView{
    CGRect _outSideCircleFrame;
    CGPoint _circleCenterPoint;
    double _maxRecordTime;
    CGFloat _hiddenX;
    CGFloat _cancelShowX;
    CGFloat _commitShowX;
}


- (UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
        _dismissBtn.titleLabel.font = MyFont(15);
        [_dismissBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UIButton *)changeCameraBtn{
    if (!_changeCameraBtn) {
        _changeCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeCameraBtn setImage:[UIImage imageNamed:@"transformTheCamera"] forState:UIControlStateNormal];
        [_changeCameraBtn addTarget:self action:@selector(changeCameraAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeCameraBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn.layer setMasksToBounds:YES];
        [_cancelBtn.layer setCornerRadius:75/2];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancelRecordedIcon"] forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(_hiddenX, SCREENT_HEIGHT - 75 - 50, 75, 75);
        _cancelBtn.hidden = YES;
        [_cancelBtn addTarget:self action:@selector(cancelTheRecordedVideoAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelBtn;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn.layer setMasksToBounds:YES];
        [_commitBtn.layer setCornerRadius:75/2];
        [_commitBtn setImage:[UIImage imageNamed:@"commitRecordedIcon"] forState:UIControlStateNormal];
        _commitBtn.frame = CGRectMake(_hiddenX, SCREENT_HEIGHT - 75 - 50, 75, 75);
        _commitBtn.hidden = YES;
        [_commitBtn addTarget:self action:@selector(commitTheRecordedVideoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"按住录像,最多可录制30秒";
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = MyFont(13);
    }
    return _tipsLabel;
}

- (ZNRecordVideoToolManager *)videoManager{
    if (!_videoManager) {
        _videoManager = [[ZNRecordVideoToolManager alloc] initWithPreviewLayerFrame:self.bounds];
    }
    return _videoManager;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configureData];
        [self configureUI];
        [self configureRecordUI];
        [self configureGesture];
    }
    return self;
}

- (void)configureUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    [self addSubview:self.dismissBtn];
    [self.dismissBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.dismissBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
    [self.dismissBtn autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    [self addSubview:self.changeCameraBtn];
    [self.changeCameraBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [self.changeCameraBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
    [self.changeCameraBtn autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    [self addSubview:self.tipsLabel];
    [self.tipsLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.tipsLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:155];
    
    
    [self addSubview:self.cancelBtn];
    [self addSubview:self.commitBtn];
    
}


- (void)configureData{
    self.isFrontCamera = NO;
    CGFloat normalOutSideRadiu = 75/2;
    _outSideCircleFrame = CGRectMake(SCREENT_WIDTH/2 - normalOutSideRadiu, SCREENT_HEIGHT - normalOutSideRadiu*2 - 50, normalOutSideRadiu*2, normalOutSideRadiu*2); //74 max 180/ 120  inside 80 60 / 52  40
    _circleCenterPoint = CGPointMake(_outSideCircleFrame.origin.x + normalOutSideRadiu, _outSideCircleFrame.origin.y + normalOutSideRadiu);
    _maxRecordTime = 30;
    _hiddenX = SCREENT_WIDTH/2 - 75/2;
    _cancelShowX = SCREENT_WIDTH/4 - 75/2;
    _commitShowX = SCREENT_WIDTH * 0.75 - 75/2;
    
    //配置录制设备
    [self.layer setMasksToBounds:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.layer insertSublayer:self.videoManager.previewLayer atIndex:0];
            [self.videoManager startRecordFunction];
        });
    });
    [self performSelector:@selector(judgeAccessPermissions) withObject:nil afterDelay:1];
    
}

- (void)dismissAction{
    UIViewController *showController = [ZNRegularHelp getCurrentShowViewController];
    if (showController) {
        [showController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}




- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    MyLog(@"录制界面销毁");
}


#pragma mark - 切换摄像头
- (void)changeCameraAction{
    if (![self.videoManager isAvailableWithCamera]) {
        MyLog(@"没有访问相机权限");
        return;
    }
    self.isFrontCamera = !self.isFrontCamera;
    if (![self.videoManager transformCameraDirectionWithIsFrontCamera:self.isFrontCamera]) {
        self.isFrontCamera = !self.isFrontCamera;
    };
}

#pragma mark - 配置录制的UI
- (void)configureRecordUI{
    [self.layer addSublayer:self.outSideCirce];
    [self.layer addSublayer:self.inSideCircle];
    [self.layer addSublayer:self.theRingCircle];
}


- (CAShapeLayer *)outSideCirce{
    if (!_outSideCirce) {
        _outSideCirce = [ZNBasedToolManager YukeToolGetShaperLayerWithFillColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5] strokeColor:[UIColor clearColor] lineWidth:0 path:[self normalOutSideCirclePath]];
    }
    return _outSideCirce;
}

- (CAShapeLayer *)inSideCircle{
    if (!_inSideCircle) {
        _inSideCircle = [ZNBasedToolManager YukeToolGetShaperLayerWithFillColor:[UIColor whiteColor] strokeColor:[UIColor clearColor] lineWidth:0 path:[self normalInSideCirclePath]];
    }
    return _inSideCircle;
}

- (CAShapeLayer *)theRingCircle{
    if (!_theRingCircle) {
        _theRingCircle = [ZNBasedToolManager YukeToolGetShaperLayerWithFillColor:[UIColor clearColor] strokeColor:MyColor(239, 106, 106) lineWidth:6 path:[self progressTheRingPath]];
        _theRingCircle.strokeEnd = 0;
    }
    return _theRingCircle;
}

//正常的外圆
- (UIBezierPath *)normalOutSideCirclePath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:_circleCenterPoint radius:75/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    return path;
}

- (UIBezierPath *)longPressOutSideCirclePath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:_circleCenterPoint radius:60 startAngle:0 endAngle:2*M_PI clockwise:YES];
    return path;
}

- (UIBezierPath *)normalInSideCirclePath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:_circleCenterPoint radius:55/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    return path;
}

- (UIBezierPath *)longPressInSideCirclePath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:_circleCenterPoint radius:20 startAngle:0 endAngle:2*M_PI clockwise:YES];
    return path;
}

//progressPath
- (UIBezierPath *)progressTheRingPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:_circleCenterPoint radius:57 startAngle:-M_PI_2 endAngle:3 * M_PI_2 clockwise:YES];
    return path;
}


//开始动画
-(void)startRecordingAnimation{
    if (![self.videoManager isAvailableWithCamera]) {
        MyLog(@"没有访问相机权限");
        return;
    }
    CABasicAnimation *outSideCircleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    outSideCircleAnimation.fromValue = (__bridge id)[self normalOutSideCirclePath].CGPath;
    outSideCircleAnimation.toValue = (__bridge id)[self longPressOutSideCirclePath].CGPath;
    outSideCircleAnimation.duration = 0.3;
    outSideCircleAnimation.removedOnCompletion = NO;
    outSideCircleAnimation.fillMode = kCAFillModeForwards;
    [self.outSideCirce addAnimation:outSideCircleAnimation forKey:@"outsidePath"];
    CABasicAnimation *inSideCircleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    inSideCircleAnimation.fromValue = (__bridge id)[self normalInSideCirclePath].CGPath;
    inSideCircleAnimation.toValue = (__bridge id)[self longPressInSideCirclePath].CGPath;
    inSideCircleAnimation.duration = 0.3;
    inSideCircleAnimation.removedOnCompletion = NO;
    inSideCircleAnimation.fillMode = kCAFillModeForwards;
    [self.inSideCircle addAnimation:inSideCircleAnimation forKey:@"insidePath"];
    [self performSelector:@selector(recordingProgressAnimation) withObject:nil afterDelay:0.3];
}

- (void)recordingProgressAnimation{
    if (![self.videoManager isAvailableWithCamera]) {
        MyLog(@"没有访问相机权限");
        return;
    }
    CABasicAnimation *progressAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressAnimation.fromValue = @0;
    progressAnimation.toValue = @1;
    progressAnimation.duration = _maxRecordTime;
    progressAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.theRingCircle addAnimation:progressAnimation forKey:@"progressAnimation"];
    [self performSelector:@selector(endRecordingAnimation) withObject:nil afterDelay:_maxRecordTime];
    //开始录制
    [self.videoManager startRecordVideo];
    if (!self.tipsLabel.hidden) {
        self.tipsLabel.hidden = YES;
    }
}


- (void)endRecordingAnimation{
    if (!self.tipsLabel.hidden) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endRecordingAnimation) object:nil];
    [self.theRingCircle removeAllAnimations];
    [self.outSideCirce removeAllAnimations];
    [self.inSideCircle removeAllAnimations];
    self.outSideCirce.hidden = YES;
    self.inSideCircle.hidden = YES;
    self.theRingCircle.hidden = YES;
    [self.outSideCirce setPath:[self normalOutSideCirclePath].CGPath];
    [self.inSideCircle setPath:[self normalInSideCirclePath].CGPath];
    [self.videoManager endRecordVideo];
    MyLog(@"录制结束啦啦啦啦🔚");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startOperationAnimation) object:nil];
    [self performSelector:@selector(startOperationAnimation) withObject:nil afterDelay:0.66];
}

//开始操作动画
- (void)startOperationAnimation{
    self.cancelBtn.hidden = NO;
    self.commitBtn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.cancelBtn.x = _cancelShowX;
        self.commitBtn.x = _commitShowX;
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    
}


//取消录制的视频使用
- (void)cancelTheRecordedVideoAction{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cancelBtn.x = _hiddenX;
        self.commitBtn.x = _hiddenX;
    } completion:^(BOOL finished) {
        if (finished) {
            self.cancelBtn.hidden = YES;
            self.commitBtn.hidden = YES;
            self.outSideCirce.hidden = NO;
            self.inSideCircle.hidden = NO;
            self.theRingCircle.hidden = NO;
            self.tipsLabel.hidden = NO;
        }
    }];
    
}

//确认使用的视频
- (void)commitTheRecordedVideoAction{
    [self.videoManager saveRecordVideoWithFileURL:self.videoManager.recordFileURL];
    [self dismissAction];
}


#pragma mark - 没有访问权限
- (UIAlertView *)noAccessPermissionsAlert{
    if (!_noAccessPermissionsAlert) {
        _noAccessPermissionsAlert = [[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的\"设置－隐私\"选项中，允许Yuke访问你的摄像头和麦克风。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    }
    return _noAccessPermissionsAlert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.noAccessPermissionsAlert) {
        [self dismissAction];
    }
}

- (void)judgeAccessPermissions{
    if (![self.videoManager isAvailableWithCamera] || ![self.videoManager isAvailableWithMic]) {
        [self.noAccessPermissionsAlert show];
    }
}

#pragma mark - 手势方法

- (void)configureGesture{
    [self addGestureRecognizer:self.longPressGesture];
}


- (UILongPressGestureRecognizer *)longPressGesture{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    }
    return _longPressGesture;
}



- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    
    
    if (self.outSideCirce.hidden) {
        MyLog(@"都没显示。弄啥咧");
        return;
    }
    

    if (sender.state == UIGestureRecognizerStateBegan) {
        MyLog(@"长安开始");
        CGPoint touchPoint = [sender locationInView:self];
        if (CGRectContainsPoint(_outSideCircleFrame, touchPoint)) {
            [self startRecordingAnimation];
        }
  
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        MyLog(@"长按结束");
        [self endRecordingAnimation];
    }
  
}
























@end
