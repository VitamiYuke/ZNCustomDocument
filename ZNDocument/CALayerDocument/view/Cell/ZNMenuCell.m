//
//  ZNMenuCell.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/23.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNMenuCell.h"
#import "ZNMenuButton.h"

@interface ZNMenuCell ()
@property(nonatomic, strong)ZNMenuButton *menuButton;
@end

@implementation ZNMenuCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    
}

+ (instancetype)getZNMenuCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"ZNMenuCellindentifier";
    ZNMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[ZNMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}



- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    MyLog(@"cell宽度:%.0f",self.contentView.frame.size.width);
    ZNMenuButton *menuButton = [[ZNMenuButton alloc] initWithTitle:buttonTitle];
    menuButton.backgroundColor = MyColor(0, 197, 255);
    menuButton.frame = CGRectMake(0, 15, SCREENT_WIDTH/2 - 20 * 2, 40);
    [self addSubview:menuButton];
    
}



@end
