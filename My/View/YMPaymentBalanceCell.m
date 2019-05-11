//
//  YMPaymentBalanceCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPaymentBalanceCell.h"

@interface YMPaymentBalanceCell ()

@property (nonatomic, weak) UIImageView *iconIV;

@property (nonatomic, weak) UILabel *balanceLabel;

@property (nonatomic, weak) UIImageView *selectedIV;

@property (nonatomic, weak) UILabel *unavailableLabel;

@property (nonatomic, weak) UIView *bgView;
@end

@implementation YMPaymentBalanceCell

-(UILabel *)unavailableLabel
{
    if (!_unavailableLabel) {
        UILabel *unavailableLabel      = [[UILabel alloc]init];
        unavailableLabel.text          = @"当前交易不支持该支付方式";
        unavailableLabel.textColor     = FONTDARKCOLOR;
        unavailableLabel.textAlignment = NSTextAlignmentLeft;
        unavailableLabel.font          = [UIFont systemFontOfMutableSize:13];
        [self.contentView addSubview:unavailableLabel];
        _unavailableLabel = unavailableLabel;
    }
    return _unavailableLabel;
}

-(UIView *)bgView
{
    if (!_bgView) {
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.alpha = 0.6;
        bgView.userInteractionEnabled = NO;
        [self.contentView addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    
    return self;
}

-(void)setupSubviews
{
    UIImageView *iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"balanceImg"]];
    [self.contentView addSubview:iconIV];
    self.iconIV = iconIV;
    
    UIImageView *selectedIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"payment_selected"]];
    selectedIV.hidden = YES;
    [self.contentView addSubview:selectedIV];
    self.selectedIV = selectedIV;
    
    UILabel *balanceLabel  = [[UILabel alloc]init];
    balanceLabel.font      = COMMON_FONT;
    balanceLabel.textColor = FONTDARKCOLOR;
    [self.contentView addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.enabled) {
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFTSPACE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.balanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).offset(LEFTSPACE);
            make.centerY.equalTo(self.contentView);
        }];
        
    } else {
        
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFTSPACE);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(71/2);
        }];
        
        [self.balanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).offset(LEFTSPACE);
            make.bottom.equalTo(self.iconIV.mas_centerY);
        }];
        
        [_unavailableLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.balanceLabel);
            make.top.equalTo(self.iconIV.mas_centerY);
        }];
        
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    
    [self.selectedIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-LEFTSPACE);
        make.centerY.equalTo(self.contentView);
    }];
    
    
}


+(instancetype)configCell:(UITableView *)tableview withMoney:(NSString *)money
{
    static NSString *ID = @"YMPaymentBalanceCell";
    YMPaymentBalanceCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YMPaymentBalanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.balanceLabel.text = [NSString stringWithFormat:@"余额%@元",money];
    [cell.balanceLabel sizeToFit];
    [cell setNeedsLayout];
    return cell;
    
}

-(void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    self.unavailableLabel.hidden = _enabled;
    self.bgView.hidden           = _enabled;
    [self sizeToFit];
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    self.selectedIV.hidden = !_isSelected;
}

@end
