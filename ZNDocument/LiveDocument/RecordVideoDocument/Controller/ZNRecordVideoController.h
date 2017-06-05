//
//  ZNRecordVideoController.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/19.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNViewController.h"

@class ZNOutputVideoModel;

@interface ZNRecordVideoController : ZNViewController

@property(nonatomic, copy)void(^processedVideo)(ZNOutputVideoModel *);

@property(nonatomic, copy)void(^processedImage)(UIImage *);

@end
