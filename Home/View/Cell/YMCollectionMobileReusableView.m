//
//  YMCollectionMobileReusableView.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/24.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCollectionMobileReusableView.h"
@interface YMCollectionMobileReusableView()
@property (nonatomic, strong) UILabel * titleL;
@end

@implementation YMCollectionMobileReusableView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleL];
    }
    return self;
}
-(UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfMutableSize:13];
        _titleL.text = @"选择充值金额";
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.textAlignment = NSTextAlignmentLeft;
        [_titleL sizeToFit];
    }
    return _titleL;
}
-(void)layoutSubviews
{
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.centerY.mas_equalTo(self.mas_centerY);
        
    }];
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleL.text = title;
}
@end
