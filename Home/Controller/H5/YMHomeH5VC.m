//
//  YMHomeH5VC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/8.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMHomeH5VC.h"

@interface YMHomeH5VC ()

@end

@implementation YMHomeH5VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"加载中...";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
