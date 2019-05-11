//
//  YMAllBillListCell.m
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillListCell.h"
#import "YMAllBillListDataListModel.h"

@interface YMAllBillListCell ()
//@property (nonatomic, strong) UILabel *oneLabel;
//@property (nonatomic, strong) UILabel *twoLabel;
//@property (nonatomic, strong) UILabel *moneyLabel;
//@property (nonatomic, strong) UILabel *payTypeLabel;
//@property (nonatomic, strong) UILabel *payStateLabel;
@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) UILabel *twoLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
//@property (nonatomic, strong) UILabel *payTypeLabel;
@property (nonatomic, strong) UILabel *payStateLabel;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic,strong)UILabel *useTypeLab;
@property (nonatomic,strong)UIImageView *iconV;
@property (nonatomic, strong)UIView *linView;
@end

@implementation YMAllBillListCell
- (void)setModel:(YMAllBillListDataListModel *)model
{
    _model = model;
    if (_model == nil) {
        return;
    }
    self.oneLabel.text = [_model getOrdDateStr];
    self.twoLabel.text = [_model getOrdTimeStr];
    self.moneyLabel.text = [_model getOrdTxAmtStr];
    self.nameLab.text = [_model getOrderMsgStr];
    if ([[_model getTranTypeStr] isEqualToString:@"1"]) {
        self.useTypeLab.text = @"消费";
    }
    else if ([[_model getTranTypeStr] isEqualToString:@"2"]) {
        self.useTypeLab.text = @"手机充值";
    }
    else if ([[_model getTranTypeStr] isEqualToString:@"3"]) {
        self.useTypeLab.text = @"充值";
    }
    else if ([[_model getTranTypeStr] isEqualToString:@"4"]) {
        self.useTypeLab.text = @"转账";
    }
    else {
        self.useTypeLab.text = @"提现";
    }
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
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.useTypeLab];
    [self.contentView addSubview:self.oneLabel];
    [self.contentView addSubview:self.twoLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.payStateLabel];
    [self.contentView addSubview:self.linView];
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
        make.bottom.mas_equalTo(self.contentView).mas_offset(KP6(-16));
    }];{
        [self.linView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self).mas_offset(KP6(0));
            make.height.mas_equalTo(KP6(8));
        }];
    }
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
-(UIView *)linView {
    if(!_linView) {
        _linView=[UIView new];
        _linView.backgroundColor=UIColorFromHex(0xf2f2f2);
    }
    return _linView;
}
-(UILabel *)nameLab {
    if(!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.text = @"XXX";
        _nameLab.textColor = UIColorFromHex(0x333333);
        _nameLab.font = COMMON_FONT;
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

//- (UILabel *)payTypeLabel
//{
//    if (!_payTypeLabel) {
//        _payTypeLabel = [[UILabel alloc] init];
//        _payTypeLabel.text = @"面对面收款";
//        _payTypeLabel.textColor = FONTCOLOR;
//        _payTypeLabel.numberOfLines = 0;
//        _payTypeLabel.font = [UIFont systemFontOfMutableSize:13];
//        _payTypeLabel.textAlignment = NSTextAlignmentRight;
//
//        [self.contentView addSubview:_payTypeLabel];
//        [_payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(50);
//            make.bottom.mas_equalTo(-30/2);
//            make.left.mas_equalTo(SCALEZOOM(360/2));
//            make.right.mas_equalTo(-LEFTSPACE);
//        }];
//    }
//    return _payTypeLabel;
//}

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

//- (void)setModel:(YMAllBillListDataListModel *)model
//{
//    _model = model;
//    if (_model == nil) {
//        return;
//    }
//    self.oneLabel.text = [_model getOrdDateStr];
//    self.twoLabel.text = [_model getOrdTimeStr];
//    self.moneyLabel.text = [_model getOrdTxAmtStr];
//    self.payTypeLabel.text = [_model getOrderMsgStr];
//    self.payStateLabel.text = [_model getOrdStatusStr];
//}
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.preservesSuperviewLayoutMargins = NO;
//        self.separatorInset = UIEdgeInsetsZero;
//        self.layoutMargins = UIEdgeInsetsZero;
//        [self initViews];
//    }
//    return self;
//}
//
//- (void)initViews
//{
//    [self.contentView addSubview:self.oneLabel];
//    [self.contentView addSubview:self.twoLabel];
//    [self.contentView addSubview:self.moneyLabel];
//    [self.contentView addSubview:self.payStateLabel];
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(30/2);
//        make.left.mas_equalTo(LEFTSPACE);
//        make.right.mas_equalTo(-SCALEZOOM(350/2));
//        make.height.mas_equalTo(30);
//    }];
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
//}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}
//- (UILabel *)oneLabel
//{
//    if (!_oneLabel) {
//        _oneLabel = [[UILabel alloc] init];
//        _oneLabel.text = @"04-08";
//        _oneLabel.textColor = FONTCOLOR;
//        _oneLabel.font = COMMON_FONT;
//    }
//    return _oneLabel;
//}
//- (UILabel *)twoLabel
//{
//    if (!_twoLabel) {
//        _twoLabel = [[UILabel alloc] init];
//        _twoLabel.text = @"12:15";
//        _twoLabel.textColor = FONTCOLOR;
//        _twoLabel.font = COMMON_FONT;
//    }
//    return _twoLabel;
//}
//- (UILabel *)moneyLabel
//{
//    if (!_moneyLabel) {
//        _moneyLabel = [[UILabel alloc] init];
//        _moneyLabel.text = @"+99.80";
//        _moneyLabel.textColor = FONTDARKCOLOR;
//        _moneyLabel.font = COMMON_FONT;
//        _moneyLabel.textAlignment = NSTextAlignmentRight;
//    }
//    return _moneyLabel;
//}
//
//- (UILabel *)payTypeLabel
//{
//    if (!_payTypeLabel) {
//        _payTypeLabel = [[UILabel alloc] init];
//        _payTypeLabel.text = @"面对面收款";
//        _payTypeLabel.textColor = FONTCOLOR;
//        _payTypeLabel.numberOfLines = 0;
//        _payTypeLabel.font = [UIFont systemFontOfMutableSize:13];
//        _payTypeLabel.textAlignment = NSTextAlignmentRight;
//
//        [self.contentView addSubview:_payTypeLabel];
//        [_payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(50);
//            make.bottom.mas_equalTo(-30/2);
//            make.left.mas_equalTo(SCALEZOOM(360/2));
//            make.right.mas_equalTo(-LEFTSPACE);
//        }];
//    }
//    return _payTypeLabel;
//}
//
//- (UILabel *)payStateLabel
//{
//    if (!_payStateLabel) {
//        _payStateLabel = [[UILabel alloc] init];
//        _payStateLabel.text = @"处理中";
//        _payStateLabel.textColor = NAVIGATIONBARCOLOR;
//        _payStateLabel.font = [UIFont systemFontOfMutableSize:13];
//        _payStateLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    return _payStateLabel;
//}

@end
