//
//  YMCustomFooter.m
//  WSYMPay
//
//  Created by pzj on 2017/3/16.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCustomFooter.h"

@interface YMCustomFooter ()

@property (nonatomic, weak) UIImageView *noMore;
@property (weak, nonatomic) UILabel *label;
@property (nonatomic, weak) UIActivityIndicatorView *loading;

@end

@implementation YMCustomFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    //这里可以添加一个没有更多的图片展示，临时先随便填了一个图片名
    UIImageView *noMoreImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoMoreData"]];
    [self addSubview:noMoreImage];
    noMoreImage.hidden = YES;
    self.noMore = noMoreImage;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = MJRefreshLabelTextColor;
    label.font = MJRefreshLabelFont;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.noMore.y = 5;
    self.noMore.height = 45;
    self.noMore.width = 73.5;
    self.noMore.centerX = [[UIScreen mainScreen] bounds].size.width / 2;
    self.label.frame = self.bounds;
    //
    self.loading.center = CGPointMake(self.width * 0.5 - 60, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"上拉加载更多";
            [self.loading stopAnimating];
            self.noMore.hidden = YES;
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"加载数据中...";
            [self.loading startAnimating];
            self.noMore.hidden = YES;
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"没有更多";
            [self.loading stopAnimating];
            self.noMore.hidden = YES;
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
