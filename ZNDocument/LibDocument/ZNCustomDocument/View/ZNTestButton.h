//
//  ZNTestButton.h
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/9/2.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonAction)(void);

@interface ZNTestButton : UIButton



- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title action:(ButtonAction)buttonAction;

@property(nonatomic, copy)ButtonAction buttonAction;

@property(nonatomic, copy)NSString *title;



@end
