//
//  YMBillRecordListTabCell.m
//  WSYMPay
//
//  Created by junchiNB on 2019/4/23.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import "YMBillRecordListTabCell.h"
#import "YMAllBillListDataListModel.h"
@interface YMBillRecordListTabCell ()
@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) UILabel *twoLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *payTypeLabel;
@property (nonatomic, strong) UILabel *payStateLabel;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic,strong)UILabel *useTypeLab;
@property (nonatomic,strong)UIImageView *iconV;
@end
@implementation YMBillRecordListTabCell

- (void)setModel:(YMAllBillListDataListModel *)model
{
    _model = model;
    if (_model == nil) {
        return;
    }
    self.oneLabel.text = [_model getOrdDateStr];
    self.twoLabel.text = [_model getOrdTimeStr];
    self.moneyLabel.text = [_model getOrdTxAmtStr];
    self.payTypeLabel.text = [_model getOrderMsgStr];
    self.payStateLabel.text = [_model getOrdStatusStr];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.useTypeLab];
    [self.contentView addSubview:self.oneLabel];
    [self.contentView addSubview:self.twoLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.payStateLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(SCALEZOOM(36));
        make.top.mas_equalTo(self.contentView).mas_offset(SCALEZOOM(16));
    }];
    [self.useTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
        make.top.mas_equalTo(self.nameLab.mas_bottom).mas_offset(SCALEZOOM(4));
    }];
   
    [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.useTypeLab.mas_bottom).mas_offset(SCALEZOOM(4));
        make.left.mas_equalTo(self.nameLab);
//        make.left.mas_equalTo(LEFTSPACE);
//        make.right.mas_equalTo(-SCALEZOOM(350/2));
//        make.height.mas_equalTo(30);
    }];
    [self.twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.useTypeLab.mas_bottom).mas_offset(SCALEZOOM(4));
        make.left.mas_equalTo(self.oneLabel.mas_right).mas_offset(SCALEZOOM(4));
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(SCALEZOOM(-12));
        make.centerY.mas_equalTo(self.nameLab);
    }];
    [self.payStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.moneyLabel);
        make.top.mas_equalTo(self.moneyLabel.mas_bottom).mas_offset(SCALEZOOM(4));
    }];
//
//    [self.twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.oneLabel.mas_bottom);
//        make.height.mas_equalTo(25);
//        make.left.mas_equalTo(LEFTSPACE);
//        make.right.mas_equalTo(-SCALEZOOM(350/2));
//    }];
//
//    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(30/2);
//        make.left.mas_equalTo(SCALEZOOM(350/2));
//        make.right.mas_equalTo(-LEFTSPACE);
//        make.height.mas_equalTo(30);
//    }];
//
//    [self.payStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(60/2);
//        make.height.mas_equalTo(30);
//        make.left.mas_equalTo(SCALEZOOM(230/2));
//        make.right.mas_equalTo(-SCALEZOOM(350/2));
//    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(UILabel *)nameLab {
    if(!_nameLab) {
        _oneLabel = [[UILabel alloc] init];
        _oneLabel.text = @"04-08";
        _oneLabel.textColor = FONTDARKCOLOR;
        _oneLabel.font = COMMON_FONT;
    }
    return _nameLab;
}
-(UILabel *)useTypeLab {
    if(!_useTypeLab) {
        _useTypeLab = [[UILabel alloc] init];
        _useTypeLab.text = @"交通出行";
        _useTypeLab.textColor = FONTDARKCOLOR;
        _useTypeLab.font = COMMON_FONT;
    }
    return _useTypeLab;
}
-(UIImageView *)iconV {
    if(!_iconV) {
        _iconV=[[UIImageView alloc]initWithImage: [UIImage imageNamed:@""]];
    }
    return _iconV;
}
- (UILabel *)oneLabel
{
    if (!_oneLabel) {
        _oneLabel = [[UILabel alloc] init];
        _oneLabel.text = @"04-08";
        _oneLabel.textColor = FONTCOLOR;
        _oneLabel.font = COMMON_FONT;
    }
    return _oneLabel;
}
- (UILabel *)twoLabel
{
    if (!_twoLabel) {
        _twoLabel = [[UILabel alloc] init];
        _twoLabel.text = @"12:15";
        _twoLabel.textColor = FONTCOLOR;
        _twoLabel.font = COMMON_FONT;
    }
    return _twoLabel;
}
- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"+99.80";
        _moneyLabel.textColor = FONTDARKCOLOR;
        _moneyLabel.font = COMMON_FONT;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UILabel *)payTypeLabel
{
    if (!_payTypeLabel) {
        _payTypeLabel = [[UILabel alloc] init];
        _payTypeLabel.text = @"面对面收款";
        _payTypeLabel.textColor = FONTCOLOR;
        _payTypeLabel.numberOfLines = 0;
        _payTypeLabel.font = [UIFont systemFontOfMutableSize:13];
        _payTypeLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_payTypeLabel];
        [_payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.bottom.mas_equalTo(-30/2);
            make.left.mas_equalTo(SCALEZOOM(360/2));
            make.right.mas_equalTo(-LEFTSPACE);
        }];
    }
    return _payTypeLabel;
}

- (UILabel *)payStateLabel
{
    if (!_payStateLabel) {
        _payStateLabel = [[UILabel alloc] init];
        _payStateLabel.text = @"处理中";
        _payStateLabel.textColor = NAVIGATIONBARCOLOR;
        _payStateLabel.font = [UIFont systemFontOfMutableSize:13];
        _payStateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _payStateLabel;
}


@end
