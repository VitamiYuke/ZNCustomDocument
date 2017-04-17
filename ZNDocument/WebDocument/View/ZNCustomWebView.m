//
//  ZNCustomWebView.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/30.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNCustomWebView.h"
#import <WebKit/WebKit.h>

@interface ZNCustomWebView ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic, strong)WKWebView *webView;

@property(nonatomic, copy)NSString *htmlString;

@end



@implementation ZNCustomWebView


- (WKWebView *)webView
{
    if (!_webView) {
        
        /*
         // JavaScript的配置
         //查找图片
         NSString *searchImgJS = @"var imgCount = document.images.length; for (var i = 0; i < imgCount;i++){var image = document.images[i]; image.style.height = 320;}     window.alert('找到' + imgCount + '张图片'); ";
         //根据js字符串初始化WKUserScript对象
         WKUserScript *script = [[WKUserScript alloc] initWithSource:searchImgJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
         
         //根据生成的WKUserScript对象，初始化WKWebViewConfiguration
         WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
         [config.userContentController addUserScript:script];
         */
        _webView = [[WKWebView alloc] init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _webView;
}

- (instancetype)init
{
    if ([super init]) {
        [self configureUI];
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}


- (void)configureUI
{
    [self addSubview:self.webView];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    if (self.htmlString) {
        [self.webView loadHTMLString:[self getCustomHtmlWithContent:self.htmlString] baseURL:nil];
    }
    
}



- (instancetype)initWithFrame:(CGRect)frame andHtmlString:(NSString *)htmlString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.htmlString = htmlString;
        [self configureUI];
    }
    return self;
}


- (void)loadingCustomHtmlString:(NSString *)htmlString
{
    
    NSString *customHtml = [self getCustomHtmlWithContent:htmlString];
    [self.webView loadHTMLString:customHtml baseURL:nil];
}



- (NSString *)getCustomHtmlWithContent:(NSString *)content
{
    NSString *customString = [NSString stringWithFormat:
                              @"<html>"
                              "<head>"
                              "<meta charset='utf-8' name='viewport' content='width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no'/>"
                              
                              "<style type=\"text/css\">"
                              "#webview_content_wrapper a:link {"
                              "color:#0E89E1;"
                              "text-decoration:none;" //
                              "}"
                              "#webview_content_wrapper {"
                              "font-size:16px"
                              "}"
                              "img {"
                              "max-width:100%%;"
                              "width:auto;"
                              "height:auto;"
                              "-webkit-tap-highlight-color:rgba(0,0,0,0);"
                              "}"
                              "</style>"
                              "</head>"
                              "<body>"
                              "<div id=\"webview_content_wrapper\" style ='width:%.0fpx'>%@</div>" //
                              "</body>"
                              "</html>",self.frame.size.width - 16,content];
    MyLog(@"自定义完成的Html%@",customString);
    return customString;
}




#pragma mark - WKUIdelegate
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 调用警告框消失
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    MyLog(@"弹出警告框%@--%@",message,frame);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:confirmAction];
    [[ZNRegularHelp getCurrentShowViewController] presentViewController:alertController animated:YES completion:^{
    }];
    completionHandler();
    
}
/**
 *  web界面中有弹出确认框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           确认框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 调用确认框消失
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    MyLog(@"弹出确认框%@",message);
    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] show];
    completionHandler(YES);
}
/**
 *  web界面中有弹出输入框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param defaultText       初始文本显示在文本输入字段。
 *  @param frame             主窗口
 *  @param completionHandler 调用输入框消失
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    MyLog(@"弹出输入框%@",defaultText);
    completionHandler(@"ZhangNanBoy");
}


//创建一个新的webView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//
//}

#pragma mark -WKWebView加载回调的方法 WKNavigationDelegate
//页面开始加载时的调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    MyLog(@"页面开始加载链接:%@--%@",webView.URL,navigation);
}
//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    MyLog(@"内容开始返回链接:%@",webView.URL);
}
//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    MyLog(@"加载完成链接:%@",webView.URL);
    
    
    [webView evaluateJavaScript:@"document.body.offsetWidth" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        MyLog(@"评估完成的宽度:%@",obj);
    }];
    
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        MyLog(@"评估完成%@",obj);
        CGFloat height = [(NSString *)obj floatValue];
        webView.frame = CGRectMake(0, 0, self.frame.size.width, height);
        MyLog(@"webFrame:%@",NSStringFromCGRect(webView.frame));
        MyLog(@"scrollViewContent:%@",NSStringFromCGSize(webView.scrollView.contentSize));
        //获取内容实际高度（像素）
        [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
             MyLog(@"最新评估完成%@",obj);
            CGFloat realHeight = [(NSString *)obj floatValue];
            _realHeight = realHeight;
            if (self.delegate) {
               [self.delegate getCustomWebViewRealHeight:self.realHeight];
            }
           MyLog(@"错误:%@",[error localizedDescription]);
        }];
        MyLog(@"错误:%@",[error localizedDescription]);
        
    }];
    
}
//页面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    MyLog(@"页面加载失败%@",[error localizedDescription]);
    
}
//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    MyLog(@"接收到服务器链接:%@",webView.URL);
}
// 在发送请求之前,决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    MyLog(@"在发送请求之前链接:%@",webView.URL);
    MyLog(@"%@",navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    MyLog(@"在收到响应后链接:%@",webView.URL);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - WKScriptMessageHandler
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    MyLog(@"%@",message);
}






@end
