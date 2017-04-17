//
//  ZNKlineFiveBlockAndDetailsCell.h
//  ZNDocument
//
//  Created by 张楠 on 17/4/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNStockFiveBlockModel.h"
#import "ZNStockDetailsModel.h"
@interface ZNKlineFiveBlockAndDetailsCell : UITableViewCell
+ (instancetype )getZNKlineFiveBlockAndDetailsCellWithTableView:(UITableView *)tableView;
@property(nonatomic, strong)ZNStockFiveBlockModel *fiveBlockModel;
@property(nonatomic, strong)ZNStockDetailsModel *detailsModel;
@end
