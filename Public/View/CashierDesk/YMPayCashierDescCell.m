//
//  YMPayCashierDescCell.m
//  WSYMPay
//
//  Created by pzj on 2017/5/22.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPayCashierDescCell.h"

@interface YMPayCashierDescCell ()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation YMPayCashierDescCell

- (void)setMoneyString:(NSString *)moneyString
{
    _moneyString = moneyString;
    [self moneyLabel].text = [NSString stringWithFormat:@"¥%@",_moneyString];
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
    [self.contentView addSubview:[self descLabel]];
    [self.contentView addSubview:[self moneyLabel]];
//    [self.contentView addSubview:[self lineView]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self descLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-RIGHTSPACE);
        make.bottom.mas_equalTo(-(self.height/2));
        make.height.mas_equalTo(40);
    }];
    
    [[self moneyLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-RIGHTSPACE);
        make.top.mas_equalTo(self.height/2);
        make.height.mas_equalTo(40);
    }];
    
//    [[self lineView] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.height-1);
//        make.height.mas_equalTo(1);
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

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfMutableSize:16];
        _descLabel.textColor = FONTCOLOR;
        _descLabel.textAlignment = NSTextAlignmentCenter;
//        _descLabel.text = @"预付卡充值";
    }
    return _descLabel;
}
- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfMutableSize:23];
        _moneyLabel.textColor = FONTDARKCOLOR;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.text = @"¥100";
    }
    return _moneyLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBAlphaColor(0, 0, 0, 0.15);
    }
    return _lineView;
}
@end
