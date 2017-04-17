//
//  ZNEmoticonsKeyboardView.h
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/10.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNExpressionCL.h"//表情

@protocol ZNEmoticonsKeyboardViewDelegate <NSObject>

- (void)ZNEmoticonsSelectedExpressionName:(NSString *)expressionStr;
- (void)ZNEmoticonsExpressionDelete;

@end

@interface ZNEmoticonsKeyboardView : UIView


@property(nonatomic, assign, readonly)CGFloat emoticonsKeyboardHeight;


@property(nonatomic, assign)id<ZNEmoticonsKeyboardViewDelegate>delegate;

+(instancetype)defaultZNEmoticonsKeyboardView;



@end
