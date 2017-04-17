//
//  ZNKlineLandscapeOperationView.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/7.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZNKlineOperationChangeDelegate <NSObject>

@optional

- (void)ZNKlineOperationHaveChanged;

@end

@interface ZNKlineLandscapeOperationView : UIView

@property(nonatomic, weak)id<ZNKlineOperationChangeDelegate>delegate;

@end
