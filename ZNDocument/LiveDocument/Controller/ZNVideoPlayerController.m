//
//  ZNVideoPlayerController.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/14.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNVideoPlayerController.h"
#import "ZFPlayer.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface ZNVideoPlayerController ()<ZFPlayerDelegate,UITableViewDelegate,UITableViewDataSource>

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property(nonatomic, strong)ZFPlayerModel *playerModel;
@property(nonatomic, strong)ZFPlayerView *playerView;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIView *headerView;

@property(nonatomic, strong)UIView *statusView;

@end

@implementation ZNVideoPlayerController

- (ZFPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
        _playerView.controlView = controlView;
        // 下载功能
        _playerView.hasDownload = YES;
    }
    return _playerView;
}

- (ZFPlayerModel *)playerModel
{
    if (!_playerModel) {
        _playerModel = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"啦啦啦啦啊啦啦啦啦";
        _playerModel.videoURL         = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4"];
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
    }
    return _playerModel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
//        [_tableView setTableHeaderView:self.headerView];
        
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor yellowColor];
    }
    return _headerView;
}


- (UIView *)statusView
{
    if (!_statusView) {
        _statusView =[[UIView alloc] init];
        _statusView.backgroundColor = [UIColor blackColor];
    }
    return _statusView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    
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

#pragma mark - 转屏相关

// 是否支持自动转屏
- (BOOL)shouldAutorotate
{
    // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
    return !ZFPlayerShared.isLockScreen;
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.fd_interactivePopDisabled = NO;
        //if use Masonry,Please open this annotation
    
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(20);
         }];
         
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        self.fd_interactivePopDisabled = YES;
        //if use Masonry,Please open this annotation
        
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(0);
         }];
         
    }
}


- (void)zf_playerBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zf_playerDownload:(NSString *)url
{
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
    MyLog(@"下载的URL:%@",name);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerView pause];
    }
}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"indentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"这是第:%ld各",indexPath.row];
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


@end
