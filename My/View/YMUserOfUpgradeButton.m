//
//  YMUserOfUpgradeButton.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/7.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMUserOfUpgradeButton.h"
#import "UIView+Extension.h"
@interface YMUserOfUpgradeButton ()

@property (nonatomic, strong) UIImageView *noticeImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation YMUserOfUpgradeButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setTitle:@"升级账户,提升余额支付额度"forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:10]];
        [self setTitleColor:NAVIGATIONBARCOLOR forState:UIControlStateNormal];
        [self setBackgroundColor:RGBColor(250, 233, 199)];
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

-(UIImageView *)noticeImageView
{
    if (!_noticeImageView) {
        
        _noticeImageView = [[UIImageView alloc]init];
        _noticeImageView.image = [UIImage imageNamed:@"notice"];
        [_noticeImageView sizeToFit];
        
        [self addSubview:_noticeImageView];
    }
    return _noticeImageView;
}

-(UIImageView *)rightImageView
{
    if (!_rightImageView) {
        
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.image = [UIImage imageNamed:@"left_right_red"];
        [_rightImageView sizeToFit];
        
        [self addSubview:_rightImageView];
    }
    return _rightImageView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat interval = self.width * 0.02;
    
    self.noticeImageView.centerY = self.centerY;
    self.noticeImageView.x       = interval;
    
    self.titleLabel.height  = self.height;
    self.titleLabel.width   = self.width * 0.6;
    self.titleLabel.x       = self.noticeImageView.right + interval;
    self.titleLabel.centerY = self.centerY;
    
    self.rightImageView.centerY = self.centerY;
    self.rightImageView.right   = self.width - self.rightImageView.width - interval;
}


@end
