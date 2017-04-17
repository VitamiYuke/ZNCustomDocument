//
//  ZNLivePlayListController.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/8.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNLivePlayListController.h"
#import "ZNLiveCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "ZNLiveItem.h"
#import "ZNCreatorItem.h"
#import "ZNLivePlayController.h"
#import "ZFPlayer.h"
static NSString *const ID = @"LiveListCell";
@interface ZNLivePlayListController ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
@property(nonatomic, strong)NSMutableArray *lives;
@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) ZFPlayerView   *playerView;
@property (nonatomic, strong) ZFPlayerModel  *playerModel;
@end

@implementation ZNLivePlayListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"直播列表";
    [self configrueUI];
    [self loadingData];
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

- (void)configrueUI
{
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, NORMAL_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerNib:[UINib nibWithNibName:@"ZNLiveCell" bundle:nil] forCellReuseIdentifier:ID];
    }
    return _tableView;
}

- (void)loadingData
{
    // 映客数据url
    NSString *urlStr = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    //请求数据
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [mgr GET:urlStr parameters:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"返回结果:%@",responseObject);
        _lives = [ZNLiveItem mj_objectArrayWithKeyValuesArray:responseObject[@"lives"]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"错误饿:%@",error);
    }];
    
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lives.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZNLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    ZNLiveItem *live = _lives[indexPath.row];
    cell.live = live;
    __block NSIndexPath *weakIndexPath = indexPath;
    __block ZNLiveCell *weakCell     = cell;
    __weak typeof(self) weakSelf       = self;
    // 点击播放的回调
    cell.playBlock = ^(UIButton *btn){
        
        // 分辨率字典（key:分辨率名称，value：分辨率url)
        NSMutableDictionary *dic = @{}.mutableCopy;
//        for (ZFVideoResolution * resolution in model.playInfo) {
//            [dic setValue:resolution.url forKey:resolution.name];
//        }
        // 取出字典中的第一视频URL
        NSURL *videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/14571455324031.mp4"];
        
        weakSelf.playerModel = [[ZFPlayerModel alloc] init];
        weakSelf.playerModel.title            = @"666666666";
        weakSelf.playerModel.videoURL         = videoURL;
        weakSelf.playerModel.placeholderImageURLString = [NSString stringWithFormat:@"http://img.meelive.cn/%@",live.creator.portrait];
        weakSelf.playerModel.tableView        = weakSelf.tableView;
        weakSelf.playerModel.indexPath        = weakIndexPath;
        // 赋值分辨率字典
        weakSelf.playerModel.resolutionDic    = dic;
        // (需要设置imageView的tag值，此处设置的为101)
        weakSelf.playerModel.cellImageViewTag = weakCell.bigPicView.tag;
        
        // 设置播放model
        weakSelf.playerView.playerModel = weakSelf.playerModel;
        
        [weakSelf.playerView addPlayerToCellImageView:weakCell.bigPicView];
        
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // weakSelf.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 自动播放
        [weakSelf.playerView autoPlayTheVideo];
    };
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZNLivePlayController *liveVc = [[ZNLivePlayController alloc] init];
    liveVc.live = _lives[indexPath.row];
    [self presentViewController:liveVc animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 430;
}


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

#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url
{
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
    MyLog(@"地址:%@",name);
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ZFPlayerView sharedPlayerView] resetPlayer];
}


@end
