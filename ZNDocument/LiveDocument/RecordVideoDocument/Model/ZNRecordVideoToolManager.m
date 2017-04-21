//
//  ZNRecordVideoToolManager.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/19.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNRecordVideoToolManager.h"
#import <Photos/Photos.h>
@interface ZNRecordVideoToolManager ()<AVCaptureFileOutputRecordingDelegate>

@property(nonatomic, strong)AVCaptureSession *captureSession;//输入输出的连接

@property(nonatomic, assign)dispatch_queue_t recordCustomQueue;

@property(nonatomic, strong)AVCaptureDeviceInput *backCameraInput;//后置摄像头
@property(nonatomic, strong)AVCaptureDeviceInput *frontCameraInput;//前置摄像头
@property(nonatomic, strong)AVCaptureDeviceInput *audioMicInput;//音频输入

@property(nonatomic, strong)AVCaptureConnection *videoConnection;//视频录制连接
@property(nonatomic, strong)AVCaptureMovieFileOutput *movieFileOutPut;//视频输出流

@property(nonatomic, assign)BOOL isFrontCamera;//是否是前置相机

@property(nonatomic, strong)NSDateFormatter *dateFormatter;

@end

@implementation ZNRecordVideoToolManager{
    CGRect _previewFrame;
}

#pragma mark - 视频输出代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    MyLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"视频录制完成.");
    _recordFileURL = outputFileURL;
}

#pragma mark - 录制功能
- (void)startRecordVideo{
    if (self.movieFileOutPut.isRecording) {
        return;
    }
    
    _recordFileURL = nil;//置空以前的
    NSString *cachePath = [self recordVideoDetailsPathWithFileType:@"mp4"];
    [self.movieFileOutPut startRecordingToOutputFileURL:[NSURL fileURLWithPath:cachePath] recordingDelegate:self];
    
    
}

- (void)endRecordVideo{
    if (self.movieFileOutPut.isRecording) {
        [self.movieFileOutPut stopRecording];
    }
}


//视频的地址
- (NSString *)recordVideoDefaultCachePath{
    NSString *videoCache = [NSTemporaryDirectory() stringByAppendingPathComponent:@"YukeMovies"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:videoCache isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:videoCache withIntermediateDirectories:YES attributes:nil error:nil];
    };
    return videoCache;
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    }
    return _dateFormatter;
}

//单个视频的地址
- (NSString *)recordVideoDetailsPathWithFileType:(NSString *)fileType{
    NSString *defaultPath = [self recordVideoDefaultCachePath];
    NSString *dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString *detailsPath = [defaultPath stringByAppendingPathComponent:[NSString stringWithFormat:@"YukeMovie_%@.%@",dateString,fileType]];
    MyLog(@"存储视频的详细地址:%@",detailsPath);
    return detailsPath;
}


#pragma mark - 初始化
- (instancetype)initWithPreviewLayerFrame:(CGRect)frame{
    if ([super init]) {
        _previewFrame = frame;
        [self configureRecordVideoParameter];
    }
    return self;
}


#pragma mark - 外部相机设置
//启动录制功能
- (void)startRecordFunction
{
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
    
}

//关闭录制功能
- (void)stopRecordFunction
{
    if(self.captureSession)
        [self.captureSession stopRunning];
}



//切换摄像头
- (BOOL )transformCameraDirectionWithIsFrontCamera:(BOOL)isFrontCamera{
    if (isFrontCamera == self.isFrontCamera) {
        MyLog(@"没有改变");
        return NO;
    }
    
    
    if (self.movieFileOutPut.isRecording) {
        MyLog(@"正在录制");
        return NO;
    }
    
    self.isFrontCamera = isFrontCamera;
    [self stopRecordFunction];
    [self.captureSession beginConfiguration];
    
    if (self.isFrontCamera) {
        [self.captureSession removeInput:self.backCameraInput];
        if ([self.captureSession canAddInput:self.frontCameraInput]) {
            [self.captureSession addInput:self.frontCameraInput];
        }
    }else{
        [self.captureSession removeInput:self.frontCameraInput];
        if ([self.captureSession canAddInput:self.backCameraInput]) {
            [self.captureSession addInput:self.backCameraInput];
        }
    }
    [self.captureSession commitConfiguration];
    [self startRecordFunction];
    
    return YES;
}

#pragma mark - 内部参数配置
- (void)configureRecordVideoParameter{
    
    self.isFrontCamera = NO;
    
    
    //添加后只摄像头输入
    if ([self.captureSession canAddInput:self.backCameraInput]) {
        [self.captureSession addInput:self.backCameraInput];
    }
    //添加音频 输入
    if ([self.captureSession canAddInput:self.audioMicInput]) {
        [self.captureSession addInput:self.audioMicInput];
    }
    
    //添加输出
    if ([self.captureSession canAddOutput:self.movieFileOutPut]) {
        [self.captureSession addOutput:self.movieFileOutPut];
    }
    
    //设置录制的方向
    self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    //显示层
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = _previewFrame;
    }
    
    
}


//用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position{
    //返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

//音频设备
- (AVCaptureDevice *)audioMic{
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
}


- (void)dealloc{
    MyLog(@"录制工具销毁");
}

#pragma mark - 初始化录制信息




- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        //设置分辨率
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
        }
    }
    return _captureSession;
}

- (AVCaptureDeviceInput *)backCameraInput{
    if (!_backCameraInput) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        if (error) {
            NSLog(@"获取后置摄像头失败~%d",[self isAvailableWithCamera]);
        }
    }
    return _backCameraInput;
}

//前置摄像头输入
- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        if (error) {
            NSLog(@"获取前置摄像头失败~");
        }
    }
    return _frontCameraInput;
}

//麦克风输入
- (AVCaptureDeviceInput *)audioMicInput {
    if (_audioMicInput == nil) {
        AVCaptureDevice *mic = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error;
        _audioMicInput = [AVCaptureDeviceInput deviceInputWithDevice:mic error:&error];
        if (error) {
            NSLog(@"获取麦克风失败~%d",[self isAvailableWithMic]);
        }
    }
    return _audioMicInput;
}

//输入输出对象,用于获取输入输出数据
- (AVCaptureMovieFileOutput *)movieFileOutPut{
    if (!_movieFileOutPut) {
        _movieFileOutPut = [[AVCaptureMovieFileOutput alloc] init];
    }
    return _movieFileOutPut;
}
//视频连接
- (AVCaptureConnection *)videoConnection{
    if (!_videoConnection) {
        _videoConnection = [self.movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    }
    return _videoConnection;
}


@end


@implementation ZNRecordVideoToolManager (ZNAuthorization)

- (BOOL)isAvailableWithCamera
{
    return [self isAvailableWithDeviveMediaType:AVMediaTypeVideo];
}
- (BOOL)isAvailableWithMic
{
    return [self isAvailableWithDeviveMediaType:AVMediaTypeAudio];
}

- (BOOL)isAvailableWithDeviveMediaType:(NSString *)mediaType
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(status == AVAuthorizationStatusDenied||status == AVAuthorizationStatusRestricted)
        return NO;
    else
        return YES;
}

- (BOOL)saveRecordVideoWithFileURL:(NSURL *)fileURL{
    
    if (!fileURL) {
        return NO;
    }
    //视频录入完成之后在后台将视频存储到相
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileURL];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            MyLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        }
        MyLog(@"成功保存视频到相簿.");
    }];
    return YES;
}


@end
