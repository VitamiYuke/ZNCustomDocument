//
//  ZNVideoPlayer.h
//  ZNDocument
//
//  Created by 张楠 on 16/11/9.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNVideoPlayer : UIView


- (instancetype)initWithFrame:(CGRect)frame andUrl:(NSString *)playUrl;



- (void)changeNewVideoWithUrl:(NSString *)newPlayUrl;

// 添加播放 和取消播放的通知
- (void)addRegisteSelfrMovieNotificationObservers;
- (void)removeSelfMovieNotificationObservers;

// 准备去播放
- (void)prepareToPlayMovie;



@end
