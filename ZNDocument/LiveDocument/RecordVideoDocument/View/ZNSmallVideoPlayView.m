//
//  ZNSmallVideoPlayView.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/8.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNSmallVideoPlayView.h"
#import "ZNSmallVideoPlayerLayer.h"


@interface ZNSmallVideoPlayView ()

@property(nonatomic, strong)ZNSmallVideoPlayerLayer *playLayer;

@property(nonatomic, weak)UIImageView *sourceImageView;
@property(nonatomic, strong)NSURL *videoUrl;


@property(nonatomic, strong)UIImageView *showImageView;

@end


@implementation ZNSmallVideoPlayView


- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
    }
    return _showImageView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configureUI];
        [self addGesture];
    }
    return self;
}


- (void)configureUI{
    
    self.backgroundColor = [UIColor blackColor];
    [self.layer addSublayer:self.playLayer];
    
}


- (ZNSmallVideoPlayerLayer *)playLayer{
    if (!_playLayer) {
        _playLayer = [ZNSmallVideoPlayerLayer layer];
        _playLayer.frame = self.bounds;
        znWeakSelf(self);
        _playLayer.prepareToPlay = ^{
            [weakSelf aotuRemoveFromSuperSelf];
        };
        
    }
    return _playLayer;
}


- (void)setVideoUrl:(NSURL *)videoUrl{
    _videoUrl = videoUrl;
//    self.playLayer.video_url = videoUrl;
    
}


- (void)addGesture{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeFromSuper)]];
}

- (void)fadeFromSuper{
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.playLayer.video_url = nil;
    self.backgroundColor = [UIColor clearColor];
    
    if (self.sourceImageView.superview) {
        MyLog(@"转换前布局:%@",NSStringFromCGRect(self.sourceImageView.frame));
        CGRect tempRect = [self.sourceImageView.superview convertRect:self.sourceImageView.frame toView:self];
        MyLog(@"转换后:%@",NSStringFromCGRect(tempRect));
        UIImageView *tempView = [[UIImageView alloc] init];
        if (self.sourceImageView.image) {
            tempView.image = self.sourceImageView.image;
        }
        tempView.frame = self.bounds;
        tempView.center = self.center;
        [self addSubview:tempView];
        
        [UIView animateWithDuration:0.4 animations:^{
            tempView.frame = tempRect;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }else{
        [self removeFromSuperview];
    }
    
}



+ (void)showWithVideoUrl:(NSURL *)videoUrl sourceImageView:(UIImageView *)sourceImageView{
    ZNSmallVideoPlayView *playView = [[ZNSmallVideoPlayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    playView.sourceImageView = sourceImageView;
    playView.videoUrl = videoUrl;
    [[[UIApplication sharedApplication] keyWindow] addSubview:playView];
    [playView showPlayView];
}


- (void)showPlayView{
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if (self.sourceImageView.superview) {
        MyLog(@"转换前布局:%@",NSStringFromCGRect(self.sourceImageView.frame));
        CGRect tempRect = [self.sourceImageView.superview convertRect:self.sourceImageView.frame toView:self];
        MyLog(@"转换后:%@",NSStringFromCGRect(tempRect));
        if (self.sourceImageView.image) {
            self.showImageView.image = self.sourceImageView.image;
        }
        self.showImageView.frame = tempRect;
        [self addSubview:self.showImageView];
        [UIView animateWithDuration:0.4 animations:^{
            self.showImageView.frame = self.bounds;
            
        } completion:^(BOOL finished) {
            if (self.videoUrl) {
                self.playLayer.video_url = self.videoUrl;
            }
        }];
        
    }else{
        
        if (self.videoUrl) {
           self.playLayer.video_url = self.videoUrl;
        }
    }
}



//延时销毁
- (void)aotuRemoveFromSuperSelf{
    [self performSelector:@selector(removeAction) withObject:nil afterDelay:1];
}

- (void)removeAction{
    if (self.showImageView.superview) {
        [self.showImageView removeFromSuperview];
    }
}



- (void)dealloc{
    MyLog(@"销毁播放界面");
}




@end
