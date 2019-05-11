//
//  YMCheckUpdateVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCheckUpdateVC.h"
#import "YMPublicHUD.h"
@interface YMCheckUpdateVC ()

@end

@implementation YMCheckUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [WSYMNSNotification addObserver:self
                        selector:@selector(popUpAlert)
                            name:UIApplicationWillEnterForegroundNotification
                          object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self popUpAlert];
}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

-(void)popUpAlert
{
    [YMPublicHUD showAlertView:@"新版本" message:@"有新的版本可供更新，如不更新APP将不可使用" cancelTitle:@"立即更新" handler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_ymqbURL_ios]];
    }];
}

@end
