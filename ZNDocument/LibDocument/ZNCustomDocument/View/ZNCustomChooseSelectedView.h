//
//  ZNCustomChooseSelectedView.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZNCustomChoiceDelegate <NSObject>

- (void)ZNCustomSelectedViewChoiceTitle:(NSString *)title index:(NSInteger )index;

@end



@interface ZNCustomChooseSelectedView : UIView


- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray<NSString *> *)titlesArray highlightColor:(UIColor *)highlightColor normalColor:(UIColor *)normalColor choicedIndex:(NSInteger )index;

@property(nonatomic, weak)id<ZNCustomChoiceDelegate>delegate;


- (void)refreshSelectedTypeWithIndex:(NSInteger )index;

- (void)configureLineWihtIsHaveTop:(BOOL )top isHaveBottom:(BOOL )bottom lineColor:(UIColor *)color;




@end
