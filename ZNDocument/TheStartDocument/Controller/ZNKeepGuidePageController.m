//
//  ZNKeepGuidePageController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/9/12.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNKeepGuidePageController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface ZNKeepGuidePageController ()

@property(nonatomic, strong)AVPlayer *audionPlayer;
@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;//MPPalyerController

//音频会话
@property(nonatomic, strong)AVAudioSession *audioSession;

//音频的Url
@property(nonatomic, strong)NSURL *audioUrl;


@end

@implementation ZNKeepGuidePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureAudioSessionAtt];
    [self configureAnduiContainer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (AVPlayer *)audionPlayer
{
    if (!_audionPlayer) {
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:self.audioUrl];
        
        _audionPlayer = [ AVPlayer playerWithPlayerItem:item];
        
    }
    return _audionPlayer;
}

- (NSURL *)audioUrl
{
    if (!_audioUrl) {
        NSString *audioStr = [[NSBundle mainBundle] pathForResource:@"keep.mp4" ofType:nil];
//        NSString *path = [NSString stringWithFormat:@"%@%@",audioStr,@"/keep.mp4"];
        _audioUrl = [NSURL fileURLWithPath:audioStr];
    }
    return _audioUrl;
}


//avplayer播放
- (void)configureAnduiContainer
{
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.audionPlayer];
    playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:playerLayer];
    [self.audionPlayer play];
}
//MPMovePlayerController
- (void)configureMPMoviePlayerAtt
{
    
}

//配置音频
- (void)configureAudioSessionAtt
{
    self.audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    MyLog(@"音频配置：%@",[error localizedDescription]);
}


//将要显示的配置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}







@end
