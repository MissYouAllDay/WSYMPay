//
//  YMCustomHeader.m
//  WSYMPay
//
//  Created by W-Duxin on 16/10/25.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCustomHeader.h"

@implementation YMCustomHeader

-(void)prepare
{
    [super prepare];
    
    self.automaticallyChangeAlpha    = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
}


@end
