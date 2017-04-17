//
//  ZNPlayerController.h
//  ZNDocument
//
//  Created by 张楠 on 16/11/16.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNPlayItem.h"
#import "ZNPlayerControllerDelegate.h"

@interface ZNPlayerController : UIView

@property(nonatomic, assign)id<ZNPlayerControllerDelegate>delegate;

/**
 *  取消延时隐藏controlView的方法
 */
- (void)zn_playerCancelAutoFadeOutControlView;
/** 重置ControlView */
- (void)zn_playerResetControlView;
/** 重置分辨率 */
- (void)zn_playerResetControlViewForResolution;
/** 在cell播放 */
- (void)zn_playerCellPlay;
/** 播放进度 */
- (void)zn_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value;
/** 下载按钮状态 */
- (void)zn_playerDownloadBtnState:(BOOL)state;
/**
 *  显示控制层
 */
- (void)zn_playerShowControlView;
/** 播放按钮状态 */
- (void)zn_playerPlayBtnState:(BOOL)state;
/** 锁定屏幕方向按钮状态 */
- (void)zn_playerLockBtnState:(BOOL)state;
/** progress显示缓冲进度 */
- (void)zn_playerSetProgress:(CGFloat)progress;
/** 播放完了 */
- (void)zn_playerPlayEnd;
/** 加载的菊花 */
- (void)zn_playerActivity:(BOOL)animated;
/** 拖拽完毕 */
- (void)zn_playerDraggedEnd;
/** 小屏播放 */
- (void)zn_playerBottomShrinkPlay;
/** 正在播放（隐藏placeholderImageView） */
- (void)zn_playerItemPlaying;
/** 视频加载失败 */
- (void)zn_playerItemStatusFailed:(NSError *)error;
/**
 是否有下载功能
 */
- (void)zn_playerHasDownloadFunction:(BOOL)sender;
/** 设置播放模型 */
- (void)zn_playerModel:(ZNPlayItem *)playerModel;
/**
 是否有切换分辨率功能
 */
- (void)zn_playerResolutionArray:(NSArray *)resolutionArray;
/**
 快进
 */
- (void)zn_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview;
/**
 拖动滑杆
 */
- (void)zn_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image;
@end
