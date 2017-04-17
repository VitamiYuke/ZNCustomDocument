//
//  ZNSlideMenu.h
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/22.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZNSlideMenuDelegate <NSObject>

@optional
- (void)finishHidden;

@end


typedef void(^MenuButtonClickedBlock)(NSInteger index,NSString *title);

@interface ZNSlideMenu : UIView

/**
 *  Convenient init method
 *
 *  @param titles Your menu options
 *
 *  @return object
 */
- (instancetype)initWithTitile:(NSArray *)titles;

/**
 *  Custom init method
 *
 *  @param titles Your menu options
 *
 *  @return object
 */
- (instancetype)initWithTitile:(NSArray *)titles withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle )style;


/**
 *  Method to trigger the animation
 */
-(void)trigger;

/*
 clickBlock
 */
@property(nonatomic, copy)MenuButtonClickedBlock menuClickBlock;
/*
 delegate
 */
@property(nonatomic, assign)id<ZNSlideMenuDelegate>delegate;


@end
