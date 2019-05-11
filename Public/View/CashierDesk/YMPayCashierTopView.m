//
//  YMPayCashierTopView.m
//  WSYMPay
//
//  Created by pzj on 2017/5/23.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPayCashierTopView.h"

@interface YMPayCashierTopView ()
@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation YMPayCashierTopView
- (void)selectQuitBtnMethod{}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    [self mainTitleLabel].text = _titleStr;
    if ([_titleStr isEqualToString:@"选择支付方式"]) {
        self.lineView.alpha = 1;
    }else{
        self.lineView.alpha = 1;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self addSubview:[self mainTitleLabel]];
    [self addSubview:[self quitBtn]];
    [self addSubview:[self lineView]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self mainTitleLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [[self quitBtn]mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(29);
        make.top.mas_equalTo((self.height-29)/2);
    }];
    [[self lineView]mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.height-0.5);
    }];
}
- (UILabel *)mainTitleLabel
{
    if (!_mainTitleLabel) {
        _mainTitleLabel = [[UILabel alloc] init];
        _mainTitleLabel.font = [UIFont systemFontOfMutableSize:16];
        _mainTitleLabel.textAlignment = NSTextAlignmentCenter;
        _mainTitleLabel.textColor = FONTDARKCOLOR;
        _mainTitleLabel.text = @"支付详情";
    }
    return _mainTitleLabel;
}
- (UIButton *)quitBtn
{
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitBtn setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
        [_quitBtn addTarget:self action:@selector(quitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBAlphaColor(0, 0, 0, 0.15);
    }
    return _lineView;
}
- (void)quitBtnClick
{
    YMLog(@"退出收银台。。。");
    if ([self.delegate respondsToSelector:@selector(selectQuitBtnMethod)]) {
        [self.delegate selectQuitBtnMethod];
    }
}

@end
