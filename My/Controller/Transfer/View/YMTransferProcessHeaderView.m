//
//  YMTransferProcessHeaderView.m
//  WSYMPay
//
//  Created by pzj on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferProcessHeaderView.h"
#import "YMTransferCheckPayPwdDataModel.h"

@interface YMTransferProcessHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation YMTransferProcessHeaderView

- (void)setModel:(YMTransferCheckPayPwdDataModel *)model
{
    _model = model;
    if (_model == nil) {
        return;
    }
    [self titleLabel].text = @"转账申请已提交,等待处理结果";
    [self moneyLabel].text = [_model getTransferChuLiTxAmtStr];
    [self timeLabel].text = @"预计2小时到账";
}
#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self  initViews];
    }
    return self;
}
#pragma mark - privateMethods               - Method -
- (void)initViews
{
    [self addSubview:[self titleLabel]];
    [self addSubview:[self moneyLabel]];
    [self addSubview:[self timeLabel]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [[self titleLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-RIGHTSPACE);
        make.height.mas_equalTo(30);
    }];
    
    [[self moneyLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-RIGHTSPACE);
        make.height.mas_equalTo(30);
    }];
    
    [[self timeLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moneyLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-RIGHTSPACE);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - getters and setters          - Method -
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = COMMON_FONT;
        _titleLabel.textColor = FONTDARKCOLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfMutableSize:18];
        _moneyLabel.textColor = FONTDARKCOLOR;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfMutableSize:12];
        _timeLabel.textColor = FONTCOLOR;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
