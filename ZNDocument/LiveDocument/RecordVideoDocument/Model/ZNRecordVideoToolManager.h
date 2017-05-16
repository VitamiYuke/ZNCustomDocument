//
//  ZNRecordVideoToolManager.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/19.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class PHAsset;
@class PHAssetCollection;

@interface ZNRecordVideoToolManager : NSObject

- (instancetype)initWithPreviewLayerFrame:(CGRect )frame;

@property(nonatomic, strong, readonly)AVCaptureVideoPreviewLayer *previewLayer;//界面显示

@property(nonatomic, strong, readonly)CAShapeLayer *focusingLayer;

@property(nonatomic, strong, readonly)NSURL *recordFileURL;//录制完毕的视频链接 有值则录制完毕

@property(nonatomic, copy, readonly)NSString *file_path;



//启动录制功能
- (void)startRecordFunction;
//关闭录制功能
- (void)stopRecordFunction;
//切换前后摄像头
- (BOOL )transformCameraDirectionWithIsFrontCamera:(BOOL )isFrontCamera;

//开始录制 结束录制
- (void)startRecordVideo;
- (void)endRecordVideo;

//聚焦
- (void)configureCameraFocusingWithPoint:(CGPoint )focusPoint;

//焦距
- (void)configureCameraFocusingLengthWithScale:(CGFloat )scale;


@end


//视频专辑的模型
@interface ZNPhoneVideoListModel : NSObject

@property (nonatomic, copy) NSString *title; //相册名字
@property (nonatomic, assign) NSInteger count; //该相册内相片数量
@property (nonatomic, strong) PHAsset *headImageAsset; //相册第一张图片缩略图
@property (nonatomic, strong) PHAssetCollection *assetCollection; //相册集，通过该属性获取该相册集下所有照片

@end



@interface ZNOutputVideoModel : NSObject


@property(nonatomic, strong)UIImage *cover;
@property(nonatomic, strong)NSData *video_data;
@property(nonatomic, assign)int video_time;
@property(nonatomic, copy)NSString *outputPath;


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

//根据URL存储到相册 并获取压缩后的文件
- (BOOL )saveRecordVideoWithFileURL:(NSURL *)fileURL andToDealWithTheVideoFinish:(void(^)(ZNOutputVideoModel *dealedModel))finishSucc;

//获取所有视频的列表
- (NSArray<ZNPhoneVideoListModel *>*)getAllPhoneVideoAblumList;


//获取相册内所有的视频资源
- (NSArray<PHAsset *>*)getAllPhoneVideoAsset;

//清除所有压缩过的视频缓存
+ (void)clearAllTempProcessedVideos;

+ (NSArray<NSString *>*)getAllTempProcessedVideosLocalNames;

+ (NSString *)getAbsolutePathWithLocalName:(NSString *)localVideosName;






@end
