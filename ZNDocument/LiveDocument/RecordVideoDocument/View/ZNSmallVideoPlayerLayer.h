//
//  ZNSmallVideoPlayerLayer.h
//  ZNDocument
//
//  Created by 张楠 on 2017/5/4.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ZNSmallVideoPlayerLayer : CALayer


@property(nonatomic, nullable, strong)NSURL *video_url;


- (void)pausePlay;
- (void)play;


@property(nonatomic, copy)void(^ _Nullable prepareToPlay)(void);





@end
