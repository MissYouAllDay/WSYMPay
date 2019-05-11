//
//  YMTransferMoneyHeaderView.m
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferMoneyHeaderView.h"
#import "YMTransferCheckAccountDataModel.h"
#import "YMTransferToBankSearchFeeDataModel.h"

@interface YMTransferMoneyHeaderView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation YMTransferMoneyHeaderView

- (void)setModel:(YMTransferCheckAccountDataModel *)model
{
    _model = model;
    if (_model == nil) {
        return;
    }
    [self lineView].alpha = 0;
    [self nameLabel].text = [_model getCustNameStr];
    [self phoneLabel].text = [_model getUsrmpStr];
}

- (void)setToBankModel:(YMTransferToBankSearchFeeDataModel *)toBankModel
{
    _toBankModel = toBankModel;
    if (_toBankModel == nil) {
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
    [self lineView].alpha = 1;
    [self nameLabel].font = [UIFont systemFontOfSize:18];
    [self nameLabel].text = [NSString stringWithFormat:@"%@元",[_toBankModel getTxAmtStr]];
    [self phoneLabel].text = [_toBankModel getUserTransFeeStr];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  initViews];
    }
    return self;
}

- (void)initViews
{
    [self addSubview:[self nameLabel]];
    [self addSubview:[self phoneLabel]];
    [self addSubview:[self lineView]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self nameLabel]mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-RIGHTSPACE);
    }];
    [[self phoneLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-RIGHTSPACE);
    }];
    
    [[self lineView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height-0.5);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = COMMON_FONT;
        _nameLabel.textColor = FONTDARKCOLOR;
        _nameLabel.text = @"小马哥(*文采)";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfMutableSize:12];
        _phoneLabel.textColor = FONTCOLOR;
        _phoneLabel.text = @"151****1856";
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = lINECOLOR;
    }
    return _lineView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
