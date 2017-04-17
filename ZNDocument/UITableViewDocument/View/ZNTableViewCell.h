//
//  ZNTableViewCell.h
//  ZNDocument
//
//  Created by 张楠 on 16/10/10.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ZN_TableViewCell_Default_height (40)
@interface ZNTableViewCell : UITableViewCell

+ (instancetype )getZNTableViewCellWithTableView:(UITableView *)tableView;

@property(nonatomic, copy)NSString *testTitle;

@end
