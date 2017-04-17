//
//  ZNPlayerControllerDelegate.h
//  ZNDocument
//
//  Created by 张楠 on 16/11/22.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ZNPlayerControllerDelegate <NSObject>

@optional
/**  返回按钮事件 */
- (void)zn_controlView:(UIView *)controlView backAction:(UIButton *)sender;
/**  cell播放中小屏状态 关闭按钮事件 */
- (void)zn_controlView:(UIView *)controlView closeAction:(UIButton *)sender;
/** 播放按钮事件 */
- (void)zn_controlView:(UIView *)controlView playAction:(UIButton *)sender;
/** 全屏按钮事件 */
- (void)zn_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender;
/** 锁定屏幕方向按钮时间 */
- (void)zn_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender;
/** 重播按钮事件 */
- (void)zn_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender;
/** 中间播放按钮事件 */
- (void)zn_controlView:(UIView *)controlView cneterPlayAction:(UIButton *)sender;
/** 加载失败按钮事件 */
- (void)zn_controlView:(UIView *)controlView failAction:(UIButton *)sender;
/** 下载按钮事件 */
- (void)zn_controlView:(UIView *)controlView downloadVideoAction:(UIButton *)sender;
/** 切换分辨率按钮事件 */
- (void)zn_controlView:(UIView *)controlView resolutionAction:(UIButton *)sender;
/** slider的点击事件（点击slider控制进度） */
- (void)zn_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value;
/** 开始触摸slider */
- (void)zn_controlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider;
/** slider触摸中 */
- (void)zn_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider;
/** slider触摸结束 */
- (void)zn_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider;


@end
