//
//  ZNSkinCareCamera.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/17.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNSkinCareCamera.h"
#import "GPUImage.h"
#import "ZNSkinCareCameraToolManager.h"

@interface ZNSkinCareCamera ()<GPUImageVideoCameraDelegate,UIAlertViewDelegate>{
    
    CGRect _cameraFrame;
    //聚焦
    BOOL _canFocusAgain;
    CGPoint _focusPoint;
    NSInteger _currentFilterIndex;
}

@property(nonatomic, strong)ZNSkinCareCameraToolManager *toolManager;

@property(nonatomic, strong)GPUImageView *filterView;//相机
@property(nonatomic, strong)GPUImageVideoCamera *camera;
@property(nonatomic, strong)GPUImageMovieWriter *writer;
//滤镜
@property(nonatomic, strong)GPUImageOutput<GPUImageInput> *filter;

//
@property(nonatomic, strong)UIButton *dismissBtn;
@property(nonatomic, strong)UIAlertView *noAccessPermissionsAlert;

//聚焦
@property(nonatomic, strong)UITapGestureRecognizer *focusingGesture;
@property(nonatomic, strong)CAShapeLayer *focusingLayer;
//焦距
@property(nonatomic, strong)UIPinchGestureRecognizer *pinchGesture;
//切换摄像头
@property(nonatomic, strong)UITapGestureRecognizer *changeCameraGesture;

//滤镜
@property(nonatomic, strong)NSMutableArray *filtersArray;
//左右切换滤镜
@property(nonatomic, strong)UISwipeGestureRecognizer *leftSwipeGesture;
@property(nonatomic, strong)UISwipeGestureRecognizer *rightSwipeGesture;


@end




@implementation ZNSkinCareCamera

- (ZNSkinCareCameraToolManager *)toolManager{
    if (!_toolManager) {
        _toolManager = [[ZNSkinCareCameraToolManager alloc] init];
    }
    return _toolManager;
}

- (GPUImageView *)filterView{
    if (!_filterView) {
        _filterView = [[GPUImageView alloc] initWithFrame:self.bounds];
        [_filterView.layer addSublayer:self.focusingLayer];
        [_filterView addGestureRecognizer:self.focusingGesture];
        [_filterView addGestureRecognizer:self.pinchGesture];
        [_filterView addGestureRecognizer:self.changeCameraGesture];
        [_filterView addGestureRecognizer:self.leftSwipeGesture];
        [_filterView addGestureRecognizer:self.rightSwipeGesture];
    }
    return _filterView;
}

- (GPUImageVideoCamera *)camera{
    if (!_camera) {
        _camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        _camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _camera.horizontallyMirrorFrontFacingCamera = YES;
        _camera.horizontallyMirrorRearFacingCamera = NO;
        _camera.delegate = self;
    }
    return _camera;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configureData];
        [self configureUI];
    }
    return self;
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

- (void)dismissAction{
    UIViewController *showController = [ZNRegularHelp getCurrentShowViewController];
    if (showController) {
        [showController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}



- (void)configureUI{
    
    
    [self addSubview:self.filterView];
    
    [self.camera addTarget:self.filterView];
    [self.camera startCameraCapture];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    [self addSubview:self.dismissBtn];
    [self.dismissBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.dismissBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
    [self.dismissBtn autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    
}

- (void)configureData{
    _cameraFrame = self.bounds;
    _currentFilterIndex = -1;//无滤镜
    [self performSelector:@selector(judgeAccessPermissions) withObject:nil afterDelay:1];
}



#pragma mark - 输出的代理
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
//    MyLog(@"输出的结果:%@",sampleBuffer);
}


- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    MyLog(@"美颜销毁");
}


#pragma mark - 没有访问权限

- (void)judgeAccessPermissions{
    if (![ZNBasedToolManager YukeToolIsAvailableWithMic] || ![ZNBasedToolManager YukeToolIsAvailableWithCamera]) {
        [self.noAccessPermissionsAlert show];
    }else{
        [self configureFocusingWithPoint:CGPointMake(SCREENT_WIDTH/2, SCREENT_HEIGHT/2)];
    }
}

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

#pragma mark - 聚焦处理

- (CAShapeLayer *)focusingLayer{
    if (!_focusingLayer) {
        _focusingLayer = [ZNBasedToolManager YukeToolGetShaperLayerWithFillColor:[UIColor clearColor] strokeColor:MyColor(239, 106, 106) lineWidth:1 path:[UIBezierPath bezierPath]];
    }
    return _focusingLayer;
}

- (UITapGestureRecognizer *)focusingGesture{
    if (!_focusingGesture) {
        _focusingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusingAction:)];
    }
    return _focusingGesture;
}

- (void)focusingAction:(UITapGestureRecognizer *)sender{
    
//    if (self.outSideCirce.hidden) {
//        MyLog(@"都没显示。弄啥咧");
//        return;
//    }
    CGPoint touchPoint = [sender locationInView:self.filterView];
    MyLog(@"点击的位置:%@",NSStringFromCGPoint(touchPoint));
    
    if (!_canFocusAgain) {
        MyLog(@"刚刚聚焦 别瞎弄");
        return;
    }
    
    [self configureFocusingWithPoint:touchPoint];
    
}

- (void)configureFocusingWithPoint:(CGPoint )point{
    

    CAShapeLayer *focusLayer = self.focusingLayer;
    if (focusLayer) {
        _canFocusAgain = NO;
        _focusPoint = point;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        CABasicAnimation *focusAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        focusAnimation.fromValue = (__bridge id)[self getFocusingCircleWithRadius:50 centerPoint:_focusPoint].CGPath;
        focusAnimation.toValue = (__bridge id)[self getFocusingCircleWithRadius:15 centerPoint:_focusPoint].CGPath;
        focusAnimation.duration = 0.15;
        focusAnimation.removedOnCompletion = NO;
        focusAnimation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation:focusAnimation forKey:@"focusAnimation"];
        //转换点坐标为0-1
        CGPoint convertPoint = CGPointMake(point.x/_cameraFrame.size.width, point.y/_cameraFrame.size.height);
        MyLog(@"转换之后的坐标:%@",NSStringFromCGPoint(convertPoint));
        [self.toolManager confgiureCameraFocusPointWithPoint:convertPoint inputDevice:self.camera.inputCamera];
        [self performSelector:@selector(backAnimation:) withObject:focusLayer afterDelay:0.15];
        [self performSelector:@selector(focusLayerFade:) withObject:focusLayer afterDelay:2.2];
        
    }
}





- (void)backAnimation:(id )sender{
    if (sender && [sender isKindOfClass:[CAShapeLayer class]]) {
        CAShapeLayer *focusLayer = (CAShapeLayer *)sender;
        
        CABasicAnimation *backAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        backAnimation.fromValue = (__bridge id)[self getFocusingCircleWithRadius:15 centerPoint:_focusPoint].CGPath;
        backAnimation.toValue = (__bridge id)[self getFocusingCircleWithRadius:25 centerPoint:_focusPoint].CGPath;
        backAnimation.duration = 0.2;
        backAnimation.removedOnCompletion = NO;
        backAnimation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation:backAnimation forKey:@"backAnimation"];
    }
}

- (void)focusLayerFade:(id )sender{
    if (sender && [sender isKindOfClass:[CAShapeLayer class]]) {
        CAShapeLayer *focusLayer = (CAShapeLayer *)sender;
        [focusLayer removeAllAnimations];
        [focusLayer setPath:[UIBezierPath bezierPath].CGPath];
    }
    _canFocusAgain = YES;
}

- (UIBezierPath *)getFocusingCircleWithRadius:(CGFloat )radius centerPoint:(CGPoint )centerPoint{
    return [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
}

#pragma mark - 设置焦距
- (UIPinchGestureRecognizer *)pinchGesture{
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(configureFocusLength:)];
    }
    return _pinchGesture;
}

- (void)configureFocusLength:(UIPinchGestureRecognizer *)sender{
    
//    if (self.outSideCirce.hidden) {
//        MyLog(@"都没显示。弄啥咧");
//        return;
//    }
    MyLog(@"缩放倍数:%.2f",sender.scale);
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        [self.toolManager configureCameraFocusingLengthWithScale:sender.scale inputDevice:self.camera.inputCamera];
    }
    
    sender.scale = 1;
}
#pragma mark - 切换摄像头
- (UITapGestureRecognizer *)changeCameraGesture{
    if (!_changeCameraGesture) {
        _changeCameraGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCameraAction)];
        _changeCameraGesture.numberOfTapsRequired = 2;
    }
    return _changeCameraGesture;
}

- (void)changeCameraAction{
    [self.camera rotateCamera];
    [self configureFocusingWithPoint:CGPointMake(SCREENT_WIDTH/2, SCREENT_HEIGHT/2)];
}

#pragma mark - 滤镜切换

- (NSMutableArray *)filtersArray{
    if (!_filtersArray) {
        _filtersArray = [NSMutableArray array];
        
        GPUImagePixellateFilter *filter1 = [[GPUImagePixellateFilter alloc] init];
//        filter1.fractionalWidthOfAPixel = 100;
        NSDictionary *dic1 = [self configureFilterWithFilter:filter1 filterName:@"全图马赛克"];
        
        GPUImagePixellatePositionFilter *filter2 = [[GPUImagePixellatePositionFilter alloc] init];
//        filter2.fractionalWidthOfAPixel = 200;
        filter2.center = CGPointMake(0.2, 0.6);
        filter2.radius = 0.5;
        NSDictionary *dic2 = [self configureFilterWithFilter:filter2 filterName:@"局部马赛克"];
        GPUImageFilter *filter3 = [[GPUImageSepiaFilter alloc] init];
        NSDictionary *dic3 = [self configureFilterWithFilter:filter3 filterName:@"褐色怀旧风"];
        
        GPUImageFilter *filter4 = [[GPUImageColorInvertFilter alloc] init];
        NSDictionary *dic4 = [self configureFilterWithFilter:filter4 filterName:@"胶片"];
        
        GPUImageSaturationFilter *filter5 = [[GPUImageSaturationFilter alloc] init];
        filter5.saturation = 1.8;
        NSDictionary *dic5 = [self configureFilterWithFilter:filter5 filterName:@"饱和度处理"];
        
        GPUImageContrastFilter *filter6 = [[GPUImageContrastFilter alloc] init];
        filter6.contrast = 3.6;
        NSDictionary *dic6 = [self configureFilterWithFilter:filter6 filterName:@"对比度处理"];
        
        GPUImageExposureFilter *filter7 = [[GPUImageExposureFilter alloc] init];
        filter7.exposure = -1;
        NSDictionary *dic7 = [self configureFilterWithFilter:filter7 filterName:@"曝光度处理"];
        
        GPUImageBrightnessFilter *filter8 = [[GPUImageBrightnessFilter alloc] init];
        filter8.brightness = 0.3;
        NSDictionary *dic8 = [self configureFilterWithFilter:filter8 filterName:@"亮度处理"];
        
        GPUImageFilter *filter9 = [[GPUImageLevelsFilter alloc] init];
        NSDictionary *dic9 = [self configureFilterWithFilter:filter9 filterName:@"水平度处理"];
        
        GPUImageSharpenFilter *filter10 = [[GPUImageSharpenFilter alloc] init];
        filter10.sharpness = 1.0;
        NSDictionary *dic10 = [self configureFilterWithFilter:filter10 filterName:@"锐化处理"];
        
        //第二波
        GPUImageGammaFilter *filter11 = [[GPUImageGammaFilter alloc] init];
        filter11.gamma = 1.6;
        NSDictionary *dic11 = [self configureFilterWithFilter:filter11 filterName:@"Gamma线"];
        
        GPUImageFilter *filter12 = [[GPUImageSobelEdgeDetectionFilter alloc] init];
        NSDictionary *dic12 = [self configureFilterWithFilter:filter12 filterName:@"Sobel边缘检测"];
        
        
        GPUImageFilter *filter13 = [[GPUImageSketchFilter alloc] init];
        NSDictionary *dic13 = [self configureFilterWithFilter:filter13 filterName:@"素描"];//perfect
        
        
        GPUImageFilter *filter14 = [[GPUImageToonFilter alloc] init];
        NSDictionary *dic14 = [self configureFilterWithFilter:filter14 filterName:@"Toon"];
        
        GPUImageSmoothToonFilter *filter15 = [[GPUImageSmoothToonFilter alloc] init];
        NSDictionary *dic15 = [self configureFilterWithFilter:filter15 filterName:@"光滑的卡通"];
        
        GPUImageFilter *filter16 = [[GPUImageMultiplyBlendFilter alloc] init];
        NSDictionary *dic16 = [self configureFilterWithFilter:filter16 filterName:@"用混合"];
        
        GPUImageDissolveBlendFilter *filter17 = [[GPUImageDissolveBlendFilter alloc] init];
        filter17.mix = 0.8;
        NSDictionary *dic17 = [self configureFilterWithFilter:filter17 filterName:@"溶解混合"];
        
        GPUImageFilter *filter18 = [[GPUImageKuwaharaFilter alloc] init];
        NSDictionary *dic18 = [self configureFilterWithFilter:filter18 filterName:@"文字模糊"];
        
        GPUImageFilter *filter19 = [[GPUImageKuwaharaRadius3Filter alloc] init];
        NSDictionary *dic19 = [self configureFilterWithFilter:filter19 filterName:@"文字模糊"];
        
        
        GPUImageFilter *filter20 = [[GPUImageVignetteFilter alloc] init];
        NSDictionary *dic20 = [self configureFilterWithFilter:filter20 filterName:@"周围环黑"];//perfect
        
        
        
        //第三波
        GPUImageGaussianBlurFilter *filter21 = [[GPUImageGaussianBlurFilter alloc] init];
        NSDictionary *dic21 = [self configureFilterWithFilter:filter21 filterName:@"Gamma线"];
        
        GPUImageFilter *filter22 = [[GPUImageGaussianBlurPositionFilter alloc] init];
        NSDictionary *dic22 = [self configureFilterWithFilter:filter22 filterName:@"Sobel边缘检测"];
        
        
        GPUImageOutput <GPUImageInput> *filter23 = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
        NSDictionary *dic23 = [self configureFilterWithFilter:filter23 filterName:@"素描"];
        
        
        GPUImageFilter *filter24 = [[GPUImageOverlayBlendFilter alloc] init];
        NSDictionary *dic24 = [self configureFilterWithFilter:filter24 filterName:@"Toon"];
        
        GPUImageDarkenBlendFilter *filter25 = [[GPUImageDarkenBlendFilter alloc] init];
        NSDictionary *dic25 = [self configureFilterWithFilter:filter25 filterName:@"光滑的卡通"];
        
        GPUImageLightenBlendFilter *filter26 = [[GPUImageLightenBlendFilter alloc] init];
        NSDictionary *dic26 = [self configureFilterWithFilter:filter26 filterName:@"减轻混合"];
        
        GPUImageSwirlFilter *filter27 = [[GPUImageSwirlFilter alloc] init];
        filter17.mix = 0.8;
        NSDictionary *dic27 = [self configureFilterWithFilter:filter27 filterName:@"漩涡"];
        
        GPUImageFilter *filter28 = [[GPUImageSourceOverBlendFilter alloc] init];
        NSDictionary *dic28 = [self configureFilterWithFilter:filter28 filterName:@"文字模糊"];
        
        GPUImageFilter *filter29 = [[GPUImageColorBurnBlendFilter alloc] init];
        NSDictionary *dic29 = [self configureFilterWithFilter:filter29 filterName:@"文字模糊"];
        
        
        GPUImageFilter *filter30 = [[GPUImageColorDodgeBlendFilter alloc] init];
        NSDictionary *dic30 = [self configureFilterWithFilter:filter30 filterName:@"周围环黑"];
        
        [_filtersArray addObjectsFromArray:@[dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8,dic9,dic10,
                                             dic11,dic12,dic13,dic14,dic15,dic16,dic17,dic18,dic19,dic20,
                                             dic21,dic22,dic23,dic24,dic25,dic26,dic27,dic28,dic29,dic30
                                             ]];
    }
    return _filtersArray;
}


- (NSDictionary *)configureFilterWithFilter:(GPUImageOutput <GPUImageInput> *)filter filterName:(NSString *)name{
    return @{@"filter":filter,@"name":name};
}

- (UISwipeGestureRecognizer *)leftSwipeGesture{
    if (!_leftSwipeGesture) {
        _leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        _leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _leftSwipeGesture;
}

- (UISwipeGestureRecognizer *)rightSwipeGesture{
    if (!_rightSwipeGesture) {
        _rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        _rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return _rightSwipeGesture;
}

- (void)swipeAction:(UISwipeGestureRecognizer *)sender{
    
    
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        MyLog(@"向左划");
        
        
        _currentFilterIndex++;
        
        if (_currentFilterIndex > self.filtersArray.count - 1) {
            _currentFilterIndex = -1;
        }
        MyLog(@"当前第%ld个滤镜",_currentFilterIndex+1);
        if (_currentFilterIndex == -1) {
            [self changeFilterWithFilter:nil];
            return;
        }
        MyLog(@"当前第%ld个滤镜",_currentFilterIndex+1);
        NSDictionary *filterDic = self.filtersArray[_currentFilterIndex];
        GPUImageFilter *filter = filterDic[@"filter"];
        if (filter) {
            [self changeFilterWithFilter:filter];
        }

        
        
    }
    
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
         MyLog(@"向右划");
        
        _currentFilterIndex--;
        MyLog(@"当前第%ld个滤镜",_currentFilterIndex+1);
        
        if (_currentFilterIndex == -1) {
            [self changeFilterWithFilter:nil];
            return;
        }
        
        if (_currentFilterIndex == -2) {
            _currentFilterIndex = self.filtersArray.count - 1;
        }
        
        NSDictionary *filterDic = self.filtersArray[_currentFilterIndex];
        GPUImageFilter *filter = filterDic[@"filter"];
        if (filter) {
            [self changeFilterWithFilter:filter];
        }

    }
    
    
}

//切换
- (void)changeFilterWithFilter:(GPUImageFilter *)filter{
    
    if (self.filter == filter) {
        MyLog(@"一样的滤镜");
        return;
    }
    self.filter = filter;
    [self.camera removeAllTargets];
    if (self.filter) {
        [self.camera addTarget:self.filter];
        [self.filter addTarget:self.filterView];
    }else{
        [self.camera addTarget:self.filterView];
    }
}


@end
