//
//  ZNSkinCareCameraToolManager.h
//  ZNDocument
//
//  Created by 张楠 on 2017/5/17.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZNSkinCareCameraToolManager : NSObject


- (NSString *)getLocalStorageFilePath;


//设置聚焦
- (BOOL )confgiureCameraFocusPointWithPoint:(CGPoint )focusPoint inputDevice:(AVCaptureDevice *)captureDevice;

//设置焦距
- (BOOL )configureCameraFocusingLengthWithScale:(CGFloat )scale inputDevice:(AVCaptureDevice *)captureDevice;






@end
