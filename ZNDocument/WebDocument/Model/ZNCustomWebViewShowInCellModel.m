//
//  ZNCustomWebViewShowInCellModel.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/31.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNCustomWebViewShowInCellModel.h"

@interface ZNCustomWebViewShowInCellModel ()<ZNCustomWebViewDelegate>

@end

@implementation ZNCustomWebViewShowInCellModel



- (void)setContent:(NSString *)content
{
    _content = content;
    
    ZNCustomWebView  *customView = [[ZNCustomWebView alloc] initWithFrame:CGRectMake(15, 30, SCREENT_WIDTH - 30, 0) andHtmlString:content];
//    customView.delegate = self;
    customView.backgroundColor = [UIColor yellowColor];
    customView.getRealHeight = ^(CGFloat realHeight){
        MyLog(@"%.0f",realHeight);
        [ZNNoteCenter postNotificationName:@"getRealHeight" object:nil];
    };
    _custonWebView = customView;
    
}

- (void)getCustomWebViewRealHeight:(CGFloat)realHeight
{
    self.custonWebView.height = realHeight;
    MyLog(@"%.0f",realHeight);
}






@end
