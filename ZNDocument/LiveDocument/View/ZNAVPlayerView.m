//
//  ZNAVPlayerView.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/10.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNAVPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+TintColor.h"
#import "UIImage+ScaleToSize.h"
#import "ZNPlayerSlider.h"
#import "AppDelegate.h"

//间隙
#define Padding        15
//消失时间
#define DisappearTime  4
//顶部底部控件高度
#define ViewHeight     50
//按钮大小
#define ButtonSize     35
//滑块大小
#define SliderSize     20
//进度条颜色
#define ProgressColor     [UIColor colorWithRed:1.00000f green:1.00000f blue:1.00000f alpha:0.40000f]
//缓冲颜色
#define ProgressTintColor [UIColor colorWithRed:1.00000f green:1.00000f blue:1.00000f alpha:1.00000f]
//播放完成颜色
#define PlayFinishColor   [UIColor redColor]
//滑块颜色
#define SliderColor       [UIColor redColor]

@interface ZNAVPlayerView ()

@property(nonatomic, assign)CGRect oldFrame;
/**播放器*/
@property(nonatomic,strong)AVPlayer *player;
/**playerLayer*/
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
/**播放器item*/
@property(nonatomic,strong)AVPlayerItem *playerItem;
/**播放进度条*/
@property(nonatomic,strong)ZNPlayerSlider *slider;
/**播放时间*/
@property(nonatomic,strong)UILabel *playTimeLabel;
/**表面View*/
@property(nonatomic,strong)UIView *backView;
/**转子*/
@property(nonatomic,strong)UIActivityIndicatorView *activity;
/**缓冲进度条*/
@property(nonatomic,strong)UIProgressView *progress;
/**顶部控件*/
@property(nonatomic,strong) UIView *topView;
/**底部控件 */
@property (nonatomic,strong) UIView *bottomOperationView;
/**播放按钮*/
@property (nonatomic,strong) UIButton *playAndPauseBtn;
/**轻拍定时器*/
@property (nonatomic,strong) NSTimer *timer;
/* 全屏*/
@property(nonatomic, strong)UIButton *maxOrMinScreenBtn;


@property(nonatomic, strong)NSURL *current_url;
/*背景展位图*/
@property(nonatomic, strong)UIImageView *bgImg;

@property(nonatomic, assign)BOOL isFullScreen;//是否是全屏

// 标题的文字
@property(nonatomic, strong)UILabel *fullScreenTitleLabel;
@property(nonatomic, strong)UIButton *fullScreenbackBtn;

//
@property(nonatomic, strong)NSTimer *progressTimer;

@end


@implementation ZNAVPlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}

- (UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.userInteractionEnabled = YES;
    }
    return _bgImg;
}

- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSURL *)url
{
    if ([super initWithFrame:frame]) {
        _oldFrame = frame;
        [self configureUIWithUrl:url];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withUrlString:(NSString *)urlString
{
    if ([super initWithFrame:frame]) {
        _oldFrame = frame;
        [self configureUIWithUrl:[NSURL URLWithString:urlString]];
    }
    return self;
}



- (void)configureUIWithUrl:(NSURL *)url
{
    _isFullScreen = NO;
    self.backgroundColor = [UIColor blackColor];
    self.current_url = url;
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    
    self.playerLayer.frame = self.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.layer addSublayer:self.playerLayer];
    
    [self addSubview:self.backView];
    [self.backView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.backView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.backView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.backView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    // 监听播放结束
    [self registerNotWitlPlayProgress];
    
    // 监听loadedTimeRanges属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [self.backView addSubview:self.topView];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.topView autoSetDimension:ALDimensionHeight toSize:64];
    
    
    
    [self.backView addSubview:self.bottomOperationView];
    [self.bottomOperationView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.bottomOperationView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.bottomOperationView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.bottomOperationView autoSetDimension:ALDimensionHeight toSize:44];
    
    //菊花
    [self.backView addSubview:self.activity];
    [self.activity autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.activity autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.activity startAnimating];
    
    //手势
    [self createGesture];
    //计时器 进行播放进度的循环
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshChangeProgress) userInfo:nil repeats:YES];
    //添加定时消失
    _timer = [NSTimer scheduledTimerWithTimeInterval:DisappearTime target:self selector:@selector(disappear) userInfo:nil repeats:NO];
    
}

#pragma mark - 手势
- (void)createGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}
#pragma mark - 轻拍方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_backView.alpha == 1)
    {
        //取消定时消失
        [_timer invalidate];
        [UIView animateWithDuration:0.5 animations:^{
            _backView.alpha = 0;
        }];
    } else if (_backView.alpha == 0)
    {
        //添加定时消失
        _timer = [NSTimer scheduledTimerWithTimeInterval:DisappearTime target:self selector:@selector(disappear) userInfo:nil repeats:NO];
        [UIView animateWithDuration:0.5 animations:^{
            _backView.alpha = 1;
        }];
    }
}
#pragma mark - 定时消失
- (void)disappear
{
    [UIView animateWithDuration:0.5 animations:^{
        _backView.alpha = 0;
    }];
}

#pragma mark - 全屏的设置
- (UIButton *)fullScreenbackBtn
{
    if (!_fullScreenbackBtn) {
        _fullScreenbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenbackBtn addTarget:self action:@selector(changeToMin) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenbackBtn.backgroundColor = [UIColor whiteColor];
    }
    return _fullScreenbackBtn;
}

- (void)changeToMin
{
    MyLog(@"表小平");
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.maxOrMinScreenBtn setBackgroundImage:[UIImage imageNamed:@"zb_xqy_quanping"] forState:UIControlStateNormal];
    self.isFullScreen = NO;
    appdelegate.isAllowFullScreenl = NO;
    [[ZNRegularHelp getCurrentShowViewController].navigationController setNavigationBarHidden:NO animated:NO];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = self.oldFrame;
        self.playerLayer.frame = self.bounds;
        self.topView.hidden = YES;
        
    }];
}

- (UILabel *)fullScreenTitleLabel
{
    if (!_fullScreenTitleLabel) {
        _fullScreenTitleLabel = [[UILabel alloc] init];
        _fullScreenTitleLabel.font = MyFont(16);
        _fullScreenTitleLabel.textColor = [UIColor whiteColor];
        _fullScreenTitleLabel.text = @"通货膨胀对投资的影响";
    }
    return _fullScreenTitleLabel;
}

#pragma mark - 更新播放的进度
- (void)refreshChangeProgress{
    
    if (self.playerItem.duration.timescale != 0) {
        _slider.maximumValue = 1;//总共时长
        _slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        //duration 总时长
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        self.playTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", proMin, proSec, durMin, durSec];
    }
    
    //开始播放停止转子
    if (_player.status == AVPlayerStatusReadyToPlay)
    {
        [_activity stopAnimating];
    }
    else
    {
        [_activity startAnimating];
    }
}


#pragma mark- 菊花
- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activity;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _topView.hidden = YES;
        [_topView addSubview:self.fullScreenbackBtn];
        [self.fullScreenbackBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
        [self.fullScreenbackBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:32];
        [self.fullScreenbackBtn autoSetDimension:ALDimensionWidth toSize:20];
        [self.fullScreenbackBtn autoSetDimension:ALDimensionHeight toSize:20];
        
        [_topView addSubview:self.fullScreenTitleLabel];
        [self.fullScreenTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.fullScreenbackBtn withOffset:20];
        [self.fullScreenTitleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.fullScreenbackBtn];
        
        
    }
    return _topView;
}

- (UIView *)bottomOperationView
{
    if (!_bottomOperationView) {
        _bottomOperationView = [[UIView alloc] init];
        _bottomOperationView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        [_bottomOperationView addSubview:self.maxOrMinScreenBtn];
        [self.maxOrMinScreenBtn autoSetDimension:ALDimensionHeight toSize:20];
        [self.maxOrMinScreenBtn autoSetDimension:ALDimensionWidth toSize:20];
        [self.maxOrMinScreenBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:Padding];
        [self.maxOrMinScreenBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

        // 时间条
        [_bottomOperationView addSubview:self.playTimeLabel];
        [self.playTimeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.playTimeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.maxOrMinScreenBtn withOffset:-Padding];
        
        //开始和暂停
        [_bottomOperationView addSubview:self.playAndPauseBtn];
        [self.playAndPauseBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:Padding];
        [self.playAndPauseBtn autoSetDimension:ALDimensionWidth toSize:20];
        [self.playAndPauseBtn autoSetDimension:ALDimensionHeight toSize:20];
        [self.playAndPauseBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        
        //缓冲条
        [_bottomOperationView addSubview:self.progress];
        [self.progress autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.progress autoSetDimension:ALDimensionHeight toSize:2.5];
        [self.progress autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.playAndPauseBtn withOffset:Padding - 3];
        [self.progress autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.playTimeLabel withOffset:-Padding + 3];
        
        //进度条
        [_bottomOperationView addSubview:self.slider];
        [self.slider autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.progress withOffset:-0.328];
        [self.slider autoSetDimension:ALDimensionHeight toSize:3];
        [self.slider autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.playAndPauseBtn withOffset:Padding];
        [self.slider autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.playTimeLabel withOffset:-Padding];
        
        
    }
    return _bottomOperationView;
}

#pragma mark - 时间进度条
- (UILabel *)playTimeLabel
{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.textColor = [UIColor whiteColor];
        _playTimeLabel.font = [UIFont systemFontOfSize:12];
        _playTimeLabel.text = @"00:00/00:00";
    }
    return _playTimeLabel;
}
#pragma mark - 全屏
- (UIButton *)maxOrMinScreenBtn
{
    if (!_maxOrMinScreenBtn) {
        _maxOrMinScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *maxImg = [UIImage imageNamed:@"zb_xqy_quanping"];
        [_maxOrMinScreenBtn setBackgroundImage:maxImg forState:UIControlStateNormal];
        [_maxOrMinScreenBtn addTarget:self action:@selector(maxAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maxOrMinScreenBtn;
}

- (void)maxAction:(UIButton *)sender
{
    MyLog(@"全屏");
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.isFullScreen) {//收回全屏
        [sender setBackgroundImage:[UIImage imageNamed:@"zb_xqy_quanping"] forState:UIControlStateNormal];
        self.isFullScreen = NO;
        appdelegate.isAllowFullScreenl = NO;
        [[ZNRegularHelp getCurrentShowViewController].navigationController setNavigationBarHidden:NO animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.oldFrame;
            self.playerLayer.frame = self.bounds;
            self.topView.hidden = YES;
            
        }];
        
    } else {//变成全屏
        [sender setBackgroundImage:[UIImage imageNamed:@"zb_xqy_xiaoping"] forState:UIControlStateNormal];
        self.isFullScreen = YES;
        appdelegate.isAllowFullScreenl = YES;
        [[ZNRegularHelp getCurrentShowViewController].navigationController setNavigationBarHidden:YES animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, SCREENT_WIDTH, SCREENT_HEIGHT);
            self.playerLayer.frame = self.bounds;
            self.topView.hidden = NO;
        } completion:^(BOOL finished) {
            if (finished) {
                appdelegate.isAllowFullScreenl = NO;
            }
        }];
        
        
    }
}

#pragma mark - 滑动条
- (ZNPlayerSlider *)slider
{
    if (!_slider) {
        _slider = [[ZNPlayerSlider alloc] init];
        //自定义滑块大小
        UIImage *image = [UIImage imageNamed:@"iconfont-yuan"];
        //改变滑块大小
        UIImage *tempImage = [image OriginImage:image scaleToSize:CGSizeMake( 15, 15)];
        //改变滑块颜色
        UIImage *newImage = [tempImage imageWithTintColor:[UIColor whiteColor]];
        [_slider setThumbImage:newImage forState:UIControlStateNormal];
        //添加监听
        [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(touchCancelAction:) forControlEvents:UIControlEventTouchCancel];
        [_slider addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(touchUpOutsideAction:) forControlEvents:UIControlEventTouchUpOutside];
        //左边颜色
        _slider.minimumTrackTintColor = MyColor(255, 105, 107);
        //右边颜色
        _slider.maximumTrackTintColor = [UIColor clearColor];
    }
    return _slider;
}

- (void)progressSlider:(UISlider *)slider
{
    MyLog(@"改变进度");
    if (self.player.status == AVPlayerStatusReadyToPlay)
    {
        //暂停
//        [self pausePlay];
        
        //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            //继续播放
//            [self playVideo];
        }];
        
    }

}

- (void)touchDownAction:(UISlider *)slider
{
    MyLog(@"按下");
   
}

- (void)touchUpInsideAction:(UISlider *)slider
{
    MyLog(@"放开");
    
}

- (void)touchUpOutsideAction:(UISlider *)slider
{
    MyLog(@"放开");
    
}

- (void)touchCancelAction:(UISlider *)slider
{
    MyLog(@"取消");
    
}

#pragma mark - 播放和暂停
- (UIButton *)playAndPauseBtn
{
    if (!_playAndPauseBtn) {
        _playAndPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playAndPauseBtn setImage:[UIImage imageNamed:@"zb_xqy_bofang"] forState:UIControlStateNormal];
        [_playAndPauseBtn addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playAndPauseBtn;
}

- (void)playOrPauseAction:(UIButton *)sender
{
    if (sender.selected) {//被选是播放
        [self pausePlay];
    } else {
        [self playVideo];
    }
    sender.selected = !sender.selected;
}

#pragma mark - 暂停播放
- (void)pausePlay
{
    [self.player pause];
    [self.playAndPauseBtn setImage:[UIImage imageNamed:@"zb_xqy_bofang"] forState:UIControlStateNormal];
    
}
#pragma mark - 播放
- (void)playVideo
{
    [self.player play];
    [self.playAndPauseBtn setImage:[UIImage imageNamed:@"zb_xqy_zanting"] forState:UIControlStateNormal];
}



#pragma mark - 缓存和进度条
#pragma mark - 缓存条监听

- (UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.backgroundColor = [UIColor clearColor];//MyColor(159, 159, 159)
        _progress.trackTintColor = MyColor(159, 159, 159);
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progress setProgress:timeInterval / totalDuration animated:NO];
        
        CGFloat time = round(timeInterval);
        CGFloat total = round(totalDuration);
        
        //确保都是number
        if (isnan(time) == 0 && isnan(total) == 0)
        {
            if (time == total)
            {
                //缓冲进度颜色
                self.progress.progressTintColor = [MyColor(159, 159, 159) colorWithAlphaComponent:0.5];
            }
            else
            {
                //缓冲进度颜色
                self.progress.progressTintColor = [UIColor clearColor];
            }
        }
        else
        {
            //缓冲进度颜色
            self.progress.progressTintColor = [UIColor clearColor];
        }
    }
    return _progress;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progress setProgress:timeInterval / totalDuration animated:NO];
        //设置缓存进度颜色
        self.progress.progressTintColor = ProgressTintColor;
    }
    
    
    
    if ([keyPath isEqualToString:@"status"]) {
        //获取当前状态
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay: //准备好开始播放
            {
                MyLog(@"开始播放");
            }
                break;
            case AVPlayerItemStatusFailed: //准备好开始播放
            {
                UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:nil message:@"播放失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [failedAlert show];
            }
                break;
            case AVPlayerItemStatusUnknown: //准备好开始播放
            {
                UIAlertView *unKnownAlert = [[UIAlertView alloc] initWithTitle:nil message:@"发生了未知的错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [unKnownAlert show];
            }
                break;
            default:
                break;
        }
    }
    
    
    
}
//计算缓冲进度
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}



#pragma mark - 开始直播
- (void)prepareToPlayMovie
{
    [self.player play];
    [self.playAndPauseBtn setSelected:YES];
    [self.playAndPauseBtn setImage:[UIImage imageNamed:@"zb_xqy_zanting"] forState:UIControlStateNormal];
}

- (void)pausePlayMovie
{
    [self.player pause];
    [self.playAndPauseBtn setSelected:NO];
    [self.playAndPauseBtn setImage:[UIImage imageNamed:@"zb_xqy_bofang"] forState:UIControlStateNormal];
}


- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"]; // status
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.player pause];
    self.player = nil;
    [self removeNotWithSelf];
    MyLog(@"%@销毁",self);
}

#pragma mark - 播放完成通知
- (void)moviePlayDidEnd:(NSNotification *)not
{
    MyLog(@"视屏播放结束");
}

#pragma mark - 创建通知 来进行播放进度控制
- (void)registerNotWitlPlayProgress
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

}

- (void)appDidEnterBackground{
    [self.player pause];
}

- (void)appDidEnterPlayground{
    [self.player play];
}

- (void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    MyLog(@"设备方向:%ld",interfaceOrientation);
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        [self.maxOrMinScreenBtn setBackgroundImage:[UIImage imageNamed:@"zb_xqy_quanping"] forState:UIControlStateNormal];
        self.isFullScreen = NO;
        [[ZNRegularHelp getCurrentShowViewController].navigationController setNavigationBarHidden:NO animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.oldFrame;
            self.playerLayer.frame = self.bounds;
            self.topView.hidden = YES;
            
        }];
    }
    
}


- (void)removeNotWithSelf
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 播放其他的视频
- (void)changePlayNewMovieWithUrl:(NSURL *)url
{
    
    if ([url isEqual:self.current_url]) {
        MyLog(@"播放的同一个视频");
        return;
    }
    self.current_url = url;
    
    if (self.playerItem ) {
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    
    self.playerItem = nil;
    self.playerItem = [[AVPlayerItem alloc] initWithURL:url];
    
    // 监听loadedTimeRanges属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    
}

- (void)removeSelfTimerAndReleaseSelf
{
    [self.timer invalidate];
     self.timer =nil;
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}



@end
