//
//  ZNRecordVideoToolManager.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/19.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZNRecordVideoToolManager : NSObject

- (instancetype)initWithPreviewLayerFrame:(CGRect )frame;

@property(nonatomic, strong, readonly)AVCaptureVideoPreviewLayer *previewLayer;//界面显示

@property(nonatomic, strong, readonly)NSURL *recordFileURL;//录制完毕的视频链接 有值则录制完毕



//启动录制功能
- (void)startRecordFunction;
//关闭录制功能
- (void)stopRecordFunction;
//切换前后摄像头
- (BOOL )transformCameraDirectionWithIsFrontCamera:(BOOL )isFrontCamera;

//开始录制 结束录制
- (void)startRecordVideo;
- (void)endRecordVideo;






@end



@interface ZNRecordVideoToolManager (ZNAuthorization)

/**
 相机是否可以用
 */
- (BOOL)isAvailableWithCamera;

/**
 麦克风是否可以用
 */
- (BOOL)isAvailableWithMic;

//根据URL存储到相册
- (BOOL )saveRecordVideoWithFileURL:(NSURL *)fileURL;



@end
