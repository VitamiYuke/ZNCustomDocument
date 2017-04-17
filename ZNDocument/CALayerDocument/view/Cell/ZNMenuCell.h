//
//  ZNMenuCell.h
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/23.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kZNMenuCellDefaultHeight 70

@interface ZNMenuCell : UITableViewCell



+ (instancetype)getZNMenuCellWithTableView:(UITableView *)tableView;

@property(nonatomic, copy)NSString *buttonTitle;


@end
