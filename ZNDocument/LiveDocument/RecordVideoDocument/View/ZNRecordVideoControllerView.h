//
//  ZNRecordVideoControllerView.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/19.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZNOutputVideoModel;

@interface ZNRecordVideoControllerView : UIView



@property(nonatomic, copy)void(^processedVideo)(ZNOutputVideoModel *);


@property(nonatomic, copy)void(^processedImage)(UIImage *);



@end
