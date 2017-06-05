//
//  ZNSkinCareCameraToolManager.m
//  ZNDocument
//
//  Created by 张楠 on 2017/5/17.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNSkinCareCameraToolManager.h"



@interface ZNSkinCareCameraToolManager ()

@property(nonatomic, strong)NSDateFormatter *dateFormatter;

@end


@implementation ZNSkinCareCameraToolManager

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    }
    return _dateFormatter;
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

//单个视频的地址
- (NSString *)recordVideoDetailsPathWithFileType:(NSString *)fileType{
    NSString *defaultPath = [self recordVideoDefaultCachePath];
    NSString *dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString *detailsPath = [defaultPath stringByAppendingPathComponent:[NSString stringWithFormat:@"YukeMovie_%@.%@",dateString,fileType]];
    MyLog(@"存储视频的详细地址:%@",detailsPath);
    return detailsPath;
}

- (NSString *)getLocalStorageFilePath{
    return [self recordVideoDetailsPathWithFileType:@"mp4"];
}

#pragma mark - 配置焦点
- (BOOL)confgiureCameraFocusPointWithPoint:(CGPoint)focusPoint inputDevice:(AVCaptureDevice *)captureDevice
{
    if (focusPoint.x > 1 || focusPoint.y > 1) {
        MyLog(@"失败的焦点");
        return NO;
    }
    
    
    if (!captureDevice) {
        MyLog(@"没有设备");
        return NO;
    }
    
    
    NSError *lockError = nil;
    if ([captureDevice lockForConfiguration:&lockError]) {
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:focusPoint];
        }
        
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        [captureDevice unlockForConfiguration];
    }
    if (lockError) {
        MyLog(@"聚焦失败:%@",[lockError localizedDescription]);
        return NO;
    }
    return YES;
}

#pragma mark - 焦距


- (BOOL)configureCameraFocusingLengthWithScale:(CGFloat)scale inputDevice:(AVCaptureDevice *)captureDevice{
    MyLog(@"当前设备:%@",captureDevice);
    if (captureDevice) {
        MyLog(@"当前的焦距:%.2f",captureDevice.videoZoomFactor);
        CGFloat currentZoom = captureDevice.videoZoomFactor;
        
        CGFloat finalScale = currentZoom * scale;
        if (finalScale < 1) {
            finalScale = 1;
        }else{
            if (finalScale > 8.8) {
                finalScale = 8.8;
            }
        }
        
        MyLog(@"最终的焦距:%.2f",finalScale);
        
        if (finalScale == currentZoom) {
            MyLog(@"一样就别改变了");
            return NO;
        }
        
        NSError *lockError = nil;
        if ([captureDevice lockForConfiguration:&lockError]) {
            [captureDevice setVideoZoomFactor:finalScale];
            [captureDevice unlockForConfiguration];
        }
        if (lockError) {
            MyLog(@"聚焦失败:%@",[lockError localizedDescription]);
            return NO;
        }
    }
    return YES;
}















@end
