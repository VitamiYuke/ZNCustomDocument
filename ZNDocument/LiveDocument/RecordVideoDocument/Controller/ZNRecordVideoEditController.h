//
//  ZNRecordVideoEditController.h
//  ZNDocument
//
//  Created by 张楠 on 2017/5/9.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNViewController.h"

@interface ZNRecordVideoEditController : ZNViewController



@property(nonatomic, strong)NSURL *video_url;


@property(nonatomic, copy)void(^deleteFinish)(void);


@end
