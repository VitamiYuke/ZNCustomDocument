//
//  ZNTableViewController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/8.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNTableViewController.h"
#import "ZNWebTestController.h"
#import "ExpressTestController.h"
#import "ZNBesselTestController.h"
#import "CALayerTestController.h"
#import "ZNTestCell.h"
#import "ZNLocalStoreTestController.h"
#import "ZNStartTestController.h"
#import "ZNNetworkRequestTestController.h"
#import "ZNUItableViewTestController.h"
#import "ZNCoreTextTestController.h"
#import "AppleInPurchasingTestController.h"
#import "ZNLiveTestController.h"
#import "ZNSysPhotoAlbumTestController.h"
#import "ZNGoodDemoCollectionTestController.h"
#import "ODRefreshControl.h"
@interface ZNTableViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;// 数据源





@property(nonatomic, strong)NSMutableArray *controllerNames;


@end

@implementation ZNTableViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObjectsFromArray:@[@"Web交互测试",@"Express表情处理",@"Bessel测试",@"Layer测试",@"本地存储",@"启动图",@"网络请求",@"UITableview",@"富文本和加载Html语言",@"苹果内购",@"直播",@"系统相册",@"好的Demo"]];
    }
    return _dataArray;
}

-(NSMutableArray *)controllerNames
{
    if (!_controllerNames) {
        _controllerNames = [NSMutableArray array];
        [_controllerNames addObjectsFromArray:@[@"ZNWebTestController",@"ExpressTestController",@"ZNBesselTestController",@"CALayerTestController",@"ZNLocalStoreTestController",@"ZNStartTestController",@"ZNNetworkRequestTestController",@"ZNUItableViewTestController",@"ZNCoreTextTestController",@"AppleInPurchasingTestController",@"ZNLiveTestController",@"ZNSysPhotoAlbumTestController",@"ZNGoodDemoCollectionTestController"]];
        
    }
    return _controllerNames;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试数据";
    [self configureUI];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    refreshControl.tintColor = [UIColor purpleColor];
    refreshControl.activityIndicatorViewColor = [UIColor purpleColor];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
}


- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
    });
    
}



- (void)configureUI
{
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    self.tableView.backgroundColor = MyColor(247, 247, 247);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem itemWithSpacer],[UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"YukeAvatar"] HighlightedImage:[UIImage imageNamed:@"YukeAvatar"] target:self action:@selector(personalCenterAction) targetSize:CGSizeMake(38, 38) isArcProcessing:YES]];
    
}

- (void)personalCenterAction{
    [ZNBasedToolManager YukePageJumpShowLeftDrawer];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZNTestCell *cell = [ZNTestCell getZNTestCellWith:tableView];
    cell.testTitle = self.dataArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];//反选让cell取消选中状态
    
    NSString *title = self.dataArray[indexPath.row];
    NSString *controllerName = self.controllerNames[indexPath.row];
    UIViewController *testController = [[NSClassFromString(controllerName) alloc] init];
    testController.title = title;
    [self.navigationController pushViewController:testController animated:YES];
}


#pragma mark - 复制操作 系统自带
/*
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        [MBProgressHUD showSuccess:@"复制成功"];
    }
}
*/


#pragma mark - 滑动的ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView // 使用UITableViewController会使加在上面的子控件随着tableView滑动而滑动
{
  
    
}

// View controller-based status bar appearance 需要设置为YES
#pragma mark - 状态栏的改变重载
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
//
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
//{
//    return UIStatusBarAnimationSlide;
//}



@end
