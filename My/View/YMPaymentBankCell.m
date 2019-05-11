//
//  YMPaymentBankCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPaymentBankCell.h"
#import "YMBankCardModel.h"
@interface YMPaymentBankCell ()

@property (nonatomic, weak) UIImageView *iconIV;

@property (nonatomic, weak) UILabel *bankInfoLabel;

@property (nonatomic, weak) UILabel *unavailableLabel;

@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, weak) UIImageView *selectedIV;

@end

@implementation YMPaymentBankCell

+(instancetype)configCell:(UITableView *)tableView withBankModel:(YMBankCardModel*)bankInfo
{
    static NSString *ID = @"YMPaymentBankCell";
    YMPaymentBankCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YMPaymentBankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [ImageViewTool setImage:cell.iconIV imageUrl:[bankInfo getLogoPicStr]];
    cell.enabled            = bankInfo.isFlag == 0;
    cell.bankInfoLabel.text = [bankInfo getBankStr];
//    cell.isSelected         = bankInfo.selected;
    [cell setNeedsLayout];
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupsubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _enabled = YES;
    }
    
    return self;
}

-(void)setupsubviews
{
    UIImageView *iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ABC#00947e"]];
    [self.contentView addSubview:iconIV];
    self.iconIV = iconIV;
    
    UILabel *bankInfoLabel  = [[UILabel alloc]init];
    bankInfoLabel.font      = COMMON_FONT;
    bankInfoLabel.textColor = FONTDARKCOLOR;
    [bankInfoLabel sizeToFit];
    [self.contentView addSubview:bankInfoLabel];
    self.bankInfoLabel = bankInfoLabel;
    
    UIImageView *selectedIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"payment_selected"]];
    selectedIV.hidden = YES;
    [self.contentView addSubview:selectedIV];
    self.selectedIV = selectedIV;
}

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

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.enabled) {
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFTSPACE);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(71/2);
        }];
        
        [self.bankInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).offset(LEFTSPACE);
            make.centerY.equalTo(self.contentView);
        }];
        
    } else {
        
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFTSPACE);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(71/2);
        }];
        
        [self.bankInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).offset(LEFTSPACE);
            make.bottom.equalTo(self.iconIV.mas_centerY);
        }];
        
        [_unavailableLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bankInfoLabel);
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

-(void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    self.unavailableLabel.hidden = _enabled;
    self.bgView.hidden           = _enabled;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.selectedIV.hidden = !_isSelected;
}

@end
