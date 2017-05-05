//
//  ZNFullScreenRecordConsoleWindow.h
//  ZNDocument
//
//  Created by 张楠 on 2017/5/4.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNFullScreenRecordConsoleWindow : UIWindow



+ (instancetype )shareZNFullScreenRecordConsoleWindow;

- (void)showMenu;
- (void)dismissMenu;



@end
