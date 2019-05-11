//
//  ProtocolViewController.m
//  WSYMPay
//
//  Created by MaKuiying on 16/9/23.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ProtocolViewController.h"
#import <WebKit/WebKit.h>
@interface ProtocolViewController ()<WKScriptMessageHandler>
@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务协议";
    [self setupSubviews];
}
-(void)setupSubviews
{
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    // 创建配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    [userContent addScriptMessageHandler:self name:@"NativeMethod"];
    
    // 将UserConttentController设置到配置文件
    config.userContentController = userContent;
    // WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) configuration:config];
    [self.view addSubview:webView];
    NSString *str = [[NSBundle mainBundle]pathForResource:@"agree" ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:str];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    [webView loadRequest:request];

}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@",message.body);
    
    if ([message.body isEqualToString:@"back"]) {
        YMLog(@"返回");
    } else {
        YMLog(@"同意");
        if (self.block) {
            self.block();
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"1");
}

@end
