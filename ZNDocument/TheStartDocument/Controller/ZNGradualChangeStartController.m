//
//  ZNGradualChangeStartController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/9/2.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNGradualChangeStartController.h"

@interface ZNGradualChangeStartController ()<UIScrollViewDelegate>

@property(nonatomic, strong)NSArray *backgroundViews;
@property(nonatomic, strong)NSArray *scrollViewPages;
@property(nonatomic, strong)UIPageControl *pageControl;
@property(nonatomic, assign)NSInteger centerPageIndex;
@property(nonatomic, strong)UIScrollView *pagingScrollView;
@property(nonatomic, strong)UIButton  *operationBtn;

@end

@implementation ZNGradualChangeStartController


- (void)dealloc
{
    self.view = nil;
}


- (instancetype)initWithCoverImageNames:(NSArray *)coverNames
{
    if (self = [super init]) {
        [self configureSelfDataSourceWithCoverNames:coverNames backgroundNames:nil];
    }
    return self;
}

- (instancetype)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    if ([super init]) {
        [self configureSelfDataSourceWithCoverNames:coverNames backgroundNames:bgNames];
    }
    return self;
}


- (void)configureSelfDataSourceWithCoverNames:(NSArray *)coverNames backgroundNames:(NSArray *)bgNames
{
    self.coverImageNames = coverNames;
    self.backGroundImageNames = bgNames;
}

- (UIButton *)operationBtn
{
    if (!_operationBtn) {
        _operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationBtn.frame = CGRectMake(self.view.bounds.size.width - 80, self.view.bounds.size.height - 50, 60, 30);
        _operationBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _operationBtn.alpha = 0;
        [_operationBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_operationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_operationBtn addTarget:self action:@selector(operationAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationBtn;
}

- (UIScrollView *)pagingScrollView
{
    if (!_pagingScrollView) {
        _pagingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _pagingScrollView.delegate = self;
        _pagingScrollView.pagingEnabled = YES;
        _pagingScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _pagingScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:[self frameOfPageControl]];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        
    }
    return _pageControl;
}

- (CGRect)frameOfPageControl
{
    return CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 30);
}

//是否是最后一页
- (BOOL)isTheLastPageWithOageControl:(UIPageControl *)pageControl
{
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (NSArray *)scrollViewPages
{
    if ([self.coverImageNames count] == 0) {
        return nil;
    }
    
    if (_scrollViewPages) {
        return _scrollViewPages;
    }
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.coverImageNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            UIImageView *imageView = [self scrollViewPage:obj];
            [tempArray addObject:imageView];
        }
    }];
    
    _scrollViewPages = tempArray;
    
    return _scrollViewPages;
}


- (UIImageView *)scrollViewPage:(NSString *)imageName;
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGSize size = {[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height};
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height);
    return imageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackgroundViews];
    [self.view addSubview:self.pagingScrollView];
    [self.view addSubview:self.pageControl];
    [self reloadPages];
    
    //跳过的按钮
    [self.view addSubview:self.operationBtn];
}


- (void)reloadPages
{
    self.pageControl.numberOfPages = [self.coverImageNames count];
    self.pagingScrollView.contentSize = CGSizeMake(SCREENT_WIDTH * self.scrollViewPages.count, SCREENT_HEIGHT);
    __block CGFloat x = 0;
    [self.scrollViewPages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = (UIImageView *)obj;
        imageView.frame = CGRectOffset(imageView.frame, x, 0);
        [self.pagingScrollView addSubview:obj];
        x += imageView.frame.size.width;
    }];
    
    if (self.pageControl.numberOfPages == 1) {
        self.pageControl.alpha = 0;
    }
    // fix ScrollView can not scrolling if it have only one page
    
    if (self.pagingScrollView.contentSize.width == self.pagingScrollView.frame.size.width) {
        self.pagingScrollView.contentSize = CGSizeMake(self.pagingScrollView.contentSize.width + 1, self.pagingScrollView.contentSize.height);
    }
}

- (void)addBackgroundViews
{
    CGRect frame = self.view.bounds;
    NSMutableArray *tmpArray = [NSMutableArray new];
    [[[[self backGroundImageNames] reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.frame = frame;
        imageView.tag = idx + 1;
        [tmpArray addObject:imageView];
        [self.view addSubview:imageView];
    }];
    self.backgroundViews = [[tmpArray reverseObjectEnumerator] allObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    MyLog(@"内存警告⚠️");
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * self.view.frame.size.width) / self.view.frame.size.width);
    
    if ([self.backgroundViews count] > index) {
        UIImageView *imageView = self.backgroundViews[index];
        if (imageView) {
            [imageView setAlpha:alpha];
        }
    }
    
    self.pageControl.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / self.coverImageNames.count);
    [self configureOperationAtt];
}

//将要显示的配置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

//设置操作的按钮
- (void)configureOperationAtt
{
    if ([self isTheLastPageWithOageControl:self.pageControl]) {//最后一页
        [UIView animateWithDuration:0.3 animations:^{
            self.operationBtn.alpha = 1;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.operationBtn.alpha = 0;
        }];
    }
}

//
- (void)operationAction
{
    [self.navigationController popViewControllerAnimated:YES];
}





@end
