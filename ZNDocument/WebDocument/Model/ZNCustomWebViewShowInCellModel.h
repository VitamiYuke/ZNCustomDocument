//
//  ZNCustomWebViewShowInCellModel.h
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/31.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNCustomWebView.h"
@interface ZNCustomWebViewShowInCellModel : NSObject


@property(nonatomic, strong)ZNCustomWebView *custonWebView;




@property(nonatomic, copy)NSString *content;

@property(nonatomic, assign, readonly)CGFloat realHeigth;


@end
