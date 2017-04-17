//
//  ZNPlayerController.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/16.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNPlayerController.h"
#import "MMMaterialDesignSpinner.h"//缓冲的菊花
#import "ASValueTrackingSlider.h"//控制杆

#import "ZFPlayer.h"

static const CGFloat ZNPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat ZNPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface ZNPlayerController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView                  *topBarView;
/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 视频播放时间的label  **/
@property (nonatomic, strong) UILabel                 *playTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton                *lockBtn;
/** 系统菊花 */
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton                *closeBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView             *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 缓存按钮 */
@property (nonatomic, strong) UIButton                *downLoadBtn;
/** 切换分辨率按钮 */
@property (nonatomic, strong) UIButton                *resolutionBtn;
/** 分辨率的View */
@property (nonatomic, strong) UIView                  *resolutionView;
/** 播放按钮 */
@property (nonatomic, strong) UIButton                *playeBtn;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *failBtn;
/** 快进快退View*/
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress*/
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间*/
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView*/
@property (nonatomic, strong) UIImageView             *fastImageView;
/** 当前选中的分辨率btn按钮 */
@property (nonatomic, weak  ) UIButton                *resoultionCurrentBtn;
/** 占位图 */
@property (nonatomic, strong) UIImageView             *placeholderImageView;
/** 控制层消失时候在底部显示的播放进度progress */
@property (nonatomic, strong) UIProgressView          *bottomProgressView;
/** 播放模型 */
@property (nonatomic, strong) ZNPlayItem           *playerModel;
/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 小屏播放 */
@property (nonatomic, assign, getter=isShrink ) BOOL  shrink;
/** 在cell上播放 */
@property (nonatomic, assign, getter=isCellVideo)BOOL cellVideo;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 是否全屏播放 */
@property (nonatomic, assign,getter=isFullScreen)BOOL fullScreen;
/** 分辨率的名称 */
@property (nonatomic, strong) NSArray               *resolutionArray;

@end

@implementation ZNPlayerController


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)configureUI
{
    [self addSubview:self.placeholderImageView];
    
    //控制器
    [self addSubview:self.topBarView];
    [self addSubview:self.topImageView];
    [self addSubview:self.bottomImageView];
    
    //刷新的菊花
    [self addSubview:self.activity];
    //加载失败 重播 开始播放 锁
    [self addSubview:self.lockBtn];
    [self addSubview:self.repeatBtn];
    [self addSubview:self.failBtn];
    [self addSubview:self.playeBtn];
    //快进
    [self addSubview:self.fastView];
    
    // 添加子控件的约束
    [self configureSubViewsConstraints];
    
    self.downLoadBtn.hidden     = YES;
    self.resolutionBtn.hidden   = YES;
    // 初始化时重置controlView
    [self zn_playerResetControlView];
    // app退到后台
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self listeningRotating];
    [self onDeviceOrientationChange];
}

#pragma mark - 添加控件约束
- (void)configureSubViewsConstraints
{
    //占位图
    [self.placeholderImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //导航条
    [self.topBarView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.topBarView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.topBarView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.topBarView autoSetDimension:ALDimensionHeight toSize:20];
    
    //顶部控制
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.topImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topBarView withOffset:0];
    [self.topImageView autoSetDimension:ALDimensionHeight toSize:44];
    
    //底部控件
    [self.bottomImageView autoSetDimension:ALDimensionHeight toSize:44];
    [self.bottomImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.bottomImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.bottomImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    //菊花
    [self.activity autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.activity autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.activity autoSetDimension:ALDimensionHeight toSize:26];
    [self.activity autoSetDimension:ALDimensionWidth toSize:26];
    
    //重播 加载失败 锁
    [self.repeatBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.repeatBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.failBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.failBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.failBtn autoSetDimension:ALDimensionWidth toSize:130];
    [self.failBtn autoSetDimension:ALDimensionHeight toSize:33];
    
    [self.playeBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.playeBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.lockBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.lockBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.lockBtn autoSetDimension:ALDimensionHeight toSize:30];
    [self.lockBtn autoSetDimension:ALDimensionWidth toSize:30];
    
    //快进
    [self.fastView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.fastView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.fastView autoSetDimension:ALDimensionWidth toSize:125];
    [self.fastView autoSetDimension:ALDimensionHeight toSize:80];
    
}

#pragma mark -- 实例化
- (UIView *)topBarView
{
    if (!_topBarView) {
        _topBarView = [[UIView alloc] init];
        _topBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _topBarView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.text = @"这个很6666";
    }
    return _titleLabel;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        
        [_topImageView addSubview:self.backBtn];
        [self.backBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.backBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7];
        [self.backBtn autoSetDimension:ALDimensionWidth toSize:26];
        [self.backBtn autoSetDimension:ALDimensionHeight toSize:26];
        
        [_topImageView addSubview:self.titleLabel];
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.backBtn withOffset:5];
        [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.backBtn];
        
    }
    return _topImageView;
}



#pragma mark - 时间进度条
- (UILabel *)playTimeLabel
{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.textColor = [UIColor whiteColor];
        _playTimeLabel.font = [UIFont systemFontOfSize:13];
        _playTimeLabel.text = @"00:00/00:00";
    }
    return _playTimeLabel;
}

//全屏
- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"zb_xqy_quanping"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"zb_xqy_xiaoping"]forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}
//缓存的进度条
- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}
//拖动杆
- (ASValueTrackingSlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
        _videoSlider.popUpViewArrowLength = 8;
        
        [_videoSlider setThumbImage:ZFPlayerImage(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];
        
//        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
//        panRecognizer.delegate = self;
//        [panRecognizer setMaximumNumberOfTouches:1];
//        [panRecognizer setDelaysTouchesBegan:YES];
//        [panRecognizer setDelaysTouchesEnded:YES];
//        [panRecognizer setCancelsTouchesInView:YES];
//        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
}
//播放按钮
- (UIButton *)playeBtn
{
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playeBtn setImage:ZFPlayerImage(@"ZFPlayer_play_btn") forState:UIControlStateNormal];
        [_playeBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playeBtn;
}
//加载失败按钮
- (UIButton *)failBtn
{
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failBtn;
}
//暂停开始
- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage imageNamed:@"zb_xqy_bofang"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"zb_xqy_zanting"] forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}
//底部的
- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
        [self configureBottomUI];
        
    }
    return _bottomImageView;
}

- (void)configureBottomUI
{
    [self.bottomImageView addSubview:self.startBtn];
    [self.bottomImageView addSubview:self.playTimeLabel];
    [self.bottomImageView addSubview:self.progressView];
    [self.bottomImageView addSubview:self.videoSlider];
    [self.bottomImageView addSubview:self.fullScreenBtn];
    
    
    
    //开始暂停
    [self.startBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.startBtn autoSetDimension:ALDimensionWidth toSize:25];
    [self.startBtn autoSetDimension:ALDimensionHeight toSize:25];
    [self.startBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //全屏
    [self.fullScreenBtn autoSetDimension:ALDimensionHeight toSize:25];
    [self.fullScreenBtn autoSetDimension:ALDimensionWidth toSize:25];
    [self.fullScreenBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [self.fullScreenBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //时间
    [self.playTimeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.playTimeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.fullScreenBtn withOffset:-15];
    
    //缓冲条
    [self.progressView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.progressView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.startBtn withOffset:15];
    [self.progressView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.playTimeLabel withOffset:-15];
   
    // 控制感
//    [self.videoSlider autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.videoSlider autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.progressView withOffset:-1];
    [self.videoSlider autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.startBtn withOffset:15];
    [self.videoSlider autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.playTimeLabel withOffset:-15];
    [self.videoSlider autoSetDimension:ALDimensionHeight toSize:30];
    
    
}

//刷新的菊花
- (MMMaterialDesignSpinner *)activity
{
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.tintColor = [UIColor whiteColor];
    }
    return _activity;
}
//重播的按钮
- (UIButton *)repeatBtn
{
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:ZFPlayerImage(@"ZFPlayer_repeat_video") forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatBtn;
}


//锁屏的按钮
- (UIButton *)lockBtn
{
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:ZFPlayerImage(@"ZFPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:ZFPlayerImage(@"ZFPlayer_lock-nor") forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockScrrenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lockBtn;
}

//占位图
- (UIImageView *)placeholderImageView
{
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.userInteractionEnabled = YES;
        _placeholderImageView.backgroundColor = [UIColor greenColor];
    }
    return _placeholderImageView;
}
#pragma mark - 快进的
- (UIView *)fastView
{
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = RGBA(0, 0, 0, 0.8);
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
        [self configureFastViewUI];
    }
    return _fastView;
}

- (UIImageView *)fastImageView
{
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel
{
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView
{
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor whiteColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}

//快进的孩子布局
- (void)configureFastViewUI
{
    [self.fastView addSubview:self.fastImageView];
    [self.fastView addSubview:self.fastTimeLabel];
    [self.fastView addSubview:self.fastProgressView];
    
    //快进的图标
    [self.fastImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [self.fastImageView autoSetDimension:ALDimensionHeight toSize:32];
    [self.fastImageView autoSetDimension:ALDimensionWidth toSize:32];
    [self.fastImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    //时间
    [self.fastTimeLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.fastTimeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.fastImageView withOffset:2];
    
    //进度条
    [self.fastProgressView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.fastTimeLabel withOffset:10];
    [self.fastProgressView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
    [self.fastProgressView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12];
    
    
}

#pragma mark - Private Method

- (void)showControlView
{
    self.topImageView.alpha       = 1;
    self.topBarView.alpha         = 1;
    self.bottomImageView.alpha    = 1;
    self.lockBtn.alpha            = 1;
    self.shrink                   = NO;
    self.bottomProgressView.alpha = 0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)hideControlView
{
    self.topImageView.alpha       = self.playeEnd;
    self.topBarView.alpha         = 0;
    self.bottomImageView.alpha    = 0;
    self.lockBtn.alpha            = 0;
    self.bottomProgressView.alpha = 1;
    // 隐藏resolutionView
    self.resolutionBtn.selected = YES;
    [self resolutionBtnClick:self.resolutionBtn];
    if (self.isFullScreen && !self.playeEnd) { [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade]; }
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

//添加自动消失的方法
- (void)autoFadeOutControlView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(zn_playerHideControlView) object:nil];
    [self performSelector:@selector(zn_playerHideControlView) withObject:nil afterDelay:ZNPlayerAnimationTimeInterval];
}

/**
 slider滑块的bounds
 */
- (CGRect)thumbRect
{
    return [self.videoSlider thumbRectForBounds:self.videoSlider.bounds
                                      trackRect:[self.videoSlider trackRectForBounds:self.videoSlider.bounds]
                                          value:self.videoSlider.value];
}

#pragma mark - 重新设置
/** 重置ControlView */
- (void)zn_playerResetControlView
{
    [self.activity stopAnimating];
    self.videoSlider.value           = 0;
    self.bottomProgressView.progress = 0;
    self.progressView.progress       = 0;
    self.playTimeLabel.text = @"00:00/00:00";
    self.fastView.hidden             = YES;
    self.repeatBtn.hidden            = YES;
    self.playeBtn.hidden             = YES;
    self.resolutionView.hidden       = YES;
    self.failBtn.hidden              = YES;
    self.backgroundColor             = [UIColor clearColor];
    self.downLoadBtn.enabled         = YES;
    self.shrink                      = NO;
    self.showing                     = NO;
    self.playeEnd                    = NO;
    self.lockBtn.hidden              = YES;
    self.failBtn.hidden              = YES;
    self.placeholderImageView.alpha  = 1;
}
/** 重置分辨率 */
- (void)zn_playerResetControlViewForResolution
{
    self.fastView.hidden        = YES;
    self.repeatBtn.hidden       = YES;
    self.resolutionView.hidden  = YES;
    self.playeBtn.hidden        = YES;
    self.downLoadBtn.enabled    = YES;
    self.failBtn.hidden         = YES;
    self.backgroundColor        = [UIColor clearColor];
    self.shrink                 = NO;
    self.showing                = NO;
    self.playeEnd               = NO;
}

#pragma mark - 方法的实现
/**
 *  取消延时隐藏controlView的方法
 */
- (void)zn_playerCancelAutoFadeOutControlView
{
    self.showing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/** 设置播放模型 */
- (void)zn_playerModel:(ZNPlayItem *)playerModel
{
    _playerModel = playerModel;
    if (playerModel.title) { self.titleLabel.text = playerModel.title; }
    // 设置网络占位图片
    if (playerModel.placeholderImageURLString) {
        [self.placeholderImageView setImageWithURLString:playerModel.placeholderImageURLString placeholder:ZFPlayerImage(@"ZFPlayer_loading_bgView")];
    } else {
        self.placeholderImageView.image = playerModel.placeholderImage;
    }
//    if (playerModel.resolutionDic) {
//        [self zf_playerResolutionArray:[playerModel.resolutionDic allKeys]];
//    }
}

/**
 是否有切换分辨率功能
 */
- (void)zn_playerResolutionArray:(NSArray *)resolutionArray
{
    self.resolutionBtn.hidden = NO;
    
    _resolutionArray = resolutionArray;
    [_resolutionBtn setTitle:resolutionArray.firstObject forState:UIControlStateNormal];
    // 添加分辨率按钮和分辨率下拉列表
    self.resolutionView = [[UIView alloc] init];
    self.resolutionView.hidden = YES;
    self.resolutionView.backgroundColor = RGBA(0, 0, 0, 0.7);
    [self addSubview:self.resolutionView];
    
    [self.resolutionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25*resolutionArray.count);
        make.leading.equalTo(self.resolutionBtn.mas_leading).offset(0);
        make.top.equalTo(self.resolutionBtn.mas_bottom).offset(0);
    }];
    
    // 分辨率View上边的Btn
    for (NSInteger i = 0 ; i < resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.tag = 200+i;
        btn.frame = CGRectMake(0, 25*i, 40, 25);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:resolutionArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            self.resoultionCurrentBtn = btn;
            btn.selected = YES;
            btn.backgroundColor = RGBA(86, 143, 232, 1);
        }
        [self.resolutionView addSubview:btn];
//        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/** 正在播放（隐藏placeholderImageView） */
- (void)zn_playerItemPlaying
{
    [UIView animateWithDuration:1.0 animations:^{
        self.placeholderImageView.alpha = 0;
    }];
}
/**
 *  显示控制层
 */
- (void)zn_playerShowControlView
{
    if (self.isShowing) {
        [self zn_playerHideControlView];
        return;
    }
    [self zn_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZNPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];
    }];
    
}

/**
 *  隐藏控制层
 */
- (void)zn_playerHideControlView
{
    if (!self.isShowing) { return; }
    [self zn_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZNPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    }completion:^(BOOL finished) {
        self.showing = NO;
    }];
}
/** 小屏播放 */
- (void)zn_playerBottomShrinkPlay
{
    [self updateConstraints];
    [self layoutIfNeeded];
    [self hideControlView];
    self.shrink = YES;
}

/** 在cell播放 */
- (void)zn_playerCellPlay
{
    self.cellVideo = YES;
    self.shrink    = YES;
    [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];
    [self layoutIfNeeded];
    [self zn_playerShowControlView];
}

- (void)zn_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value
{
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeText = @"00:00";
    NSString *totalTimeText = @"00:00";
    
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        currentTimeText       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
    // 更新总时间
    totalTimeText = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    
    self.playTimeLabel.text = [NSString stringWithFormat:@"%@/%@",currentTimeText,totalTimeText];
    
    
}

- (void)zn_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview
{
    // 快进快退时候停止菊花
    [self.activity stopAnimating];
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 显示、隐藏预览窗
    self.videoSlider.popUpView.hidden = !preview;
    // 更新slider的值
    self.videoSlider.value            = draggedValue;
    // 更新bottomProgressView的值
    self.bottomProgressView.progress  = draggedValue;
    // 更新当前时间
    self.playTimeLabel.text = [NSString stringWithFormat:@"%@/%@",currentTimeStr,totalTimeStr];
    // 正在拖动控制播放进度
    self.dragged = YES;
    
    if (forawrd) {
        self.fastImageView.image = ZFPlayerImage(@"ZFPlayer_fast_forward");
    } else {
        self.fastImageView.image = ZFPlayerImage(@"ZFPlayer_fast_backward");
    }
    self.fastView.hidden           = preview;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;
    
}

- (void)zn_playerDraggedEnd
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.startBtn.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutControlView];
}

- (void)zn_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image;
{
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    [self.videoSlider setImage:image];
    [self.videoSlider setText:currentTimeStr];
    self.fastView.hidden = YES;
}

/** progress显示缓冲进度 */
- (void)zn_playerSetProgress:(CGFloat)progress
{
    [self.progressView setProgress:progress animated:NO];
}

/** 视频加载失败 */
- (void)zn_playerItemStatusFailed:(NSError *)error
{
    self.failBtn.hidden = NO;
}

/** 加载的菊花 */
- (void)zn_playerActivity:(BOOL)animated
{
    if (animated) {
        [self.activity startAnimating];
        self.fastView.hidden = YES;
    } else {
        [self.activity stopAnimating];
    }
}

/** 播放完了 */
- (void)zn_playerPlayEnd
{
    self.backgroundColor  = RGBA(0, 0, 0, .6);
    self.repeatBtn.hidden = NO;
    self.playeEnd         = YES;
    self.showing          = NO;
    // 延迟隐藏controlView
    [self hideControlView];
}

/**
 是否有下载功能
 */
- (void)zn_playerHasDownloadFunction:(BOOL)sender
{
    self.downLoadBtn.hidden = !sender;
}


/** 播放按钮状态 */
- (void)zn_playerPlayBtnState:(BOOL)state
{
    self.startBtn.selected = state;
}

/** 锁定屏幕方向按钮状态 */
- (void)zn_playerLockBtnState:(BOOL)state
{
    self.lockBtn.selected = state;
}

/** 下载按钮状态 */
- (void)zn_playerDownloadBtnState:(BOOL)state
{
    self.downLoadBtn.enabled = state;
}



/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint
{
    self.fullScreen             = NO;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    if (self.isCellVideo) {
        [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
}
/**
 *  设置横屏的约束
 */

- (void)setOrientationLandscapeConstraint
{
    self.shrink                 = NO;
    self.fullScreen             = YES;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];
//    [self.topBarView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(20);
//    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
/**
 *  播放完成
 */
- (void)playerPlayDidEnd
{
    self.backgroundColor  = RGBA(0, 0, 0, .6);
    self.repeatBtn.hidden = NO;
    // 初始化显示controlView为YES
    self.showing = NO;
    // 延迟隐藏controlView
    [self zn_playerShowControlView];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange
{
    if (ZFPlayerShared.isLockScreen) { return; }
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    if (ZFPlayerOrientationIsLandscape) {
        [self setOrientationLandscapeConstraint];
    } else {
        [self setOrientationPortraitConstraint];
    }
    [self layoutIfNeeded];
}




#pragma mark - BtnAction
- (void)resolutionBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    // 显示隐藏分辨率View
    self.resolutionView.hidden = !sender.isSelected;
}


/**
 *  应用退到后台
 */
- (void)appDidEnterBackground
{
    [self zn_playerCancelAutoFadeOutControlView];
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground
{
    if (!self.isShrink) { [self zn_playerShowControlView]; }
}
/**
 *  返回按钮
 */
- (void)backBtnClick:(UIButton *)sender
{
    // 状态条的方向旋转的方向,来判断当前屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 在cell上并且是竖屏时候响应关闭事件
    if (self.isCellVideo && orientation == UIInterfaceOrientationPortrait) {
        if ([self.delegate respondsToSelector:@selector(zn_controlView:backAction:)]) {
            [self.delegate zn_controlView:self backAction:sender];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(zn_controlView:backAction:)]) {
            [self.delegate zn_controlView:self backAction:sender];
        }
    }
}
/**
 *  全屏按钮
 */
- (void)fullScreenBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zn_controlView:fullScreenAction:)]) {
        [self.delegate zn_controlView:self fullScreenAction:sender];
    }
}
/**
 *  滑杆开始滑动
 */
- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender
{
    [self zn_playerCancelAutoFadeOutControlView];
    self.videoSlider.popUpView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zn_controlView:progressSliderTouchBegan:)]) {
        [self.delegate zn_controlView:self progressSliderTouchBegan:sender];
    }
}
/**
 *  滑杆滑动中
 */
- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender
{
    if ([self.delegate respondsToSelector:@selector(zn_controlView:progressSliderValueChanged:)]) {
        [self.delegate zn_controlView:self progressSliderValueChanged:sender];
    }
}
/**
 *  滑杆滑动结束
 */
- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender
{
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(zn_controlView:progressSliderTouchEnded:)]) {
        [self.delegate zn_controlView:self progressSliderTouchEnded:sender];
    }
}

/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(zn_controlView:progressSliderTap:)]) {
            [self.delegate zn_controlView:self progressSliderTap:tapValue];
        }
    }
}
// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}
/**
 *  锁屏的操作
 */
- (void)lockScrrenBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zn_controlView:lockScreenAction:)]) {
        [self.delegate zn_controlView:self lockScreenAction:sender];
    }
}
/**
 *  开始播放
 */
- (void)playBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zn_controlView:playAction:)]) {
        [self.delegate zn_controlView:self playAction:sender];
    }
}
/**
 *  关闭
 */
- (void)closeBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zn_controlView:closeAction:)]) {
        [self.delegate zn_controlView:self closeAction:sender];
    }
}
/**
 *  重播
 */
- (void)repeatBtnClick:(UIButton *)sender
{
    // 重置控制层View
    [self zn_playerResetControlView];
    [self zn_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(zn_controlView:repeatPlayAction:)]) {
        [self.delegate zn_controlView:self repeatPlayAction:sender];
    }
}
/**
 *  下载
 */
- (void)downloadBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zn_controlView:downloadVideoAction:)]) {
        [self.delegate zn_controlView:self downloadVideoAction:sender];
    }
}
/**
 *  Cell上的播放按钮
 */
- (void)centerPlayBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zn_controlView:cneterPlayAction:)]) {
        [self.delegate zn_controlView:self cneterPlayAction:sender];
    }
}
/**
 *  加载失败的按钮
 */
- (void)failBtnClick:(UIButton *)sender
{
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zn_controlView:failAction:)]) {
        [self.delegate zn_controlView:self failAction:sender];
    }
}





@end
