//
//  ZNCustomWebView.h
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/30.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ZNCustomWebViewDelegate <NSObject>


- (void)getCustomWebViewRealHeight:(CGFloat )realHeight;


@end


@interface ZNCustomWebView : UIView


//加载自定义的html
- (instancetype)initWithFrame:(CGRect)frame andHtmlString:(NSString *)htmlString;


@property(nonatomic, assign ,readonly)CGFloat realHeight;//真实的高度

@property(nonatomic, assign)id<ZNCustomWebViewDelegate>delegate;

@property(nonatomic, copy)void(^getRealHeight)(CGFloat );
//加载自定义的html
- (void)loadingCustomHtmlString:(NSString *)htmlString;






@end
