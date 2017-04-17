//
//  ZNEmoticonsKeyboardView.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/10.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNEmoticonsKeyboardView.h"

//变量
#define Emoticon_Size (35)
#define Emoticon_Row (3)
#define Emoticon_Column (7)
#define Emoticon_Padding ((SCREENT_WIDTH - Emoticon_Size*Emoticon_Column)/(Emoticon_Column + 1))
#define Emoticon_Expression_Height (Emoticon_Row * (Emoticon_Size + Emoticon_Padding))
#define Emoticon_Expression_Margin (10)
#define Emoticon_PageControl_Height (20)
#define Emoticon_Bottom_Selected_Height (0)
#define Emoticon_Keyboard_Height (Emoticon_Expression_Height + Emoticon_Expression_Margin + Emoticon_PageControl_Height)
#define Emoticon_OnePage_Expression_MaxCount (Emoticon_Row * Emoticon_Column - 1)

typedef NS_ENUM(NSInteger, EmoticonType) {
    EmoticonTypeDefault = 1,//默认表情
    EmoticonTypeLxh  = 2,//浪小花
};


@interface ZNEmoticonsKeyboardView ()<UIScrollViewDelegate>

@property(nonatomic, strong)NSArray *defaultArray;//默认表情的数据
@property(nonatomic, strong)NSArray *lxhArray;//浪小花表情
@property(nonatomic, strong)UIScrollView *emoticonScrollView;//表情的容器

@property(nonatomic, assign)NSInteger defaultNum;
@property(nonatomic, assign)NSInteger lxhNum;

@property(nonatomic, strong)UIPageControl *currentPageControl;//当前显示的页数




@end


@implementation ZNEmoticonsKeyboardView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _emoticonsKeyboardHeight = Emoticon_Keyboard_Height;
        [self configureUI];
    }
    return self;
}


+(instancetype)defaultZNEmoticonsKeyboardView
{
    ZNEmoticonsKeyboardView *view = [[ZNEmoticonsKeyboardView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, Emoticon_Keyboard_Height)];
    return view;
}


- (void)configureUI
{
    self.backgroundColor = MyColor(240, 240, 240);
    
    //获取默认表情
    _defaultArray = [ZNExpressionCL ObtainAllSinaDefaultExpression];
    _defaultNum = _defaultArray.count % Emoticon_OnePage_Expression_MaxCount > 0 ? _defaultArray.count / Emoticon_OnePage_Expression_MaxCount + 1 : _defaultArray.count / Emoticon_OnePage_Expression_MaxCount;
    
    //获取浪小花
    _lxhArray = [ZNExpressionCL ObtainAllSinaLxhExpression];
    _lxhNum = _lxhArray.count % Emoticon_OnePage_Expression_MaxCount > 0 ? _lxhArray.count / Emoticon_OnePage_Expression_MaxCount + 1 : _lxhArray.count / Emoticon_OnePage_Expression_MaxCount;
    
    
    
    self.emoticonScrollView.contentSize = CGSizeMake(SCREENT_WIDTH * (self.defaultNum + self.lxhNum), 0);
    self.currentPageControl.numberOfPages = self.defaultNum;
    self.currentPageControl.currentPage = 0;
    //添加默认表情
    [self addEmoticonExpressionToScrollView:self.emoticonScrollView withEmotionArray:self.defaultArray addPageCount:self.defaultNum addBeginPageCount:0 withEmoticonTypeCount:1];
    //添加浪小花
    [self addEmoticonExpressionToScrollView:self.emoticonScrollView withEmotionArray:self.lxhArray addPageCount:self.lxhNum addBeginPageCount:self.defaultNum  withEmoticonTypeCount:2];

    
    
    MyLog(@"emoticonScrollViewTop%.0f",self.emoticonScrollView.contentInset.bottom);
    
    
    
}




//添加表情的方法
- (void)addEmoticonExpressionToScrollView:(UIScrollView *)emoticonScrollView withEmotionArray:(NSArray *)emoticonArray addPageCount:(NSInteger )emoticonPageCount addBeginPageCount:(NSInteger )beginPageCount   withEmoticonTypeCount:(NSInteger )type      // 添加到的父视图 表情数据 一共得页数 开始添加的页数
{
    //表情大小
    float emoticonWidth = Emoticon_Size;
    float emoticonHeight = Emoticon_Size;
    //间距
    float emoticonPadding = Emoticon_Padding;
    // 行数 和列数
    int emoticonRow = Emoticon_Row;
    int emoticonColum = Emoticon_Column;
    NSInteger index = 0;//数组索引
    
    /*取得全局队列
     第一个参数：线程优先级
     第二个参数：标记参数，目前没有用，一般传入0
     */
    dispatch_queue_t myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//创建队列
    
    for (int page = 0; page < emoticonPageCount; page++) {//页数
        for (int row = 0; row < emoticonRow; row++) { // 行数
            for (int colum = 0; colum < emoticonColum; colum ++) { // 列数
                if (row == (emoticonRow - 1) && colum == (emoticonColum - 1)) { // 右下角最后一个是删除按钮
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(beginPageCount*SCREENT_WIDTH + page*SCREENT_WIDTH + (emoticonWidth + emoticonPadding) * colum + emoticonPadding, (emoticonHeight + emoticonPadding) * row + Emoticon_Expression_Margin, emoticonWidth, emoticonHeight);
                    [deleteBtn setBackgroundImage:[ZNExpressionCL ObtainDeleteImage] forState:UIControlStateNormal];
                    [deleteBtn addTarget:self action:@selector(deleteEmoticon:) forControlEvents:UIControlEventTouchUpInside];
                    [emoticonScrollView addSubview:deleteBtn];
                } else {
                    if (index < emoticonArray.count) {
                        
                        NSDictionary *dict = emoticonArray[index];
                        NSString *strName = dict[@"png"];
                        UIImage *image;
                        if (type == 1) {//默认
                            image = [ZNExpressionCL ObtainPictureDefault:strName];
                        } else if (type == 2) {//浪小花
                            image = [ZNExpressionCL ObtainPictureLxh:strName];
                        }
                        
                        CGRect emoticonFrame = CGRectMake(beginPageCount*SCREENT_WIDTH + page*SCREENT_WIDTH + (emoticonWidth + emoticonPadding) * colum + emoticonPadding, (emoticonHeight + emoticonPadding) * row + Emoticon_Expression_Margin, emoticonWidth, emoticonHeight);
                        dispatch_async(myQueue, ^{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self configureEmojiBtnWithFrame:emoticonFrame Img:image type:type superView:emoticonScrollView index:index];
                            });
                        });
                        index++;
                    }
                    
                }
                
            }
        }
        
    }
    
}


- (void)configureEmojiBtnWithFrame:(CGRect )frame Img:(UIImage *)img type:(NSInteger )type superView:(UIView *)superView index:(NSInteger )index
{
    UIButton *emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emoticonBtn.frame = frame;
    emoticonBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    emoticonBtn.tag = 10000 * type +index;
    [emoticonBtn setBackgroundImage:img forState:UIControlStateNormal];
    [emoticonBtn addTarget:self action:@selector(tapEmoticonView:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:emoticonBtn];
   
}





//点击表情
- (void)tapEmoticonView:(UIButton *)sender
{
    MyLog(@"点击表情选择");
    
    NSInteger type = sender.tag/10000;
    NSInteger typeTag = sender.tag % 10000;
    switch (type) {
        case EmoticonTypeDefault: // 默认表情
            if (self.delegate) {
                [self.delegate ZNEmoticonsSelectedExpressionName:self.defaultArray[typeTag][@"chs"]];
            }
            break;
        case EmoticonTypeLxh: // 浪小花
            if (self.delegate) {
                [self.delegate ZNEmoticonsSelectedExpressionName:self.lxhArray[typeTag][@"chs"]];
            }
            break;
        default:
            MyLog(@"不存在该表情");
            break;
    }
    
    
    
    
}

//点击删除按钮
- (void)deleteEmoticon:(UIButton *)sender
{
    MyLog(@"点击删除按钮");
    if (self.delegate) {
        [self.delegate ZNEmoticonsExpressionDelete];
    }
}

- (UIScrollView *)emoticonScrollView
{
    if (!_emoticonScrollView) {
        _emoticonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, Emoticon_Expression_Height + Emoticon_Expression_Margin)];
        _emoticonScrollView.pagingEnabled = YES;
        _emoticonScrollView.showsHorizontalScrollIndicator = NO;
        _emoticonScrollView.delegate = self;
        [self addSubview:_emoticonScrollView];
    }
    return _emoticonScrollView;
}




- (UIPageControl *)currentPageControl
{
    if (!_currentPageControl) {
        _currentPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, Emoticon_Expression_Height + Emoticon_Expression_Margin, SCREENT_WIDTH, Emoticon_PageControl_Height)];
        _currentPageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _currentPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:_currentPageControl];
    }
    return _currentPageControl;
}

//滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger page = offset.x / bounds.size.width;
    if (page == self.defaultNum - 1) {
        self.currentPageControl.numberOfPages = self.defaultNum;
    } else if (page == self.defaultNum) {
        self.currentPageControl.numberOfPages = self.lxhNum;
    }
    
    NSInteger index = page;
    if (page >= self.defaultNum) {
        index = page - self.defaultNum;
    } else if (page > self.defaultNum && page < self.defaultNum + self.lxhNum) {
        index = page - self.defaultNum - self.lxhNum;
    }
    
    [self.currentPageControl setCurrentPage:index];
}










@end
