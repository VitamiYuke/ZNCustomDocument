//
//  ZNDrawerMainController.h
//  ZNDocument
//
//  Created by 张楠 on 2017/5/19.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>




extern NSString * ZN_DRAWER_SHOW_LEFT;
extern NSString * ZN_DRAWER_SHOW_RIGHT;
extern NSString * ZN_DRAWER_DISMISS;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-function"
static void ZN_showLeft(BOOL animated) {
    [[NSNotificationCenter defaultCenter]postNotificationName:ZN_DRAWER_SHOW_LEFT object:nil userInfo:@{@"animated":@(animated)}];
};

static void ZN_showRight(BOOL animated) {
    [[NSNotificationCenter defaultCenter]postNotificationName:ZN_DRAWER_SHOW_RIGHT object:nil userInfo:@{@"animated":@(animated)}];
};

static void ZN_dismiss(BOOL animated) {
    [[NSNotificationCenter defaultCenter]postNotificationName:ZN_DRAWER_DISMISS object:nil userInfo:@{@"animated":@(animated)}];
};
#pragma clang diagnostic pop





@interface ZNDrawerMainController : UIViewController


/**
 *  控制器
 */
@property(nonatomic,strong,readonly)UIViewController * leftViewController;
@property(nonatomic,strong,readonly)UIViewController * mainViewController;
@property(nonatomic,strong,readonly)UIViewController * rightViewController;
/**
 *  默认300
 */
@property(nonatomic,assign)CGFloat leftViewWidth;

/**
 *  默认300
 */
@property(nonatomic,assign)CGFloat rightViewWidth;

/**
 *  默认YES
 */
@property(nonatomic,assign)BOOL canPan;//是否有手势

/**
 *  动画时间,默认0.4s
 */
@property(nonatomic,assign)CGFloat duration;
/**
 *  左右抽屉
 *
 *  @param leftVC  左vc
 *  @param mainVC  中间vc
 *  @param rightVC 右vc
 *
 *  @return WZXDrawerViewController对象
 */
+ (instancetype)zn_drawerViewControllerWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC;
/**
 *  左抽屉
 *
 *  @param leftVC 左vc
 *  @param mainVC 中间vc
 *
 *  @return WZXDrawerViewController对象
 */
+ (instancetype )zn_drawerViewControllerWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC;

/**
 *  右抽屉
 *
 *  @param mainVC  中间vc
 *  @param rightVC 右vc
 *
 *  @return WZXDrawerViewController对象
 */
+ (instancetype)zn_drawerViewControllerWithMainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC;

- (instancetype)initWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC;








@end
