//
//  ZNSelecteVideoFromPhotoAlbums.h
//  ZNDocument
//
//  Created by 张楠 on 2017/5/23.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNViewController.h"

#import <Photos/Photos.h>

@class ZLSelectPhotoModel;

@interface ZNSelecteVideoFromPhotoAlbums : ZNViewController

@property(nonatomic, strong)PHAsset *asset;


//选则完成后回调
@property (nonatomic, copy) void (^DoneBlock)(NSArray<ZLSelectPhotoModel *> *selPhotoModels, BOOL isSelectOriginalPhoto);



@end
