//
//  ZNRecordVideoEditController.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/9.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNRecordVideoEditController.h"
#import "ZNSmallVideoPlayerLayer.h"
#import "ZNVideoEditNavView.h"
@interface ZNRecordVideoEditController ()


@property(nonatomic, strong)ZNSmallVideoPlayerLayer *playLayer;

@property(nonatomic, strong)ZNVideoEditNavView *navView;


@end

@implementation ZNRecordVideoEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUI];
    [self configureGesture];
    [self performSelector:@selector(autoFade) withObject:nil afterDelay:2];
    self.playLayer.video_url = self.video_url;
}

- (ZNVideoEditNavView *)navView{
    if (!_navView) {
        _navView = [ZNVideoEditNavView defaultVideoNav];
        
        if (self.deleteFinish) {
            _navView.deleteVideoAction = self.deleteFinish;
        }
        
    }
    return _navView;
}

- (ZNSmallVideoPlayerLayer *)playLayer{
    if (!_playLayer) {
        _playLayer = [ZNSmallVideoPlayerLayer layer];
        _playLayer.frame = self.view.bounds;
    }
    return _playLayer;
}


- (void)configureUI{
    [self.view.layer addSublayer:self.playLayer];
    [self.view addSubview:self.navView];
}


- (void)configureGesture{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAndFade)]];
}


- (void)showAndFade{
    if (self.navView.height) {
        [self.navView hiddenAnimation];
    }else{
        [self.navView showAnimation];
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (self.playLayer) {
        [self.playLayer play];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.navView restConfigureBecauseOfControllerWillDisappear];
    [self.playLayer pausePlay];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


- (void)autoFade{
    if (self.navView.height) {
        [self.navView hiddenAnimation];
    }
}




@end
