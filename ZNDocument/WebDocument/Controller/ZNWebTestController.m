//
//  ZNWebTestController.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/9.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNWebTestController.h"
#import <WebKit/WebKit.h>
#import "ZNCustomWebView.h"
#import "ZNCustomWebViewShowInCellModel.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ZNWebTestController ()<ZNCustomWebViewDelegate,UIWebViewDelegate,UITextViewDelegate>

@property(nonatomic, copy)NSString *webUrl;

@property(nonatomic, copy)NSString *customUrl;//自定义的url
@property(nonatomic, strong)ZNCustomWebView *customWebView;
@property(nonatomic, strong)ZNCustomWebViewShowInCellModel *model;
@property(nonatomic, strong)UIWebView *webView;

//
@property(nonatomic, copy)NSString *stockLinkContent;

@property(nonatomic, strong)UITextView *htmlTextView;

@property(nonatomic, copy)NSString *oneLineString;


//js交互的URL
@property(nonatomic, copy)NSString *jsUrl;




@end

@implementation ZNWebTestController


- (NSString *)jsUrl{
    if (!_jsUrl) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"ZNTest" ofType:@"html"];
        _jsUrl = [NSString stringWithContentsOfFile:file encoding:(NSUTF8StringEncoding) error:nil];
    }
    return _jsUrl;
}

- (NSString *)webUrl
{
    if (!_webUrl) {
        _webUrl = @"http://www.baidu.com";
    }
    return _webUrl;
}

- (NSString *)customUrl
{
    if (!_customUrl) {
        _customUrl = @"小女子男女生男生女什么<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>万达院线</a>，万达院线，待机时间<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>002739</a>抓紧时间<img src='http://img.5igupiao.com/upload/m/editor/upload/20150826/144057802648.jpg'/>";
                      
    }
    return _customUrl;
}

- (NSString *)stockLinkContent
{
    if (!_stockLinkContent) {//font-size
        _stockLinkContent = @"小女子男女生男生女什么<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>万达院线</a>，万达院线，待机时间<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>002739</a>抓紧时间10086小女子男女生男生女什么<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>万达院线</a>，万达院线，待机时间<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>002739</a><br><br><img width='320' height='400' src='http://img.5igupiao.com/upload/m/editor/upload/20150826/144057802648.jpg' placeHoldrUrl='https://cdn.5igupiao.com/upload/livemsg/20170305/14886992331.jpg' /><br><br>抓紧时间10086小女子男女生男生女什么<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>万达院线</a>，万达院线，待机时间<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>002739</a>抓紧时间10086小女子男女生男生女什么<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>万达院线</a>，万达院线，待机时间<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>002739</a>抓紧时间10086小女子男女生男生女什么<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>万达院线</a>";
    }
    return _stockLinkContent;
}

- (NSString *)oneLineString
{
    if (!_oneLineString) {
        _oneLineString = @"<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>万达院线</a>,<a href='http://quote.5igupiao.com/stock_m.php#AiGuPiao_StockCode=sz002739&name=万达院线'>002739</a>";
    }
    return _oneLineString;
}



- (ZNCustomWebView *)customWebView
{
    if (!_customWebView) {
        _customWebView = [[ZNCustomWebView alloc] initWithFrame:CGRectMake(15, 30, SCREENT_WIDTH - 30, 0) andHtmlString:self.customUrl];
        _customWebView.delegate = self;
        _customWebView.backgroundColor = [UIColor yellowColor];
    }
    return _customWebView;
}






- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [_webView loadHTMLString:self.jsUrl baseURL:nil];
    }
    return _webView;
}


- (UITextView *)htmlTextView
{
    if (!_htmlTextView) {
        _htmlTextView = [[UITextView alloc] init];
        _htmlTextView.scrollEnabled = NO;
        [_htmlTextView setEditable:NO];
        _htmlTextView.delegate = self;
        [_htmlTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _htmlTextView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    
    
    
}



//配置网络的
- (void)configureWebInfo{
    self.customWebView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.customWebView];
    
    self.webView.backgroundColor = [UIColor purpleColor];
    self.view.backgroundColor = [UIColor greenColor];
    
    NSError *error = nil;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithData:[self.oneLineString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:&error];
    [att addAttribute:NSFontAttributeName value:MyFont(15) range:NSMakeRange(0, att.length)];
    MyLog(@"%@",[error localizedDescription]);
    self.htmlTextView.frame = CGRectMake(15, 260, SCREENT_WIDTH - 30, 34);
    self.htmlTextView.attributedText = att;
    //    CGSize size = [self.htmlTextView sizeThatFits:CGSizeMake(SCREENT_WIDTH - 30, MAXFLOAT)];
    //    self.htmlTextView.height = size.height;
    
    CGSize widthSize = [self.htmlTextView sizeThatFits:CGSizeMake(MAXFLOAT, 34)];
    self.htmlTextView.width = widthSize.width;
    
    
    
    MyLog(@"TextViewFrame:%@",NSStringFromCGRect(self.htmlTextView.frame));
    MyLog(@"TextViewContentSize:%@",NSStringFromCGSize(self.htmlTextView.contentSize));
    [self.view addSubview:self.htmlTextView];
}


- (void)Finish
{
    self.model.custonWebView.height = self.model.realHeigth;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    MyLog(@"ZNWebTestController内存警告");
}

- (void)dealloc
{
    [ZNNoteCenter removeObserver:self];
    MyLog(@"ZNWebTestController销毁");
}

#pragma mark - 自定义WebView的代理
- (void)getCustomWebViewRealHeight:(CGFloat)realHeight
{
    self.customWebView.height = realHeight;
    MyLog(@"maxY:%.0f",CGRectGetMaxY(self.customWebView.frame));
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    MyLog(@"webView%@",request);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    MyLog(@"加载开始");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
     MyLog(@"加载结束");
    
    //处理js
//    [webView stringByEvaluatingJavaScriptFromString:[self getConfigureImgTagJS]];
    
    
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    jsContext[@"yuke"] = ^(){
        MyLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"方式二" message:@"这是OC原生的弹出窗" delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
            [alertView show];
        });
        
        for (JSValue *jsVal in args) {
            MyLog(@"%@", jsVal.toString);
        }
        
        MyLog(@"-------End Log-------");
    };
    
    
}

//处理图片的js
- (NSString *)getConfigureImgTagJS{
    return [NSString stringWithFormat:
            @"var imgs = document.getElementsByTagName('img');"
            "for (var i=0;i<imgs.length;i++){"
            "imgs[i].src = imgs[i].attributes['placeHoldrUrl'].nodeValue"
            "}"

            ];
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    MyLog(@"%@--范围%@",URL.relativeString,NSStringFromRange(characterRange));
    return NO;
}



@end
