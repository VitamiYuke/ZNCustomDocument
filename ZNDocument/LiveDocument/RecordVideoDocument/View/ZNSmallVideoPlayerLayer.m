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

@property(nonatomic, strong)AVPlayerItem *currentPlayerItem;

@end

@implementation ZNSmallVideoPlayerLayer{
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVURLAsset *_urlAsset;
    AVAssetImageGenerator *_imageGenerator;
    AVPlayerLayer *_playerLayer;
}



- (void)configurePlayInfoWithVideoURL:(NSURL *)video_url{
    
    [self resetConfigure];
    
    if (!video_url) {
        return;
    }
    _urlAsset = [AVURLAsset assetWithURL:video_url];
    _playerItem = [AVPlayerItem playerItemWithAsset:_urlAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.bounds;
    
    
    if (_playerItem) {
        self.currentPlayerItem = _playerItem;
    }
    
    
    [self addSublayer:_playerLayer];
    
    if (_player.currentItem) {
        [_player play];
    }
    
}

- (void)setVideo_url:(NSURL *)video_url{
    _video_url = video_url;
    [self configurePlayInfoWithVideoURL:video_url];
    
}


- (void)setCurrentPlayerItem:(AVPlayerItem *)currentPlayerItem{
    
    if (_currentPlayerItem == currentPlayerItem) {
        return;
    }
    
    if (_currentPlayerItem) {
        [_currentPlayerItem removeObserver:self forKeyPath:@"status"];
        [ZNNoteCenter removeObserver:self];
    }
    _currentPlayerItem = currentPlayerItem;
    
    if (currentPlayerItem) {
        [ZNNoteCenter addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
       [currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    if (object == self.currentPlayerItem) {
        
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.currentPlayerItem.status == AVPlayerItemStatusReadyToPlay) {
                MyLog(@"将要开始播放");
                if (self.prepareToPlay) {
                    self.prepareToPlay();
                }
                
            }
            
        }
        
        
    }
    
}



//初始化配置

- (void)resetConfigure{
    if (_player) {
        MyLog(@"重置配置");
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
        [_player pause];
        _urlAsset = nil;
        _playerItem = nil;
        _player = nil;
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
        self.currentPlayerItem = nil;
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


- (void)pausePlay{
    if (_player) {
        [_player pause];
    }
}


- (void)play{
    if (_player) {
        [_player play];
    }
}



@end
