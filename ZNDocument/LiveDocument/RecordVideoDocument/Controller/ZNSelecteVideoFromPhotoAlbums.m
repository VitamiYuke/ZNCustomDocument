//
//  ZNSelecteVideoFromPhotoAlbums.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/23.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNSelecteVideoFromPhotoAlbums.h"
#import "ZNRecordVideoToolManager.h"
#import "ZLDefine.h"
#import "ZLPhotoTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZLSelectPhotoModel.h"
@interface ZNSelecteVideoFromPhotoAlbums (){

    
    //底部view
    UIView   *_bottomView;
    UIButton *_btnDone;
    BOOL _isPlay;
    
}


@property(nonatomic, strong)UITapGestureRecognizer *tapGesture;


@property(nonatomic, strong)UIImageView *coverIcon;

@property(nonatomic, strong)NSURL *video_url;


@property(nonatomic, strong)MPMoviePlayerController *playerController;


@end

@implementation ZNSelecteVideoFromPhotoAlbums


- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
    }
    return _tapGesture;
}


- (UIImageView *)coverIcon{
    if (!_coverIcon) {
        _coverIcon = [[UIImageView alloc] init];
        _coverIcon.userInteractionEnabled = YES;
    }
    return _coverIcon;
}


- (MPMoviePlayerController *)playerController{
    if (!_playerController) {
        _playerController = [[MPMoviePlayerController alloc] init];
        _playerController.view.frame = self.view.bounds;
        _playerController.controlStyle = MPMovieControlStyleNone;
        _playerController.repeatMode = MPMovieRepeatModeNone;
    }
    return _playerController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isPlay = NO;
    
    [self.view addSubview:self.playerController.view];
    
    [self.view addGestureRecognizer:self.tapGesture];
    
    [self.view addSubview:self.coverIcon];
    [self.coverIcon autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    

    [self configureNot];
    
    
    [self initNavBtns];
    [self initBottomView];
    
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(SCREENT_WIDTH*scale, SCREENT_HEIGHT*scale);
    
    [[ZLPhotoTool sharePhotoTool] requestImageForAsset:self.asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        
        MyLog(@"请求的照片:%@",image);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.coverIcon.image = image;
        });
        
    }];
    
    
    [ZNRecordVideoToolManager configurePhotoVideoWithPHAsset:self.asset complete:^(NSURL *url) {
        MyLog(@"视频的地址链接:%@",url);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.video_url = url;
            [self.playerController setContentURL:self.video_url];
        });
    }];
}


- (void)initNavBtns
{
    //left nav btn
    UIImage *navBackImg = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"navBackBtn.png")]?:[UIImage imageNamed:kZLPhotoBrowserFrameworkSrcName(@"navBackBtn.png")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[navBackImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(btnBack_Click)];
    

}

- (void)btnBack_Click{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, kViewWidth, 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDone.frame = CGRectMake(kViewWidth - 82, 7, 70, 30);
    [_btnDone setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserDoneText) forState:UIControlStateNormal];
    _btnDone.titleLabel.font = [UIFont systemFontOfSize:15];
    _btnDone.layer.masksToBounds = YES;
    _btnDone.layer.cornerRadius = 3.0f;
    [_btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnDone setBackgroundColor:kRGB(80, 180, 234)];
    [_btnDone addTarget:self action:@selector(btnDone_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnDone];
    
    [self.view addSubview:_bottomView];
}


- (void)btnDone_Click:(UIButton *)btn
{
    MyLog(@"选择好了视频");
    
    if (self.DoneBlock) {
        ZLSelectPhotoModel *photoModel = [[ZLSelectPhotoModel alloc] init];
        photoModel.asset = self.asset;
        photoModel.localIdentifier = self.video_url.absoluteString;
        self.DoneBlock(@[photoModel], NO);
    }
    
    
}


- (void)showNavBarAndBottomView
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    CGRect frame = _bottomView.frame;
    frame.origin.y -= frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = frame;
    }];
}

- (void)hideNavBarAndBottomView
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    CGRect frame = _bottomView.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = frame;
    }];
}


- (void)playOrPause{
    
    if (!self.video_url) {
        MyLog(@"还没有视频地址点个毛细");
        return;
    }
    
    _isPlay = !_isPlay;
    if (_isPlay) {
        [self.playerController play];
        [self hideNavBarAndBottomView];
    }else{
        [self.playerController pause];
        [self showNavBarAndBottomView];
    }
    
    
}


- (void)configureNot{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)playStateChange:(NSNotification *)sender{
    switch (self.playerController.playbackState) {
        case MPMoviePlaybackStatePlaying:
            MyLog(@"正在播放...");
            self.coverIcon.hidden = YES;
            break;
        case MPMoviePlaybackStatePaused:
            MyLog(@"暂停播放.");
            self.coverIcon.hidden = NO;
            break;
        case MPMoviePlaybackStateStopped:
            MyLog(@"停止播放.");
            self.coverIcon.hidden = NO;
            break;
        default:
            NSLog(@"播放状态:%li",self.playerController.playbackState);
            break;
    }
}

- (void)playEnd:(NSNotification *)sender{
    MyLog(@"播放完毕");
    _isPlay = NO;
    [self showNavBarAndBottomView];
    
}




- (void)dealloc{
    MyLog(@"销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
