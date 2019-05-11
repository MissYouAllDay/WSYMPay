//
//  YMCustomWebVC.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/8.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface YMCustomWebVC : UIViewController
@property (weak, nonatomic) WKWebView *webView;
@property (nonatomic, copy) NSString *loadUrl;
-(void)getPayOrder:(NSString *)prdOrdNo merNo:(NSString *)merNo;
@end
