//
//  YMCustomWebVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/8.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCustomWebVC.h"
@interface YMCustomWebVC ()<WKScriptMessageHandler,WKNavigationDelegate>
@property (weak, nonatomic) CALayer *progresslayer;
@end

@implementation YMCustomWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewUserAgent];
    [self setupWebView];
    [self setupProgress];
}


#pragma mark - 初始化
-(void)setupNewUserAgent
{
    // 给User-Agent添加额外的信息
    NSString *newAgent = [NSString stringWithFormat:@"%@",@"app/wsym/ios"];
    // 设置global User-Agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

-(void)setupWebView
{
    // 创建配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    [userContent addScriptMessageHandler:self name:@"NativeMethod"];
    // 将UserConttentController设置到配置文件
    config.userContentController = userContent;
    WKWebView *webView           = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)setupProgress
{
    //添加属性监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    //进度条
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer        = [CALayer layer];
    layer.frame           = CGRectMake(0, 0, 0, 2);
    layer.backgroundColor = RGBColor(14, 138, 164).CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
}

#pragma mark - KVO 进度条监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%@", change);
        self.progresslayer.opacity = 1;
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 2);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 2);
            });
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
            
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}


#pragma mark - WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSRange range = [message.body rangeOfString:@"WSYM_"];
    if (range.location != NSNotFound) {
        NSString *newStr = [message.body substringFromIndex:range.length];
        NSRange range = [newStr rangeOfString:@","];
        
        if (range.location != NSNotFound) {
            NSString *prdOrdNo = [newStr substringToIndex:range.location];
            NSString *merNo    = [newStr substringFromIndex:range.location + 1];
            [self getPayOrder:prdOrdNo merNo:merNo];
        }
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

-(void)getPayOrder:(NSString *)prdOrdNo merNo:(NSString *)merNo
{
    
}

@end
