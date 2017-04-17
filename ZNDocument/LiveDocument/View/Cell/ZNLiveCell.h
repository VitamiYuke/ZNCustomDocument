//
//  ZNLiveCell.h
//  ZNDocument
//
//  Created by 张楠 on 16/11/7.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZNLiveItem;
typedef void(^PlayBtnCallBackBlock)(UIButton *);
@interface ZNLiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigPicView;
@property (nonatomic, strong) UIButton             *playBtn;
@property(nonatomic, strong)ZNLiveItem *live;
/** 播放按钮block */
@property (nonatomic, copy  ) PlayBtnCallBackBlock playBlock;
@end
