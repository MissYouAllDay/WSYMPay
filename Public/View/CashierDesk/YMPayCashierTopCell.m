//
//  YMPayCashierTopCell.m
//  WSYMPay
//
//  Created by pzj on 2017/5/22.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPayCashierTopCell.h"
#import "YMBankCardDataModel.h"

@interface YMPayCashierTopCell ()
@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation YMPayCashierTopCell
- (void)selectQuitBtnMethod{}

- (void)setBankCardDataModel:(YMBankCardDataModel *)bankCardDataModel
{
    _bankCardDataModel = bankCardDataModel;
    if (_bankCardDataModel == nil) {
        return;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor  whiteColor];
        [self initViews];
    }
    return self;
}
- (void)initViews
{
    [self.contentView addSubview:[self mainTitleLabel]];
    [self.contentView addSubview:[self quitBtn]];
//    [self.contentView addSubview:[self lineView]];
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
//    [[self lineView]mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//        make.top.mas_equalTo(self.height-1);
//    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
