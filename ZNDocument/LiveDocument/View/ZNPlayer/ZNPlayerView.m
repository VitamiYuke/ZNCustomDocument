//
//  ZNPlayerView.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/16.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZFBrightnessView.h"
#import "ZFPlayer.h"
// 播放器的几种状态
typedef NS_ENUM(NSInteger, ZNPlayerState) {
    ZNPlayerStateFailed,     // 播放失败
    ZNPlayerStateBuffering,  // 缓冲中
    ZNPlayerStatePlaying,    // 播放中
    ZNPlayerStateStopped,    // 停止播放
    ZNPlayerStatePause       // 暂停播放
};

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

@interface ZNPlayerView ()<ZNPlayerControllerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
/** 播放属性 */
@property (nonatomic, strong) AVPlayer               *player;
@property (nonatomic, strong) AVPlayerItem           *playerItem;
@property (nonatomic, strong) AVURLAsset             *urlAsset;
@property (nonatomic, strong) AVAssetImageGenerator  *imageGenerator;
/** playerLayer */
@property (nonatomic, strong) AVPlayerLayer          *playerLayer;
@property (nonatomic, strong) id                     timeObserve;//播放进度的时间监听
/** 滑杆 */
@property (nonatomic, strong) UISlider               *volumeViewSlider;
/** 控制层View */
@property (nonatomic, strong) ZNPlayerController    *controlView;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat                sumTime;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection           panDirection;
/** 播发器的几种状态 */
@property (nonatomic, assign) ZNPlayerState          state;
/** 是否为全屏 */
@property (nonatomic, assign) BOOL                   isFullScreen;
/** 是否锁定屏幕方向 */
@property (nonatomic, assign) BOOL                   isLocked;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL                   isVolume;
/** 是否显示controlView*/
@property (nonatomic, assign) BOOL                   isMaskShowing;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                   isPauseByUser;
/** 是否播放本地文件 */
@property (nonatomic, assign) BOOL                   isLocalVideo;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat                sliderLastValue;
/** 是否再次设置URL播放视频 */
@property (nonatomic, assign) BOOL                   repeatToPlay;
/** 播放完了*/
@property (nonatomic, assign) BOOL                   playDidEnd;
/** 进入后台*/
@property (nonatomic, assign) BOOL                   didEnterBackground;
/** 是否自动播放 */
@property (nonatomic, assign) BOOL                   isAutoPlay;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
/** 亮度view */
@property (nonatomic, strong) ZFBrightnessView       *brightnessView;

/** 切换分辨率传的字典(key:分辨率名称，value：分辨率url) */
@property (nonatomic, strong) NSDictionary         *resolutionDic;
/** 从xx秒开始播放视频跳转 */
@property (nonatomic, assign) NSInteger            seekTime;
/** 播放前占位图片的名称，不设置就显示默认占位图（需要在设置视频URL之前设置） */
@property (nonatomic, copy  ) NSString             *placeholderImageName;
/** 视频URL */
@property (nonatomic, strong) NSURL                   *videoURL;
/** 视频标题 */
@property (nonatomic, strong) NSString                *title;
/** 播放器view的父视图 */
@property (nonatomic, strong) UIView                 *fatherView;
/** 视频URL的数组 */
@property (nonatomic, strong) NSArray                *videoURLArray;
/** slider预览图 */
@property (nonatomic, strong) UIImage                *thumbImg;
#pragma mark - UITableViewCell PlayerView

/** palyer加到tableView */
@property (nonatomic, strong) UITableView            *tableView;
/** player所在cell的indexPath */
@property (nonatomic, strong) NSIndexPath            *indexPath;
/** cell上imageView的tag */
@property (nonatomic, assign) NSInteger              cellImageViewTag;
/** ViewController中页面是否消失 */
@property (nonatomic, assign) BOOL                   viewDisappear;
/** 是否在cell上播放video */
@property (nonatomic, assign) BOOL                   isCellVideo;
/** 是否缩小视频在底部 */
@property (nonatomic, assign) BOOL                   isBottomVideo;
/** 是否切换分辨率*/
@property (nonatomic, assign) BOOL                   isChangeResolution;
/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL                   isDragged;


@end

@implementation ZNPlayerView

#pragma mark - life Cycle
/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZNPlayer
 */

+ (instancetype)sharedPlayerView
{
    static ZNPlayerView *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[ZNPlayerView alloc] init];
    });
    return playerView;
}
/**
 *  代码初始化调用此方法
 */
- (instancetype)init
{
    self = [super init];
    if (self) { [self initializeThePlayer]; }
    return self;
}

/**
 *  storyboard、xib加载playerView会调用此方法
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initializeThePlayer];
}
/**
 *  初始化player
 */
- (void)initializeThePlayer
{
    // 每次播放视频都解锁屏幕锁定
//    [self unLockTheScreen];
}
- (void)dealloc
{
    self.playerItem = nil;
    self.tableView  = nil;
    self.brightnessView.isLockScreen     = NO;
    [self.controlView zn_playerCancelAutoFadeOutControlView];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    // 移除time观察者
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
}
/**
 *  重置player
 */
- (void)resetPlayer
{
    // 改为为播放完
    self.playDidEnd         = NO;
    self.playerItem         = nil;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    self.isAutoPlay         = NO;
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.imageGenerator = nil;
    self.player         = nil;
    self.controlView    = nil;
    if (self.isChangeResolution) { // 切换分辨率
        [self.controlView zn_playerResetControlViewForResolution];
        self.isChangeResolution = NO;
    }else { // 重置控制层View
        [self.controlView zn_playerResetControlView];
    }
    // 非重播时，移除当前playerView
    if (!self.repeatToPlay) { [self removeFromSuperview]; }
    // 底部播放video改为NO
    self.isBottomVideo = NO;
    // cell上播放视频 && 不是重播时
    if (self.isCellVideo && !self.repeatToPlay) {
        // vicontroller中页面消失
        self.viewDisappear = YES;
        self.isCellVideo   = NO;
        self.tableView     = nil;
        self.indexPath     = nil;
    }
}
/**
 *  在当前页面，设置新的Player的URL调用此方法
 */
- (void)resetToPlayNewURL
{
    self.repeatToPlay = YES;
    [self resetPlayer];
}
/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(ZNPlayItem *)playerModel
{
    self.repeatToPlay = YES;
    [self resetPlayer];
    self.playerModel = playerModel;
    [self configZNPlayer];
}
#pragma mark - 观察者、通知
/**
 *  添加观察者、通知
 */
- (void)addNotifications
{
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStatusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.playerLayer.frame = self.bounds;
    [UIApplication sharedApplication].statusBarHidden = NO;
}
#pragma mark - 设置视频URL

/**
 *  用于cell上播放player
 *
 *  @param videoURL  视频的URL
 *  @param tableView tableView
 *  @param indexPath indexPath
 */
- (void)setVideoURL:(NSURL *)videoURL
      withTableView:(UITableView *)tableView
        AtIndexPath:(NSIndexPath *)indexPath
   withImageViewTag:(NSInteger)tag
{
    // 如果页面没有消失，并且playerItem有值，需要重置player(其实就是点击播放其他视频时候)
    if (!self.viewDisappear && self.playerItem) { [self resetPlayer]; }
    // 在cell上播放视频
    self.isCellVideo      = YES;
    // viewDisappear改为NO
    self.viewDisappear    = NO;
    // 设置imageView的tag
    self.cellImageViewTag = tag;
    // 设置tableview
    self.tableView        = tableView;
    // 设置indexPath
    self.indexPath        = indexPath;
    // 设置视频URL
    [self setVideoURL:videoURL];
    // 在cell播放
    [self.controlView zn_playerCellPlay];
}

/**
 *  videoURL的setter方法
 *
 *  @param videoURL videoURL
 */
- (void)setVideoURL:(NSURL *)videoURL
{
    _videoURL = videoURL;
    //    if (!self.isCellVideo) { ZFPlayerShared.isAllowLandscape = YES; }
    
    // 每次加载视频URL都设置重播为NO
    self.repeatToPlay = NO;
    self.playDidEnd   = NO;
    
    // 添加通知
    [self addNotifications];
    
    self.isPauseByUser = YES;
    
    // 添加手势
    [self createGesture];
}
/**
 *  设置Player相关参数
 */
- (void)configZNPlayer
{
    self.urlAsset = [AVURLAsset assetWithURL:self.videoURL];
    // 初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    // 初始化playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    self.backgroundColor = [UIColor blackColor];
    // 此处为默认视频填充模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 添加playerLayer到self.layer
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
    // 自动播放
    self.isAutoPlay = YES;
    
    // 添加播放进度计时器
    [self createTimer];
    
    // 获取系统音量
    [self configureVolume];
    
    // 本地文件不设置ZFPlayerStateBuffering状态
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = ZNPlayerStatePlaying;
        self.isLocalVideo = YES;
        [self.controlView zn_playerDownloadBtnState:NO];
    } else {
        self.state = ZNPlayerStateBuffering;
        self.isLocalVideo = NO;
        [self.controlView zn_playerDownloadBtnState:YES];
    }
    // 开始播放
    [self play];
    self.isPauseByUser = NO;
    
    // 强制让系统调用layoutSubviews 两个方法必须同时写
    [self setNeedsLayout]; //是标记 异步刷新 会调但是慢
    [self layoutIfNeeded]; //加上此代码立刻刷新
}
/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo
{
    // 设置Player相关参数
    [self configZNPlayer];
}
#pragma mark - 手势 和进度定时器
/**
 *  创建手势
 */
- (void)createGesture
{
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    
    [self addGestureRecognizer:self.doubleTap];
    
    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
}
/**
 *  创建进度定时器
 */
- (void)createTimer
{
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf.controlView zn_playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
        }
    }];
}
#pragma mark - 系统声音
/**
 *  获取系统音量
 */
- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}
/**
 *  耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [self play];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}
#pragma mark - 触摸
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isAutoPlay) {
        UITouch *touch = [touches anyObject];
        if(touch.tapCount == 1) {
            [self performSelector:@selector(singleTapAction:) withObject:@(NO) ];
        } else if (touch.tapCount == 2) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction:) object:nil];
            [self doubleTapAction:touch.gestureRecognizers.lastObject];
        }
    }
}
#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture
{
    if ([gesture isKindOfClass:[NSNumber class]] && ![(id)gesture boolValue]) {
        [self _fullScreenAction];
        return;
    }
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBottomVideo && !self.isFullScreen) { [self _fullScreenAction]; }
        else {
            if (self.playDidEnd) { return; }
            else { [self.controlView zn_playerShowControlView]; }
        }
    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture
{
    if (self.playDidEnd) { return;  }
    // 显示控制层
    [self.controlView zn_playerCancelAutoFadeOutControlView];
    [self.controlView zn_playerShowControlView];
    if (self.isPauseByUser) { [self play]; }
    else { [self pause]; }
    if (!self.isAutoPlay) {
        self.isAutoPlay = YES;
        [self configZNPlayer];
    }
}
/**
 *  播放
 */
- (void)play
{
    [self.controlView zn_playerPlayBtnState:YES];
    if (self.state == ZNPlayerStatePause) { self.state = ZNPlayerStatePlaying; }
    self.isPauseByUser = NO;
    [_player play];
    if (!self.isBottomVideo) {
        // 显示控制层
        [self.controlView zn_playerCancelAutoFadeOutControlView];
        [self.controlView zn_playerShowControlView];
    }
}

/**
 * 暂停
 */
- (void)pause
{
    [self.controlView zn_playerPlayBtnState:NO];
    if (self.state == ZNPlayerStatePlaying) { self.state = ZNPlayerStatePause;}
    self.isPauseByUser = YES;
    [_player pause];
}

/** 全屏 */
- (void)_fullScreenAction
{
    if (self.brightnessView.isLockScreen) {
        [self unLockTheScreen];
        return;
    }
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.isFullScreen = NO;
        return;
    } else {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        self.isFullScreen = YES;
    }
}

#pragma mark - KVO监听视频缓冲等 播放状态

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                
                self.state = ZNPlayerStatePlaying;
                // 加载完成后，再添加平移手势
                // 添加平移手势，用来控制音量、亮度、快进快退
                UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
                panRecognizer.delegate = self;
                [panRecognizer setMaximumNumberOfTouches:1];
                [panRecognizer setDelaysTouchesBegan:YES];
                [panRecognizer setDelaysTouchesEnded:YES];
                [panRecognizer setCancelsTouchesInView:YES];
                [self addGestureRecognizer:panRecognizer];
                
                // 跳到xx秒播放视频
                if (self.seekTime) {
                    [self seekToTime:self.seekTime completionHandler:nil];
                }
                
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.state = ZNPlayerStateFailed;
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            
            [self.controlView zn_playerSetProgress:timeInterval / totalDuration];
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            // 当缓冲是空的时候
            if (self.playerItem.playbackBufferEmpty) {
                self.state = ZNPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
            // 当缓冲好的时候
            if (self.playerItem.playbackLikelyToKeepUp && self.state == ZNPlayerStateBuffering){
                self.state = ZNPlayerStatePlaying;
            }
            
        }
    } else if (object == self.tableView) {
        if ([keyPath isEqualToString:@"contentOffset"]) {//监听UITableView的滑动
            if (self.isFullScreen) { return; }
            // 当tableview滚动时处理playerView的位置
            [self handleScrollOffsetWithDict:change];
        }
    }
}
#pragma mark - 缓冲较差时候

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond
{
    self.state = ZNPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) { [self bufferingSomeSecond]; }
        
    });
}
#pragma mark - 计算缓冲进度

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - NSNotification Action

/**
 *  播放完了
 *
 *  @param notification 通知
 */
- (void)moviePlayDidEnd:(NSNotification *)notification
{
    self.state = ZNPlayerStateStopped;
    if (self.isBottomVideo && !self.isFullScreen) { // 播放完了，如果是在小屏模式 && 在bottom位置，直接关闭播放器
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
    } else {
        if (!self.isDragged) { // 如果不是拖拽中，直接结束播放
            self.playDidEnd = YES;
            [self.controlView zn_playerPlayEnd];
        }
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground
{
    self.didEnterBackground = YES;
    [_player pause];
    self.state = ZNPlayerStatePause;
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground
{
    self.didEnterBackground = NO;
    if (!self.isPauseByUser) {
        self.state          = ZNPlayerStatePlaying;
        self.isPauseByUser  = NO;
        [self play];
    }
    if (self.isFullScreen) {
        if (self.isCellVideo) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
            self.transform = [self getTransformRotationAngle];
            [self.controlView setNeedsLayout];
            [self.controlView layoutIfNeeded];
        }
    }
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler
{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        [self.controlView zn_playerActivity:YES];
        [self.player pause];
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1); //kCMTimeZero
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
            [weakSelf.controlView zn_playerActivity:NO];
            // 视频跳转回调
            if (completionHandler) { completionHandler(finished); }
            [self.player play];
            self.seekTime = 0;
            self.isDragged = NO;
            // 结束滑动
            [self.controlView zn_playerDraggedEnd];
            if (!self.playerItem.isPlaybackLikelyToKeepUp && !self.isLocalVideo) { self.state = ZNPlayerStateBuffering; }
            
        }];
    }
}
#pragma mark - tableViewContentOffset

/**
 *  KVO TableViewContentOffset
 *
 *  @param dict void
 */
- (void)handleScrollOffsetWithDict:(NSDictionary*)dict
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    NSArray *visableCells = self.tableView.visibleCells;
    if ([visableCells containsObject:cell]) {
        // 在显示中
        [self updatePlayerViewToCell];
    }else {
        // 在底部
        [self updatePlayerViewToBottom];
    }
}

/**
 *  缩小到底部，显示小视频
 */
- (void)updatePlayerViewToBottom
{
    if (self.isBottomVideo) { return; }
    self.isBottomVideo = YES;
    if (self.playDidEnd) { // 如果播放完了，滑动到小屏bottom位置时，直接resetPlayer
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
        return;
    }
    [self layoutIfNeeded];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGFloat width = SCREENT_WIDTH*0.5-20;
    CGFloat height = (self.bounds.size.height / self.bounds.size.width);
//    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//        make.width.mas_equalTo(width);
//        make.height.equalTo(self.mas_width).multipliedBy(height);
//        make.trailing.mas_equalTo(-10);
//        make.bottom.mas_equalTo(-self.tableView.contentInset.bottom-10);
//    }];
    [self autoSetDimension:ALDimensionWidth toSize:width];
    [self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:(-self.tableView.contentInset.bottom-10)];
    [self autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self autoSetDimension:ALDimensionHeight toSize:width*height];
    // 小屏播放
    [self.controlView zn_playerBottomShrinkPlay];
}

/**
 *  回到cell显示
 */
- (void)updatePlayerViewToCell
{
    if (!self.isBottomVideo) { return; }
    self.isBottomVideo = NO;
    [self setOrientationPortraitConstraint];
    [self.controlView zn_playerCellPlay];
}

/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation
{
    [self toOrientation:orientation];
    self.isFullScreen = YES;
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint
{
    [self removeFromSuperview];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    NSArray *visableCells = self.tableView.visibleCells;
    self.isBottomVideo = NO;
    if (![visableCells containsObject:cell]) {
        [self updatePlayerViewToBottom];
    } else {
        // 根据tag取到对应的cellImageView
        UIImageView *cellImageView = [cell viewWithTag:self.cellImageViewTag];
        [self addPlayerToCellImageView:cellImageView];
    }
    [self toOrientation:UIInterfaceOrientationPortrait];
    self.isFullScreen = NO;
}

- (void)toOrientation:(UIInterfaceOrientation)orientation
{
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self removeFromSuperview];
            ZFBrightnessView *brightnessView = [ZFBrightnessView sharedBrightnessView];
            [[UIApplication sharedApplication].keyWindow insertSubview:self belowSubview:brightnessView];
//            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(@(ScreenHeight));
//                make.height.equalTo(@(ScreenWidth));
//                make.center.equalTo(self.superview);
//            }];
            [self autoSetDimension:ALDimensionHeight toSize:SCREENT_WIDTH];
            [self autoSetDimension:ALDimensionWidth toSize:SCREENT_HEIGHT];
            [self autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            
        }
    }
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    [UIView setAnimationDuration:0.4];
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];
    // 开始旋转
    [UIView commitAnimations];
    [self.controlView layoutIfNeeded];
    [self.controlView setNeedsLayout];
}


/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle
{
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark 屏幕转屏相关

/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (!self.isCellVideo) {
        // arc下
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector             = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val                  = orientation;
            // 从2开始是因为0 1 两个参数已经被selector和target占用
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    } else {
        if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
            // 设置横屏
            [self setOrientationLandscapeConstraint:orientation];
        } else if (orientation == UIInterfaceOrientationPortrait) {
            // 设置竖屏
            [self setOrientationPortraitConstraint];
        }
    }
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange
{
    if (!self.player) { return; }
    if (self.brightnessView.isLockScreen) { return; }
    if (self.didEnterBackground) { return; };
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    
    if (!self.isCellVideo) {
        [self.brightnessView removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
//        [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(155);
//            make.leading.mas_equalTo((ScreenWidth-155)/2);
//            make.top.mas_equalTo((ScreenHeight-155)/2);
//        }];
        [self.brightnessView autoSetDimension:ALDimensionWidth toSize:155];
        [self.brightnessView autoSetDimension:ALDimensionHeight toSize:155];
        [self.brightnessView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(SCREENT_WIDTH - 155)/2];
        [self.brightnessView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(SCREENT_HEIGHT - 155)/2];
        
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) || orientation == UIDeviceOrientationPortraitUpsideDown) {
            self.isFullScreen = YES;
        } else {
            self.isFullScreen = NO;
        }
        [self normalVideoDeviceOrientationChange];
    } else {
        switch (interfaceOrientation) {
            case UIInterfaceOrientationPortraitUpsideDown:{
            }
                break;
            case UIInterfaceOrientationPortrait:{
                if (self.isFullScreen) {
                    [self toOrientation:UIInterfaceOrientationPortrait];
                    
                }
            }
                break;
            case UIInterfaceOrientationLandscapeLeft:{
                if (self.isFullScreen == NO) {
                    [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                    self.isFullScreen = YES;
                } else {
                    [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                }
                
            }
                break;
            case UIInterfaceOrientationLandscapeRight:{
                if (self.isFullScreen == NO) {
                    [self toOrientation:UIInterfaceOrientationLandscapeRight];
                    self.isFullScreen = YES;
                } else {
                    [self toOrientation:UIInterfaceOrientationLandscapeRight];
                }
            }
                break;
            default:
                break;
        }
    }
}

// 状态条变化通知（只有在cell播放时候去处理）
- (void)onStatusBarOrientationChange
{
    if (self.isCellVideo && !self.didEnterBackground) {
        // 获取到当前状态条的方向
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self setOrientationPortraitConstraint];
            [self.tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            
            [self.brightnessView removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
//            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.mas_equalTo(155);
//                make.leading.mas_equalTo((ScreenWidth-155)/2);
//                make.top.mas_equalTo((ScreenHeight-155)/2);
//            }];
            [self.brightnessView autoSetDimension:ALDimensionWidth toSize:155];
            [self.brightnessView autoSetDimension:ALDimensionHeight toSize:155];
            [self.brightnessView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(SCREENT_WIDTH - 155)/2];
            [self.brightnessView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(SCREENT_HEIGHT - 155)/2];
            
        } else {
            if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            } else if (currentOrientation == UIDeviceOrientationLandscapeLeft){
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            [self.brightnessView removeFromSuperview];
            [self addSubview:self.brightnessView];
//            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(self);
//                make.width.height.mas_equalTo(155);
//            }];
            [self.brightnessView autoSetDimension:ALDimensionWidth toSize:155];
            [self.brightnessView autoSetDimension:ALDimensionHeight toSize:155];
            [self.brightnessView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [self.brightnessView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            
        }
    }
}

// 普通状态播放（非cell上播放）视频
- (void)normalVideoDeviceOrientationChange
{
    if (self.isFullScreen) {
        [self removeFromSuperview];
        // 亮度view加到window最上层
        [[UIApplication sharedApplication].keyWindow insertSubview:self belowSubview:self.brightnessView];
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsZero);
//        }];
        [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    } else {
        [self layoutIfNeeded];
        _fatherView = self.superview;
        [self removeFromSuperview];
        [self.fatherView addSubview:self];
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.frame.origin.y);
//            make.leading.mas_equalTo(self.frame.origin.x);
//            make.height.mas_equalTo(self.frame.size.height);
//            make.width.mas_equalTo(self.frame.size.width);
//        }];
        [self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.frame.origin.y];
        [self autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.frame.origin.x];
        [self autoSetDimension:ALDimensionHeight toSize:self.frame.size.height];
        [self autoSetDimension:ALDimensionWidth toSize:self.frame.size.width];
        // 父视图置为nil
        self.fatherView = nil;
    }
}

/**
 *  锁定屏幕方向按钮
 *
 *  @param sender UIButton
 */
- (void)lockScreenAction:(UIButton *)sender
{
    sender.selected             = !sender.selected;
    self.isLocked               = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏，在TabBarController设置哪些页面支持旋转
    self.brightnessView.isLockScreen = sender.selected;
}

/**
 *  解锁屏幕方向锁定
 */
- (void)unLockTheScreen
{
    // 调用AppDelegate单例记录播放状态是否锁屏
    self.brightnessView.isLockScreen = NO;
    [self.controlView zn_playerLockBtnState:NO];
    self.isLocked = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

/**
 *  player添加到cellImageView上
 *
 *  @param cell 添加player的cellImageView
 */
- (void)addPlayerToCellImageView:(UIImageView *)imageView
{
    [imageView addSubview:self];
//    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.leading.trailing.bottom.equalTo(imageView);
//    }];
    [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

#pragma mark - UIPanGestureRecognizer手势方法

/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值
                CMTime time       = self.player.currentTime;
                self.sumTime      = time.value/time.timescale;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    self.isPauseByUser = NO;
                    [self seekToTime:self.sumTime completionHandler:nil];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value
{
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value
{
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    CMTime totalTime           = self.playerItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    self.isDragged = YES;
    [self.controlView zn_playerDraggedTime:self.sumTime totalTime:totalMovieDuration isForward:style hasPreview:NO];
}

/**
 *  根据时长求出字符串
 *
 *  @param time 时长
 *
 *  @return 时长字符串
 */
- (NSString *)durationStringWithTime:(int)time
{
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if ((self.isCellVideo && !self.isFullScreen) || self.playDidEnd){
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.isBottomVideo && !self.isFullScreen) {
            return NO;
        }
    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Setter

/**
 *  设置播放的状态
 *
 *  @param state ZFPlayerState
 */
- (void)setState:(ZNPlayerState)state
{
    _state = state;
    // 控制菊花显示、隐藏
    [self.controlView zn_playerActivity:state == ZNPlayerStateBuffering];
    if (state == ZNPlayerStatePlaying || state == ZNPlayerStateBuffering) {
        // 隐藏占位图
        [self.controlView zn_playerItemPlaying];
    } else if (state == ZNPlayerStateFailed) {
        NSError *error = [self.playerItem error];
        [self.controlView zn_playerItemStatusFailed:error];
    }
}

/**
 *  根据playerItem，来添加移除观察者
 *
 *  @param playerItem playerItem
 */
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem == playerItem) {return;}
    
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}

/**
 *  根据tableview的值来添加、移除观察者
 *
 *  @param tableView tableView
 */
- (void)setTableView:(UITableView *)tableView
{
    if (_tableView == tableView) { return; }
    if (_tableView) {
        [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _tableView = tableView;
    if (tableView) { [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil]; }
}

/**
 *  设置playerLayer的填充模式
 *
 *  @param playerLayerGravity playerLayerGravity
 */
- (void)setPlayerLayerGravity:(ZNPlayerLayerGravity)playerLayerGravity
{
    _playerLayerGravity = playerLayerGravity;
    // AVLayerVideoGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
    // AVLayerVideoGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
    // AVLayerVideoGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
    switch (playerLayerGravity) {
        case ZNPlayerLayerGravityResize:
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
        case ZNPlayerLayerGravityResizeAspect:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case ZNPlayerLayerGravityResizeAspectFill:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            break;
    }
}

/**
 *  是否有下载功能
 */
- (void)setHasDownload:(BOOL)hasDownload
{
    _hasDownload = hasDownload;
    [self.controlView zn_playerHasDownloadFunction:hasDownload];
}

- (void)setResolutionDic:(NSDictionary *)resolutionDic
{
    _resolutionDic = resolutionDic;
    [self.controlView zn_playerResolutionArray:[resolutionDic allKeys]];
    self.videoURLArray = [resolutionDic allValues];
}

/**
 *  设置播放视频前的占位图
 *
 *  @param placeholderImageName 占位图的图片名称
 */
- (void)setPlaceholderImageName:(NSString *)placeholderImageName
{
    _placeholderImageName = placeholderImageName;
    if (placeholderImageName) {
        UIImage *image = [UIImage imageNamed:self.placeholderImageName];
        self.playerModel.placeholderImage = image;
    }else {
        UIImage *image = [UIImage imageNamed:@""];
        self.playerModel.placeholderImage = image;
    }
    [self.controlView zn_playerModel:self.playerModel];
}

//设置播放的模型
- (void)setPlayerModel:(ZNPlayItem *)playerModel
{
    _playerModel = playerModel;
    
    if (playerModel.seekTime) { self.seekTime = playerModel.seekTime; }
    [self.controlView zn_playerModel:playerModel];
    
    if (playerModel.tableView && playerModel.indexPath && playerModel.videoURL && playerModel.cellImageViewTag) {
        [self setVideoURL:playerModel.videoURL withTableView:playerModel.tableView AtIndexPath:playerModel.indexPath withImageViewTag:playerModel.cellImageViewTag];
        if (playerModel.resolutionDic) { self.resolutionDic = playerModel.resolutionDic; }
        return;
    }
    self.videoURL = playerModel.videoURL;
}

#pragma mark - Getter

- (AVAssetImageGenerator *)imageGenerator
{
    if (!_imageGenerator) {
        _imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.urlAsset];
    }
    return _imageGenerator;
}

- (ZFBrightnessView *)brightnessView
{
    if (!_brightnessView) {
        _brightnessView = [ZFBrightnessView sharedBrightnessView];
    }
    return _brightnessView;
}

#pragma mark - 设置控制层
- (ZNPlayerController *)controlView
{
    if (!_controlView) {
        _controlView = [[ZNPlayerController alloc] init];
        _controlView.delegate = self;
        [self addSubview:_controlView];
        [_controlView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    return _controlView;
}



#pragma mark - 播放控制器的代理
//返回
- (void)zn_controlView:(UIView *)controlView backAction:(UIButton *)sender
{
    if (self.brightnessView.isLockScreen) {
        [self unLockTheScreen];
    } else {
        if (!self.isFullScreen) {
            // player加到控制器上，只有一个player时候
            [self pause];
            if (self.goBackAction) {
                self.goBackAction();
            }
        } else {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
    }
}
- (void)zn_controlView:(UIView *)controlView failAction:(UIButton *)sender
{
    [self configZNPlayer];
}

- (void)zn_controlView:(UIView *)controlView playAction:(UIButton *)sender
{
    self.isPauseByUser = !self.isPauseByUser;
    if (self.isPauseByUser) {
        [self pause];
        if (self.state == ZNPlayerStatePlaying) { self.state = ZNPlayerStatePause;}
    } else {
        [self play];
        if (self.state == ZNPlayerStatePause) { self.state = ZNPlayerStatePlaying; }
    }
    
    if (!self.isAutoPlay) {
        self.isAutoPlay = YES;
        [self configZNPlayer];
    }
}

- (void)zn_controlView:(UIView *)controlView closeAction:(UIButton *)sender
{
    [self resetPlayer];
    [self removeFromSuperview];
}

- (void)zn_controlView:(UIView *)controlView cneterPlayAction:(UIButton *)sender
{
    [self configZNPlayer];
}

- (void)zn_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender
{
    [self _fullScreenAction];
}

- (void)zn_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender
{
    self.isLocked               = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏
    self.brightnessView.isLockScreen = sender.selected;
}

- (void)zn_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender
{
    
    // 没有播放完
    self.playDidEnd   = NO;
    // 重播改为NO
    self.repeatToPlay = NO;
    [self seekToTime:0 completionHandler:nil];
    
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = ZNPlayerStatePlaying;
    } else {
        self.state = ZNPlayerStateBuffering;
    }
}

//控制杆的事件
- (void)zn_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value
{
    MyLog(@"点击的进度:%.0f",value);
    // 视频总时间长度
    CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(total * value);
    
    [self.controlView zn_playerPlayBtnState:YES];
    [self seekToTime:dragedSeconds completionHandler:^(BOOL finished) {}];
}

- (void)zn_controlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider
{
    MyLog(@"开始按下滑动杆");
}

- (void)zn_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider
{
    MyLog(@"进度:%.0f",slider.value);
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isPauseByUser = NO;
        self.isDragged = NO;
        // 视频总时间长度
        CGFloat total           = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        [self seekToTime:dragedSeconds completionHandler:nil];
    }
}

- (void)zn_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider
{
    MyLog(@"改变:%.0f",slider.value);
    // 拖动改变视频播放进度
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = YES;
        BOOL style = false;
        CGFloat value   = slider.value - self.sliderLastValue;
        if (value > 0) { style = YES; }
        if (value < 0) { style = NO; }
        if (value == 0) { return; }
        
        self.sliderLastValue  = slider.value;
        
        CGFloat totalTime     = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //计算出拖动的当前秒数
        CGFloat dragedSeconds = floorf(totalTime * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime   = CMTimeMake(dragedSeconds, 1);
        
        [self.controlView zn_playerDraggedTime:dragedSeconds totalTime:totalTime isForward:style hasPreview:self.isFullScreen ? self.hasPreviewView : NO];
        
        if (totalTime > 0) { // 当总时长 > 0时候才能拖动slider
            if (self.isFullScreen && self.hasPreviewView) {
                
                [self.imageGenerator cancelAllCGImageGeneration];
                self.imageGenerator.appliesPreferredTrackTransform = YES;
                self.imageGenerator.maximumSize = CGSizeMake(100, 56);
                AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                    NSLog(@"%zd",result);
                    if (result != AVAssetImageGeneratorSucceeded) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.controlView zn_playerDraggedTime:dragedSeconds sliderImage:self.thumbImg ? : ZFPlayerImage(@"ZFPlayer_loading_bgView")];
                        });
                    } else {
                        self.thumbImg = [UIImage imageWithCGImage:im];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.controlView zn_playerDraggedTime:dragedSeconds sliderImage:self.thumbImg ? : ZFPlayerImage(@"ZFPlayer_loading_bgView")];
                        });
                    }
                };
                [self.imageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:dragedCMTime]] completionHandler:handler];
            }
        } else {
            // 此时设置slider值为0
            slider.value = 0;
        }
        
    }else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }
}



@end
