//
//  ZNLiveTestController.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/7.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNLiveTestController.h"
#import "ZNLivePlayListController.h"
#import "ZNLiveCollectionController.h"
//#import "ZNVideoPlayer.h"
#import "ZNAVPlayerView.h"
#import "ZNVideoPlayerController.h"
#import "ZNPlayerView.h"
#import "ZNRecordVideoController.h"
#import <ReplayKit/ReplayKit.h>
@interface ZNLiveTestController ()<RPPreviewViewControllerDelegate>
//@property(nonatomic, strong)ZNAVPlayerView *plaver;

@end

@implementation ZNLiveTestController

#pragma mark --- 全凭录制

- (void)startScreenRecord{
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        [MBProgressHUD showError:@"9.0以下系统不支持"];
        return;
    }
    
    
    if (![[RPScreenRecorder sharedRecorder] isAvailable]) {
        MyLog(@"不支持ReplayKit录制");
    }
    
    [MBProgressHUD showMessage:@"正在初始化录制设置~"];
    
    [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:NO handler:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUD];
        
        if (error) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"配置错误:%@",[error localizedDescription]]];
        }else{
            [MBProgressHUD showSuccess:@"开始录制~"];
        }
        
    }];
    
    
    
    
}

- (void)endScreenRecord{
    
    znWeakSelf(self);
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        if (error) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"停止错误:%@",[error localizedDescription]]];
        }else{
            previewViewController.previewControllerDelegate = weakSelf;
            
            [self presentViewController:previewViewController animated:YES completion:NULL];
            
        }
    }];
    
}


#pragma mark - 预览回调
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController
{
    [previewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet<NSString *> *)activityTypes
{
    MyLog(@"活跃的类型:%@",activityTypes);
    
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        [MBProgressHUD showSuccess:@"保存到相册成功"];
    }
    
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.CopyToPasteboard"]) {
        [MBProgressHUD showSuccess:@"复制到粘贴板成功"];
    }
    
}





#pragma mark -----

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    ZNTestButton *playBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(50, 50, 100, 50) title:@"直播列表" action:^{
        [weakSelf.navigationController pushViewController:[[ZNLivePlayListController alloc] init] animated:YES];
    }];
    [self.view addSubview:playBtn];
    
    
    ZNTestButton *collectionBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(200, 50, 100, 50) title:@"直播" action:^{
        [weakSelf.navigationController pushViewController:[[ZNLiveCollectionController alloc] init] animated:YES];
    }];
    [self.view addSubview:collectionBtn];
    
  

    
//    ZNVideoPlayer *palyView = [[ZNVideoPlayer alloc] initWithFrame:CGRectMake(0, 220, SCREENT_WIDTH, 250) andUrl:@"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4"];
//    [palyView prepareToPlayMovie];
//    [self.view addSubview:palyView];
//    

    
//    ZNAVPlayerView *sysPlayer= [[ZNAVPlayerView alloc] initWithFrame:CGRectMake(0, 220, SCREENT_WIDTH, 211) withUrlString:@"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4"];
//    [sysPlayer prepareToPlayMovie];
//    _plaver = sysPlayer;
    
    ZNTestButton *playUrlBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(50, 150, 100, 50) title:@"播放连接" action:^{
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"keep.mp4" ofType:nil];
//        NSURL *url = [NSURL fileURLWithPath:path];
//        [weakPalyer changePlayNewMovieWithUrl:url];
        [weakSelf.navigationController pushViewController:[[ZNVideoPlayerController alloc] init] animated:YES];
//        [weakSelf presentViewController:[[ZNVideoPlayerController alloc] init] animated:YES completion:^{
//            
//        }];
    }];
    [self.view addSubview:playUrlBtn];
    
//    [self.view addSubview:sysPlayer];
    
//    ZNPlayerView *playerView = [[ZNPlayerView alloc] initWithFrame:CGRectMake(0, 210, SCREENT_WIDTH, 211)];
//    ZNPlayItem *playerItem = [[ZNPlayItem alloc] init];
//    playerItem.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4"];
//    playerItem.title = @"这个很666677";
//    playerView.playerModel = playerItem;
//    [playerView autoPlayTheVideo];
//    [self.view addSubview:playerView];
    
    
    ZNTestButton *recordVideoBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(200, 150, 100, 50) title:@"录制" action:^{
        [weakSelf presentViewController:[[ZNRecordVideoController alloc] init] animated:YES completion:NULL];
        
    }];
    [self.view addSubview:recordVideoBtn];
    
    
    ZNTestButton *recordScreenVideoBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(50, 250, 100, 50) title:@"全屏录制" action:^{
        [weakSelf startScreenRecord];
    }];
    [self.view addSubview:recordScreenVideoBtn];
    
    
    ZNTestButton *stopRecordVideoBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(200, 250, 100, 50) title:@"停止录制" action:^{
        [weakSelf endScreenRecord];
        
    }];
    [self.view addSubview:stopRecordVideoBtn];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.plaver pausePlayMovie];
    
}

- (void)dealloc
{
//    [self.plaver removeSelfTimerAndReleaseSelf];
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



/**
 * 默认所有都不支持转屏,如需个别页面支持除竖屏外的其他方向，请在viewController重新下边这三个方法
 */

// 是否支持自动转屏
- (BOOL)shouldAutorotate
{
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}



@end
