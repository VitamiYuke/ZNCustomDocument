//
//  ZNVideoPlayer.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/9.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNVideoPlayer.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UIImage+TintColor.h"
#import "AppDelegate.h"
#import "ZNPlayerSlider.h"
#import "UIImage+ScaleToSize.h"
@interface ZNVideoPlayer ()


// 背景图
@property(nonatomic, strong)UIImageView *bgImgView;

@property(nonatomic, copy)NSString *playUrl;//播放的地址

@property(retain,atomic)id<IJKMediaPlayback> player;

@property(nonatomic, strong)UIView *bottomOperationView;

@property(nonatomic, assign)BOOL isFullScreen;//是否是全屏

@property(nonatomic, assign)CGRect halfScreentFrame;//不是全屏状态下的位置

@property(nonatomic, strong)UIButton *maxOrMinScreenBtn;

// 时间的条
@property(nonatomic, strong)UILabel *playTimeLabel;
//播放按钮
@property(nonatomic, strong)UIButton *playAndPauseBtn;
//
@property(nonatomic, strong)ZNPlayerSlider *slider;
@property(nonatomic, assign)BOOL isDragSlider;






@end

@implementation ZNVideoPlayer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImageView *)bgImgView
{
    if (!_bgImgView ) {
        _bgImgView = [[UIImageView alloc] init];
    }
    return _bgImgView;
}

- (instancetype)init
{
    if ([super init]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andUrl:(NSString *)playUrl
{
    if ([super initWithFrame:frame]) {
        self.playUrl = playUrl;
        _isFullScreen = NO;
        _halfScreentFrame = frame;
       [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    self.backgroundColor = [UIColor blackColor];
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    NSURL *url = [NSURL URLWithString:self.playUrl];
    
    
    
    self.autoresizesSubviews = YES;
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeFill;
    self.player.shouldAutoplay = YES;
    
    [self addSubview:self.player.view];
    [self installMovieNotificationObservers];
    
    [self addSubview:self.bottomOperationView];
    // initWithFrame:CGRectMake(0, self.height - 50, self.width, 50)
    [self.bottomOperationView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.bottomOperationView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.bottomOperationView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.bottomOperationView autoSetDimension:ALDimensionHeight toSize:50];
}


- (void)configurePlayerWithUrl:(NSURL *)playUrl
{
    [self.player.view removeFromSuperview];
    [self removeSelfMovieNotificationObservers];
//    
    self.player = nil;
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:playUrl withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeFill;
    self.player.shouldAutoplay = YES;
    [self addRegisteSelfrMovieNotificationObservers];
    [self.player prepareToPlay];
    [self addSubview:self.player.view];
    
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFirstPaly:)
                                                 name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification
                                               object:_player];
    
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification object:_player];
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

//开始播放
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    MyLog(@"mediaIsPreparedToPlayDidChange\n");
    
}

- (void)movieFirstPaly:(NSNotification *)notification
{
    MyLog(@"开始播放");
    [self refreshPlayTime];
    [self.playAndPauseBtn setImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateNormal];
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    MyLog(@"播放状态在变");
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

- (void)dealloc
{
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    MyLog(@"%@销毁",self);
}

#pragma mark - 底部的操作

- (UIView *)bottomOperationView
{
    if (!_bottomOperationView) {
        _bottomOperationView = [[UIView alloc] init];
        _bottomOperationView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        [_bottomOperationView addSubview:self.maxOrMinScreenBtn];
        [self.maxOrMinScreenBtn autoSetDimension:ALDimensionHeight toSize:30];
        [self.maxOrMinScreenBtn autoSetDimension:ALDimensionWidth toSize:30];
        [self.maxOrMinScreenBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.maxOrMinScreenBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        // 时间条
        [_bottomOperationView addSubview:self.playTimeLabel];
        [self.playTimeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.playTimeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.maxOrMinScreenBtn withOffset:-10];
        
        //开始和暂停
        [_bottomOperationView addSubview:self.playAndPauseBtn];
        [self.playAndPauseBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.playAndPauseBtn autoSetDimension:ALDimensionWidth toSize:30];
        [self.playAndPauseBtn autoSetDimension:ALDimensionHeight toSize:30];
        [self.playAndPauseBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        //进度条
        [_bottomOperationView addSubview:self.slider];
        [self.slider autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.slider autoSetDimension:ALDimensionHeight toSize:5];
        [self.slider autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.playAndPauseBtn withOffset:10];
        [self.slider autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.playTimeLabel withOffset:-10];
        
    }
    return _bottomOperationView;
}

#pragma mark - 全屏按钮
- (void)createMaxButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    button.right = self.bottomOperationView.right - 10;
    button.y = 10;
    button.tintColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor whiteColor];
    UIImage *maxImg = [UIImage imageNamed:@"max"];
    [button setBackgroundImage:maxImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(maxAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomOperationView addSubview:button];
}

- (UIButton *)maxOrMinScreenBtn
{
    if (!_maxOrMinScreenBtn) {
        _maxOrMinScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _maxOrMinScreenBtn.backgroundColor = [UIColor whiteColor];
        UIImage *maxImg = [UIImage imageNamed:@"max"];
        [_maxOrMinScreenBtn setBackgroundImage:maxImg forState:UIControlStateNormal];
        [_maxOrMinScreenBtn addTarget:self action:@selector(maxAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maxOrMinScreenBtn;
}


- (void)maxAction:(UIButton *)sender
{
    MyLog(@"变大");
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.isFullScreen) {//收回全屏
        [sender setBackgroundImage:[UIImage imageNamed:@"max"] forState:UIControlStateNormal];
        self.isFullScreen = NO;
        appdelegate.isAllowFullScreenl = NO;
        [[ZNRegularHelp getCurrentShowViewController].navigationController setNavigationBarHidden:NO animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.halfScreentFrame;
            self.player.view.frame = self.bounds;
            
        }];

    } else {//变成全屏
         [sender setBackgroundImage:[UIImage imageNamed:@"min"] forState:UIControlStateNormal];
        self.isFullScreen = YES;
        appdelegate.isAllowFullScreenl = YES;
        [[ZNRegularHelp getCurrentShowViewController].navigationController setNavigationBarHidden:YES animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, SCREENT_WIDTH, SCREENT_HEIGHT);
            self.player.view.frame = self.bounds;
        }];
        appdelegate.isAllowFullScreenl = NO;
        
    }
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

- (void)refreshPlayTime
{
    // 总的时间长
    NSTimeInterval duration = self.player.duration;
    NSInteger intDuration = duration;
    NSString *totalTime = @"00:00";
    if (intDuration > 0) {
        totalTime = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
        self.slider.maximumValue = intDuration;
    } else {
        self.slider.maximumValue = 1.0f;
    }
    
    //当前的时间
    NSTimeInterval position;
    if (self.isDragSlider) {
        position = self.slider.value;
    } else {
        position = self.player.currentPlaybackTime;
    }
    NSInteger intPosition = position;
    self.slider.value = position;
    NSString *playTime = @"00:00";
    playTime = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    
    self.playTimeLabel.text = [NSString stringWithFormat:@"%@ / %@",playTime,totalTime];
    
    // 播放荷暂停
    if ([self.player isPlaying]) {
        [self.playAndPauseBtn setImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateNormal];
        
    } else {
        [self.playAndPauseBtn setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshPlayTime) object:nil];
    [self performSelector:@selector(refreshPlayTime) withObject:nil afterDelay:0.5];
}

#pragma mark - 播放按钮
- (UIButton *)playAndPauseBtn
{
    if (!_playAndPauseBtn) {
        _playAndPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playAndPauseBtn setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
        [_playAndPauseBtn addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playAndPauseBtn;
}

- (void)playOrPauseAction:(UIButton *)sender
{
    if ([self.player isPlaying]) {
        [self.player pause];
    } else {
        [self.player play];
    }
    [self refreshPlayTime];
}

#pragma mark - 滑动条
- (ZNPlayerSlider *)slider
{
    if (!_slider) {
        _slider = [[ZNPlayerSlider alloc] init];
        //自定义滑块大小
        UIImage *image = [UIImage imageNamed:@"iconfont-yuan"];
        //改变滑块大小
        UIImage *tempImage = [image OriginImage:image scaleToSize:CGSizeMake( 20, 20)];
        //改变滑块颜色
        UIImage *newImage = [tempImage imageWithTintColor:[UIColor redColor]];
        [_slider setThumbImage:newImage forState:UIControlStateNormal];
        //添加监听
        [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(touchCancelAction:) forControlEvents:UIControlEventTouchCancel];
        [_slider addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(touchUpOutsideAction:) forControlEvents:UIControlEventTouchUpOutside];
        //左边颜色
        _slider.minimumTrackTintColor = [UIColor redColor];
        //右边颜色
        _slider.maximumTrackTintColor = [UIColor grayColor];
    }
    return _slider;
}

- (void)progressSlider:(UISlider *)slider
{
    MyLog(@"改变进度");
    [self refreshPlayTime];
}

- (void)touchDownAction:(UISlider *)slider
{
    MyLog(@"按下");
    self.isDragSlider = YES;
}

- (void)touchUpInsideAction:(UISlider *)slider
{
    MyLog(@"放开");
    self.player.currentPlaybackTime = self.slider.value;
    self.isDragSlider = NO;
}

- (void)touchUpOutsideAction:(UISlider *)slider
{
    MyLog(@"放开");
    self.isDragSlider = NO;
}

- (void)touchCancelAction:(UISlider *)slider
{
    MyLog(@"取消");
     self.isDragSlider = NO;
}

#pragma mark - 播放新的视频
- (void)changeNewVideoWithUrl:(NSString *)newPlayUrl
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"keep.mp4" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self configurePlayerWithUrl:url];
    
}
#pragma mark - 添加和取消播放的通知
 - (void)addRegisteSelfrMovieNotificationObservers
{
    [self removeSelfMovieNotificationObservers];
    [self installMovieNotificationObservers];
}

- (void)removeSelfMovieNotificationObservers
{
    [self.player shutdown];
    [self removeMovieNotificationObservers];
}

- (void)prepareToPlayMovie
{
    [self.player prepareToPlay];
}

@end
