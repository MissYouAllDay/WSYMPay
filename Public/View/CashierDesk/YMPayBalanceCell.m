//
//  YMPayBalanceCell.m
//  WSYMPay
//
//  Created by pzj on 2017/5/24.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPayBalanceCell.h"
#import "YMBankCardDataModel.h"
#import "YMUserInfoTool.h"

static CGFloat const interval = LEFTSPACE * 0.8;//section 0 本地固定

@interface YMPayBalanceCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *enableBgView;
@end

@implementation YMPayBalanceCell

- (void)sendBankCardDataModel:(YMBankCardDataModel *)model isSelect:(BOOL)isSelect{
    if (isSelect) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payment_selected"]];
    }else{
        self.accessoryView = nil;
    }
    
    YMUserInfoTool *currentUserInfo = [YMUserInfoTool shareInstance];
    [self nameLabel].text = [NSString stringWithFormat:@"余额%@元",[currentUserInfo getCashAcBalStr]];
    
    if ([model getIsAcbalUse]) {//余额可选
        [self enableBgView].hidden = YES;
    }else{
        [self enableBgView].hidden = NO;
    }
//    if ([model isAcbalUsed]) {//余额可选
//        [self enableBgView].hidden = YES;
//    }else{
//        [self enableBgView].hidden = NO;
//    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}
- (void)initViews
{
    [self.contentView addSubview:[self iconImageView]];
    [self.contentView addSubview:[self nameLabel]];
    [self.contentView addSubview:[self enableBgView]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [[self iconImageView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(interval);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(71/2);
        make.height.mas_equalTo(71/2);
    }];
    
    [[self nameLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset((interval * 0.5)+5);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
    }];
    
    [[self enableBgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"balanceImg"];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = COMMON_FONT;
        _nameLabel.textColor = FONTDARKCOLOR;
        _nameLabel.text = @"余额支付";
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
}

- (UIView *)enableBgView
{
    if (!_enableBgView) {
        _enableBgView = [[UIView alloc] init];
        _enableBgView.backgroundColor = [UIColor whiteColor];
        _enableBgView.alpha = 0.5;
    }
    return _enableBgView;
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
