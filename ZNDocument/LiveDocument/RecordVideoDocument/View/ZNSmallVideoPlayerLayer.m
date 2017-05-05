//
//  ZNSmallVideoPlayerLayer.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/4.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNSmallVideoPlayerLayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ZNSmallVideoPlayerLayer ()



@end

@implementation ZNSmallVideoPlayerLayer{
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVURLAsset *_urlAsset;
    AVAssetImageGenerator *_imageGenerator;
    AVPlayerLayer *_playerLayer;
}



- (void)configurePlayInfoWithVideoURL:(NSURL *)video_url{
    
    if (!video_url) {
        return;
    }
    
    _urlAsset = [AVURLAsset assetWithURL:video_url];
    _playerItem = [AVPlayerItem playerItemWithAsset:_urlAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.bounds;
    
    
    [ZNNoteCenter addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self addSublayer:_playerLayer];
    
    if (_player.currentItem) {
        [_player play];
    }
    
    
}

- (void)setVideo_url:(NSURL *)video_url{
    _video_url = video_url;
    [self configurePlayInfoWithVideoURL:video_url];
    
}



//初始化配置

- (void)resetConfigure{
    if (_player) {
        MyLog(@"重置配置");
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
        [ZNNoteCenter removeObserver:self];
        [_player pause];
        _urlAsset = nil;
        _playerItem = nil;
        _player = nil;
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
}



//播放完毕
- (void)videoPlayEnd:(NSNotification *)not{
    
    if (_player) {
        
        [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            if (finished) {
                [_player play];
            }
        }];

    }
    
}



- (void)removeFromSuperlayer{
    [self resetConfigure];
    MyLog(@"从父图层移除");
    [super removeFromSuperlayer];
}



- (void)dealloc{
    [self resetConfigure];
    MyLog(@"播放层销毁");
    
}




@end
