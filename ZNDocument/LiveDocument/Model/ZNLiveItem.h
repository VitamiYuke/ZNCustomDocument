//
//  ZNLiveItem.h
//  ZNDocument
//
//  Created by 张楠 on 16/11/7.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZNCreatorItem;
@interface ZNLiveItem : NSObject

/** 直播流地址 */
@property (nonatomic, copy) NSString *stream_addr;
/** 关注人 */
@property (nonatomic, assign) NSUInteger online_users;
/** 城市 */
@property (nonatomic, copy) NSString *city;
/** 主播 */
@property (nonatomic, strong) ZNCreatorItem *creator;

@end
