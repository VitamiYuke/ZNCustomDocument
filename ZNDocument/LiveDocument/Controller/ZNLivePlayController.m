//
//  ZNLivePlayController.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/7.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNLivePlayController.h"
//#import <IJKMediaFramework/IJKMediaFramework.h>
#import "ZNLiveItem.h"
#import "ZNCreatorItem.h"
@interface ZNLivePlayController ()
@property(nonatomic, strong)UIImageView *placeholderImg;
//@property(nonatomic, strong)IJKFFMoviePlayerController *player;
@end

@implementation ZNLivePlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUI];
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

- (UIImageView *)placeholderImg
{
    if (!_placeholderImg) {
        _placeholderImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, SCREENT_HEIGHT)];
        _placeholderImg.contentMode = UIViewContentModeScaleAspectFill;
        [_placeholderImg.layer setMasksToBounds:YES];
        [self.view addSubview:_placeholderImg];
    }
    return _placeholderImg;
}


- (void)configureUI
{
    
    // 设置直播占位图片
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",_live.creator.portrait]];
    [self.placeholderImg sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    __weak typeof(self) weakSelf = self;
    ZNTestButton *callBackBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(20, 20, 30, 15) title:@"..." action:^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    callBackBtn.backgroundColor = [UIColor clearColor];
    [callBackBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:callBackBtn];
    
    // 拉流地址
//    NSURL *url = [NSURL URLWithString:_live.stream_addr];
//    // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
//    IJKFFMoviePlayerController *playerVC = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
//    // 准备播放
//    [playerVC prepareToPlay];
//    // 强引用，反正被销毁
//    _player = playerVC;
//    playerVC.view.frame = [UIScreen mainScreen].bounds;
//    [self.view insertSubview:playerVC.view atIndex:1];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 界面消失，一定要记得停止播放
//    [_player pause];
//    [_player stop];
//    [_player shutdown];
    
}



@end
