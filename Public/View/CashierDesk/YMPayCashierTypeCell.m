//
//  YMPayCashierTypeCell.m
//  WSYMPay
//
//  Created by pzj on 2017/5/22.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPayCashierTypeCell.h"

@interface YMPayCashierTypeCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *payTypeLabel;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation YMPayCashierTypeCell

- (void)setPayTypeString:(NSString *)payTypeString
{
    _payTypeString = payTypeString;
    [self payTypeLabel].text = _payTypeString;
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
    [self.contentView addSubview:[self titleLabel]];
    [self.contentView addSubview:[self payTypeLabel]];
    [self.contentView addSubview:[self topLineView]];
    [self.contentView addSubview:[self bottomLineView]];

//    self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self titleLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [[self payTypeLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-(RIGHTSPACE));
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [[self topLineView]mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(0);
    }];

    [[self bottomLineView]mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.height-0.5);
    }];

}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfMutableSize:15];
        _titleLabel.textColor = FONTCOLOR;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel sizeToFit];
        _titleLabel.text = @"支付方式";
    }
    return _titleLabel;
}

- (UILabel *)payTypeLabel
{
    if (!_payTypeLabel) {
        _payTypeLabel = [[UILabel alloc] init];
        _payTypeLabel.font = [UIFont systemFontOfMutableSize:15];
        _payTypeLabel.textColor = FONTCOLOR;
        _payTypeLabel.textAlignment = NSTextAlignmentRight;
        [_payTypeLabel sizeToFit];
        _payTypeLabel.text = @"临时显示余额支付";
    }
    return _payTypeLabel;
}
- (UIView *)topLineView
{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = RGBAlphaColor(0, 0, 0, 0.15);
    }
    return _topLineView;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = RGBAlphaColor(0, 0, 0, 0.15);
    }
    return _bottomLineView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
