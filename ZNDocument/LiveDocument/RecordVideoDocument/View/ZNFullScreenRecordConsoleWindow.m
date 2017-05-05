//
//  ZNFullScreenRecordConsoleWindow.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/4.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNFullScreenRecordConsoleWindow.h"
#import <ReplayKit/ReplayKit.h>
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

#define MAX_HEIGHT (150)
#define MIN_HEIGHT (55)
#define WIDTH_2 (WIDTH/2)
#define RECORDING_HEIGHT (80)


static ZNFullScreenRecordConsoleWindow *_consoleWindow = nil;

static NSInteger recordTimeSecond = 0;

@interface ZNFullScreenRecordConsoleWindow ()<NSCopying,NSMutableCopying,RPPreviewViewControllerDelegate>

@property(nonatomic, strong)UIPanGestureRecognizer *locationChangePan;


@property(nonatomic, strong)UIButton *menuBtn;
@property(nonatomic, strong)UIButton *recordBtn;
@property(nonatomic, strong)UIButton *mineBtn;
@property(nonatomic, strong)UIButton *stopRecordBtn;
@property(nonatomic, strong)UIButton *closeMenuBtn;
@property(nonatomic, strong)UILabel *recordTimeLabel;


@end


@implementation ZNFullScreenRecordConsoleWindow{
    BOOL _isShowMenu;//是否展开了菜单
    BOOL _isConfiguringRecord;//是否正在配置
}

#pragma mark - 单例
+ (instancetype)shareZNFullScreenRecordConsoleWindow{
    
    return [[self alloc] init];
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _consoleWindow = [super allocWithZone:zone];
//    });
    
    @synchronized (self) {
        if (_consoleWindow == nil) {
            _consoleWindow = [super allocWithZone:zone];
        }
    }
    
    
    return _consoleWindow;
}



- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _consoleWindow = [super init];
        [_consoleWindow configureBasedInfo];
        [_consoleWindow configureGesture];
    });
    return _consoleWindow;
}


- (id)copyWithZone:(NSZone *)zone{
    return _consoleWindow;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _consoleWindow;
}



#pragma mark ----

- (void)configureBasedInfo{
    
    _isShowMenu = NO;
    _isConfiguringRecord = NO;
    self.frame = CGRectMake(SCREENT_WIDTH/2 - 55/2, SCREENT_HEIGHT - 55 - 120, 55, 55);;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.hidden = YES;
    self.windowLevel = UIWindowLevelAlert + 1;
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:27.5];
    
    
    [self configureUI];
}


- (void)showMenu{
    self.hidden = NO;
}

- (void)dismissMenu{
    self.hidden = YES;
}


#pragma mark -- 手势

- (void)configureGesture{
    [self addGestureRecognizer:self.locationChangePan];
}


- (UIPanGestureRecognizer *)locationChangePan{
    if (!_locationChangePan) {
        _locationChangePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selfLocationChangeAction:)];
    }
    return _locationChangePan;
}

- (void)selfLocationChangeAction:(UIPanGestureRecognizer *)sender{
    
    
    if (_isConfiguringRecord) {
        return;
    }
    
    
    if (_isShowMenu) {
        MyLog(@"打开状态就被移动了");
        return;
    }
    
    
    CGPoint touchPoint = [sender locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    if (touchPoint.x - self.width/2 < 0 || touchPoint.x + self.width/2 > SCREENT_WIDTH || touchPoint.y - self.height/2 < 0 || touchPoint.y + self.height/2 > SCREENT_HEIGHT) {
        MyLog(@"坐标超出");
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.center = touchPoint;
    }
}

#pragma mark - 布局

- (void)configureUI{
    [self addSubview:self.menuBtn];
    [self addSubview:self.recordBtn];
    [self addSubview:self.mineBtn];
    [self addSubview:self.stopRecordBtn];
    [self addSubview:self.closeMenuBtn];
    [self addSubview:self.recordTimeLabel];
    
}

- (UILabel *)recordTimeLabel{
    if (!_recordTimeLabel) {
        _recordTimeLabel = [[UILabel alloc] init];
        _recordTimeLabel.textAlignment = NSTextAlignmentCenter;
        _recordTimeLabel.font = MyFont(11);
        _recordTimeLabel.textColor = [UIColor whiteColor];
        _recordTimeLabel.frame = CGRectMake(0, MIN_HEIGHT + 5, WIDTH, 18);
        _recordTimeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_recordTimeLabel.layer setMasksToBounds:YES];
        [_recordTimeLabel.layer setCornerRadius:9];
        _recordTimeLabel.text = @"00:00";
        _recordTimeLabel.hidden = YES;
        
    }
    return _recordTimeLabel;
}


- (UIButton *)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtn.backgroundColor = [UIColor clearColor];
        [_menuBtn setImage:[UIImage imageNamed:@"lp_kkaiqiluping"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(openTheMenu) forControlEvents:UIControlEventTouchUpInside];
        _menuBtn.frame = CGRectMake(0, 0, WIDTH, MIN_HEIGHT);
    }
    return _menuBtn;
}



- (UIButton *)mineBtn{
    if (!_mineBtn) {
        _mineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mineBtn.backgroundColor = [UIColor clearColor];
        [_mineBtn setImage:[UIImage imageNamed:@"lp_wode"] forState:UIControlStateNormal];
        _mineBtn.titleLabel.font = MyFont(12);
        [_mineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mineBtn setTitle:@"我的" forState:UIControlStateNormal];
        _mineBtn.hidden = YES;
        _mineBtn.frame = CGRectMake(0, MAX_HEIGHT - 12 - 50, WIDTH, 50);
        [_mineBtn setImageEdgeInsets:UIEdgeInsetsMake(0, WIDTH_2 - 15, 20, 0)];
        [_mineBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -15, 0, 15)];
        [_mineBtn addTarget:self action:@selector(gotoMineAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _mineBtn;
}

- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.backgroundColor = [UIColor clearColor];
        [_recordBtn setImage:[UIImage imageNamed:@"lp_luzhi"] forState:UIControlStateNormal];
        _recordBtn.titleLabel.font = MyFont(12);
        [_recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recordBtn setTitle:@"录制" forState:UIControlStateNormal];
        _recordBtn.hidden = YES;
        _recordBtn.frame = CGRectMake(0, MAX_HEIGHT - (12 + 50) - (50 + 10), WIDTH, 50);
        [_recordBtn setImageEdgeInsets:UIEdgeInsetsMake(0, WIDTH_2 - 15, 20, 0)];
        [_recordBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -15, 0, 15)];
        [_recordBtn addTarget:self action:@selector(startRecordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UIButton *)stopRecordBtn{
    if (!_stopRecordBtn) {
        _stopRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopRecordBtn.backgroundColor = [UIColor clearColor];
        [_stopRecordBtn setImage:[UIImage imageNamed:@"lp_luzhizhong"] forState:UIControlStateNormal];
        _stopRecordBtn.hidden  = YES;
        _stopRecordBtn.frame = CGRectMake(0, 0, WIDTH, MIN_HEIGHT);
        [_stopRecordBtn addTarget:self action:@selector(stopRecordAction) forControlEvents:UIControlEventTouchUpInside];
        
        _stopRecordBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_stopRecordBtn.layer setMasksToBounds:YES];
        [_stopRecordBtn.layer setCornerRadius:27.5];
        
        
        
    }
    return _stopRecordBtn;
}

- (UIButton *)closeMenuBtn{
    if (!_closeMenuBtn) {
        _closeMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeMenuBtn.backgroundColor = [UIColor redColor];
        [_closeMenuBtn addTarget:self action:@selector(closeMenuAction) forControlEvents:UIControlEventTouchUpInside];
        _closeMenuBtn.hidden = YES;
        _closeMenuBtn.frame = CGRectMake(0, 0, WIDTH, 25);
  
    }
    return _closeMenuBtn;
}



//打开菜单
- (void)openTheMenu{
    
    if (_isConfiguringRecord) {
        return;
    }

    _isShowMenu = YES;
    [self openMenuConfigure];
    [UIView animateWithDuration:0.3 animations:^{
        self.height = 150;
    } completion:^(BOOL finished) {
        if (finished) {
            if (CGRectGetMaxY(self.frame) > SCREENT_HEIGHT) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.y = SCREENT_HEIGHT - self.height - 12;
                }];
            }
        }
    }];

}
//关闭菜单
- (void)closeMenuAction{
    
    if (_isConfiguringRecord) {
        return;
    }
    
    _isShowMenu = NO;
    [self closeMenuConfigure];
    [UIView animateWithDuration:0.3 animations:^{
        self.height = 55;
    }];
    
    
}

- (void)openMenuConfigure{
    self.menuBtn.hidden = YES;
    self.recordBtn.hidden = NO;
    self.mineBtn.hidden = NO;
    self.closeMenuBtn.hidden = NO;
}

- (void)closeMenuConfigure{
    self.menuBtn.hidden = NO;
    self.recordBtn.hidden = YES;
    self.mineBtn.hidden = YES;
    self.closeMenuBtn.hidden = YES;

}


- (void)startRecordConfigure{
    self.menuBtn.hidden = YES;
    self.recordBtn.hidden = YES;
    self.mineBtn.hidden = YES;
    self.closeMenuBtn.hidden = YES;
    self.stopRecordBtn.hidden = NO;
    self.recordTimeLabel.hidden = NO;
    _isShowMenu = NO;
    self.backgroundColor = [UIColor clearColor];
    [self.layer setCornerRadius:0];
    
}

- (void)stopRecordConfigure{
    self.menuBtn.hidden = NO;
    self.stopRecordBtn.hidden = YES;
    self.recordTimeLabel.hidden = YES;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.layer setCornerRadius:27.5];
}

#pragma mark - 方法
- (void)gotoMineAction{
    MyLog(@"去我的");
    
    if (_isConfiguringRecord) {
        return;
    }
    
}

- (void)startRecordAction{
    MyLog(@"开始录制");
    
    [MBProgressHUD showMessage:@"正在配置录制信息"];
    [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [MBProgressHUD showError:[error localizedDescription]];
        }else{
            [self startRecordConfigure];
            [UIView animateWithDuration:0.3 animations:^{
                self.height = RECORDING_HEIGHT;
            }];
            [self recordTimeCircle];
        }
    }];
    
 
}

- (void)stopRecordAction{
    
    
    znWeakSelf(self);
    [self stopRecordTimeCount];
    self.recordTimeLabel.text = @"处理中...";
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        if (error) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"停止错误:%@",[error localizedDescription]]];
        }else{
            previewViewController.previewControllerDelegate = weakSelf;
            [[ZNRegularHelp getCurrentShowViewController] presentViewController:previewViewController animated:YES completion:NULL];
            [self stopRecordConfigure];
            self.height = MIN_HEIGHT;
        }
    }];
    
    
}

- (void)dealloc{
    MyLog(@"销毁录制菜单");
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


- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController
{
     [previewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 设置计时
- (void)recordTimeCircle{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordTimeCircle) object:nil];
    NSInteger hour = recordTimeSecond / 60;
    NSInteger second = recordTimeSecond % 60;
    self.recordTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld",hour,second];
    recordTimeSecond ++;
    [self performSelector:@selector(recordTimeCircle) withObject:nil afterDelay:1];
}

//停止计时
- (void)stopRecordTimeCount{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordTimeCircle) object:nil];
    recordTimeSecond = 0;
}








@end
