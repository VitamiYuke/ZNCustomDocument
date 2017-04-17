//
//  ZNAVPlayerView.h
//  ZNDocument
//
//  Created by 张楠 on 16/11/10.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNAVPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSURL *)url;
- (instancetype)initWithFrame:(CGRect)frame withUrlString:(NSString *)urlString;

// 播放
- (void)prepareToPlayMovie;
//暂停
- (void)pausePlayMovie;

- (void)changePlayNewMovieWithUrl:(NSURL *)url;


/*释放自己  在viewwillDisApper中调用 必须*/

-(void)removeSelfTimerAndReleaseSelf;

@end
