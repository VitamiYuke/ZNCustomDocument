//
//  ZNAppleInPurchasingView.m
//  ZNDocument
//
//  Created by 张楠 on 16/10/29.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNAppleInPurchasingView.h"
#import <StoreKit/StoreKit.h>//内支付
@interface ZNAppleInPurchasingView ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@end


@implementation ZNAppleInPurchasingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (frame.size.height < 240) {
            self.height = 240;
        }
        [self configureUI];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)configureUI
{
    __weak typeof(self) weakSelf = self;
    ZNTestButton *sitBtn = [[ZNTestButton alloc] initWithFrame:CGRectMake(10, 10, 60, 30) title:@"6元档" action:^{
        NSString *indentifier = @"com.1020937381.loveStock.yikecaifu.6";
        [weakSelf requestInPayWithProductInfo:indentifier];
    }];
    [self addSubview:sitBtn];
    
    
    ZNTestButton *sitBtn1 = [[ZNTestButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sitBtn.frame) + 10, 60, 30) title:@"12元档" action:^{
        NSString *indentifier = @"com.1020937381.loveStock.yikecaifu.12";
        [weakSelf requestInPayWithProductInfo:indentifier];
    }];
    [self addSubview:sitBtn1];
    
    ZNTestButton *sitBtn2 = [[ZNTestButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sitBtn1.frame) +10, 60, 30) title:@"18元档" action:^{
        NSString *indentifier = @"com.1020937381.loveStock.yikecaifu.18";
        [weakSelf requestInPayWithProductInfo:indentifier];
    }];
    [self addSubview:sitBtn2];
    
    ZNTestButton *sitBtn3 = [[ZNTestButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sitBtn2.frame) +10, 60, 30) title:@"25元档" action:^{
        NSString *indentifier = @"com.1020937381.loveStock.yikecaifu.25";
        [weakSelf requestInPayWithProductInfo:indentifier];
    }];
    [self addSubview:sitBtn3];
    
    ZNTestButton *sitBtn4 = [[ZNTestButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sitBtn3.frame) +10, 60, 30) title:@"30元档" action:^{
        NSString *indentifier = @"com.1020937381.loveStock.yikecaifu.30";
        [weakSelf requestInPayWithProductInfo:indentifier];
    }];
    [self addSubview:sitBtn4];
    
    ZNTestButton *sitBtn5 = [[ZNTestButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sitBtn4.frame) +10, 60, 30) title:@"50元档" action:^{
        NSString *indentifier = @"com.1020937381.loveStock.yikecaifu.50";
        [weakSelf requestInPayWithProductInfo:indentifier];
    }];
    [self addSubview:sitBtn5];
    
    MyLog(@"%.0f",CGRectGetMaxY(sitBtn5.frame));
    
    
}

- (void)requestInPayWithProductInfo:(NSString *)productInfo
{
    MyLog(@"请求的商品价位:%@",productInfo);
    if (![SKPaymentQueue canMakePayments]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"不允许程序内付费,查看您是否设置了访问限制" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    NSArray *product = @[productInfo];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
    
}


#pragma mark - 交易的代理
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads
{
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    
}

#pragma mark - 请求商品信息
// Sent immediately before -requestDidFinish: 接收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    MyLog(@"请求的地址:%@",request);
    
    if (response.products.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相应服务产品" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    
    
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


@end
