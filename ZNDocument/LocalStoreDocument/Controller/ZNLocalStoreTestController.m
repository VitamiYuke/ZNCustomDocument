//
//  ZNLocalStoreTestController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/9/2.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNLocalStoreTestController.h"
#import "PYSearchViewController.h"
#import "ZNStockDetailsController.h"
#import "ZNSearchStockModel.h"
#import "ZNBasedStockToolManager.h"
@interface ZNLocalStoreTestController ()<PYSearchViewControllerDelegate>

@property(nonatomic, strong)NSMutableArray *allStockArray;

@end

@implementation ZNLocalStoreTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    znWeakSelf(self);
    ZNTestButton *searchStockBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(60, 60, 120, 30) title:@"搜索股票" action:^{
        [weakSelf configureSearchStockInfo];
    }];
    [self.view addSubview:searchStockBtn];
    
    NSArray *stockArray = [NSKeyedUnarchiver unarchiveObjectWithFile:ZNLocalStockPath];
    if (stockArray.count) {
        [self.allStockArray addObjectsFromArray:stockArray];
    }else{
        [self configureAllStock];
    }
    
}


- (void)configureAllStock{
    [ZNBasedStockToolManager getAllStockInfoSuccess:^(id responseObject) {
        [self.allStockArray removeAllObjects];
        NSMutableArray *tempArray= @[].mutableCopy;
        NSArray *dataArray = (NSArray *)responseObject;
        if (dataArray.count > 0) {
            for (NSDictionary *dic in dataArray) {
                ZNSearchStockModel *model = [[ZNSearchStockModel alloc] init];
                model.stockCode = [NSString stringWithFormat:@"%@",dic[@"c"]];
                model.stockName = [NSString stringWithFormat:@"%@",dic[@"n"]];
                model.stockSymbol = [NSString stringWithFormat:@"%@",dic[@"s"]];
                model.stockPinyin = [NSString stringWithFormat:@"%@",dic[@"p"]];
                [tempArray addObject:model];
            }
            [self.allStockArray addObjectsFromArray:tempArray];
        }
    } failure:^{
        [self configureAllStock];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





- (void)configureSearchStockInfo{
    
    
    NSMutableArray *hotArray = @[].mutableCopy;
    [hotArray addObjectsFromArray:@[@"上证指数",@"深证指数",@"创业扳指"]];
    NSArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:ZNLocalHotStockPath];
    for (ZNSearchStockModel *model in dataArray) {
        [hotArray addObject:model.stockName];
    }
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotArray searchBarPlaceholder:@"请输入股票代码/全拼/首字母" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        MyLog(@"搜索的关键字:%@",searchText);
        ZNSearchStockModel *model = [ZNBasedStockToolManager configureGetSearchModelWithSearchKeyWord:searchText];
        if (model) {
            ZNStockDetailsController *detailsController = [[ZNStockDetailsController alloc] init];
            detailsController.stockModel = model;
            [searchViewController presentViewController:detailsController animated:YES completion:^{
                
            }];
        }
    }];
    searchViewController.hotSearchStyle = PYHotSearchStyleRankTag; // 热门搜索风格根据选择
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    // 4. 设置代理
    searchViewController.delegate = self;
    searchViewController.removeSpaceOnSearchString = NO;
    // 5. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) { // 与搜索条件再搜索
        NSMutableArray *tempArray = @[].mutableCopy;
        
        for (ZNSearchStockModel *searchModel  in self.allStockArray) {
            if ([searchText containsString:searchModel.stockName]) {
                [tempArray addObject:[ZNBasedStockToolManager configureGetSearchResultWithModel:searchModel]];
            }else{
                NSRange range=[searchModel.stockName rangeOfString:searchText];
                if (range.location!= NSNotFound)
                {
                    [tempArray addObject:[ZNBasedStockToolManager configureGetSearchResultWithModel:searchModel]];
                }else
                {
                    NSRange range1=[searchModel.stockSymbol rangeOfString:searchText];
                    if (range1.location!= NSNotFound)
                    {
                        [tempArray addObject:[ZNBasedStockToolManager configureGetSearchResultWithModel:searchModel]];
                        
                    }else
                    {
                        NSRange range2 = [searchModel.stockPinyin rangeOfString:searchText.uppercaseString];
                        if (range2.location!= NSNotFound) {
                            [tempArray addObject:[ZNBasedStockToolManager configureGetSearchResultWithModel:searchModel]];
                        }
                    }
                }
            }
        }
        searchViewController.searchSuggestions = tempArray;
    }
}





- (NSMutableArray *)allStockArray{
    if (!_allStockArray) {
        _allStockArray = @[].mutableCopy;
    }
    return _allStockArray;
}



@end
