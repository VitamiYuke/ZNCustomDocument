//
//  ZNPlayerView.h
//  ZNDocument
//
//  Created by 张楠 on 16/11/16.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNPlayerController.h"
// playerLayer的填充模式（默认：等比例填充，直到一个维度到达区域边界）
typedef NS_ENUM(NSInteger, ZNPlayerLayerGravity) {
    ZNPlayerLayerGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
    ZNPlayerLayerGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
    ZNPlayerLayerGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};

@interface ZNPlayerView : UIView
/** 视频model */
@property(nonatomic, strong)ZNPlayItem *playerModel;
/** 设置playerLayer的填充模式 */
@property (nonatomic, assign) ZNPlayerLayerGravity    playerLayerGravity;
/** 是否有下载功能(默认是关闭) */
@property (nonatomic, assign) BOOL                    hasDownload;
/** 是否开启预览图 */
@property (nonatomic, assign) BOOL                    hasPreviewView;
/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo;

/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZFPlayer
 */
+ (instancetype)sharedPlayerView;

/**
 *  player添加到cell上
 *
 *  @param cell 添加player的cellImageView
 */
- (void)addPlayerToCellImageView:(UIImageView *)imageView;
/**
 *  重置player
 */
- (void)resetPlayer;
/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;
/**
 * 返回的时间处理
 */
@property(nonatomic, copy)void(^goBackAction)(void);
@end
