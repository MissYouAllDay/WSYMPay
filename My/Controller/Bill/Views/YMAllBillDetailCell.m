//
//  YMAllBillDetailCell.m
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillDetailCell.h"
#import "YMAllBillDetailDataModel.h"

//BillDetailConsumeMobilePhoneRecharge         = 0,//消费---手机话费充值
//BillDetailConsumeScan                        = 1,//消费---扫一扫超级收款码
//BillDetailPCScan                             = 1,//扫一扫pc端生成的二维码
//BillDetailTX                                 = 1,//TX
//BillDetailAccountTransfer                    = 2,//转账(我要收款/ 扫一扫有名收款码)

@interface YMAllBillDetailCell ()

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end
@implementation YMAllBillDetailCell
- (void)sendBillDetailType:(BillDetailType)billDetailType section:(NSInteger)section row:(NSInteger)row model:(YMAllBillDetailDataModel *)model {
    if (section == 0) {
        switch (row) {
            case 0:
                self.keyLabel.text = @"付款方式";
                self.valueLabel.text = [model getPayMentMeethodStr];
                break;
            case 1:
                self.keyLabel.text = @"转账说明";
                self.valueLabel.text = [model getOrderMsgStr];
                break;
            case 2:
                self.keyLabel.text = @"对方账户";
                self.valueLabel.text = [model getTragetNoStr];
                break;
            case 3:
                self.keyLabel.text = @"创建时间";
                self.valueLabel.text = [model getAccountChonZhiTimeStr];
                break;
            case 4:
                self.keyLabel.text = @"交易单号";
                self.valueLabel.text = [model getTraOrdNoStr];
                break;
            default:
                break;
        }
    }
    else {

        self.keyLabel.text = row == 0 ? @"订单疑问反馈" : @"订单撤销";
    }
}
//- (void)sendBillDetailType:(BillDetailType)billDetailType section:(NSInteger)section row:(NSInteger)row model:(YMAllBillDetailDataModel *)model
//{
//    if (billDetailType == BillDetailConsumeMobilePhoneRecharge) {//消费---手机话费充值
//        if (section == 0) {
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"付款方式";
//                    self.valueLabel.text = [model getPayMentMeethodStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"充值说明";
//                    self.valueLabel.text = [model getChonZhiDescStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"充值号码";
//                    self.valueLabel.text = [model getPhoneNumberStr];
//                    break;
//                case 3:
//                    self.keyLabel.text = @"面值";
//                    self.valueLabel.text = [model getProdContentStr];
//                    break;
//                case 4:
//                    self.keyLabel.text = @"交易对象";
//                    self.valueLabel.text = [model getProdispTypeStr];
//                    break;
//                default:
//                    break;
//            }
//        }else if (section == 1){
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"创建时间";
//                    self.valueLabel.text = [model getPhoneOrderTimeStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"商品订单号";
//                    self.valueLabel.text = [model getShangPinDingDanHaoStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"支付流水号";
//                    self.valueLabel.text = [model getZhiFuLiuShuiHaoStr];
//                    break;
//                default:
//                    break;
//            }
//
//        }else{
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"投诉状态";
//                    self.valueLabel.text = [model getAcceptStateStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"投诉原因";
//                    self.valueLabel.text = [model getComRemarkStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"投诉处理说明";
//                    self.valueLabel.text = [model getHandleRemarkStr];
//                    break;
//                default:
//                    break;
//            }
//        }
//    /****************/
//    }else if (billDetailType == BillDetailAccountTransfer){//转账(我要收款/ 扫一扫有名收款码)
//        if (section == 0) {
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"付款方式";
//                    self.valueLabel.text = [model getPayMentMeethodStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"转账说明";
//                    self.valueLabel.text = [model getOrderMsgStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"对方账户";
//                    self.valueLabel.text = [model getTragetNoStr];
//                    break;
//                default:
//                    break;
//            }
//        }else if (section == 1){
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"创建时间";
//                    self.valueLabel.text = [model getOrderTimeStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"支付流水号";
//                    self.valueLabel.text = [model getTraOrdNoStr];
//                    break;
//                default:
//                    break;
//            }
//        }else{
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"投诉状态";
//                    self.valueLabel.text = [model getAcceptStateStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"投诉原因";
//                    self.valueLabel.text = [model getComRemarkStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"投诉处理说明";
//                    self.valueLabel.text = [model getHandleRemarkStr];
//                    break;
//                default:
//                    break;
//            }
//        }
//     /****************/
//    }else if(billDetailType == BillDetailConsumeScan){//消费---扫一扫超级收款码/扫一扫pc端生成的二维码/TX
//        if (section == 0) {
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"付款方式";
//                    self.valueLabel.text = [model getPayMentMeethodStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"商品信息";
//                    self.valueLabel.text = [model getShangPinXinXiStr];
//                    break;
//                default:
//                    break;
//            }
//        }else if (section == 1){
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"创建时间";
//                    self.valueLabel.text = [model getOrderTimeStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"商品订单号";
//                    self.valueLabel.text = [model getShangPinDingDanHaoStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"支付流水号";
//                    self.valueLabel.text = [model getZhiFuLiuShuiHaoStr];
//                    break;
//                default:
//                    break;
//            }
//        }else{
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"投诉状态";
//                    self.valueLabel.text = [model getAcceptStateStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"投诉原因";
//                    self.valueLabel.text = [model getComRemarkStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"投诉处理说明";
//                    self.valueLabel.text = [model getHandleRemarkStr];
//                    break;
//                default:
//                    break;
//            }
//        }
//    /***********/
//    }else if (billDetailType == BillDetailAccountRecharge){//账户充值
//        if (section == 0) {
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"交易名称";
//                    self.valueLabel.text = @"充值";
//                    break;
//                case 1:
//                    self.keyLabel.text = @"充值时间";
//                    self.valueLabel.text = [model getAccountChonZhiTimeStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"交易状态";
//                    self.valueLabel.text = [model getXiaoFeiOrderStatusStr];
//                    break;
//                case 3:
//                    self.keyLabel.text = @"交易单号";
//                    self.valueLabel.text = [model getAccountChonZhiDanHaoStr];
//                    break;
//                case 4:
//                    self.keyLabel.text = @"支付方式";
//                    self.valueLabel.text = [model getPayMentMeethodStr];
//                    break;
//
//                default:
//                    break;
//            }
//        }else if(section == 2){
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"投诉状态";
//                    self.valueLabel.text = [model getAcceptStateStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"投诉原因";
//                    self.valueLabel.text = [model getComRemarkStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"投诉处理说明";
//                    self.valueLabel.text = [model getHandleRemarkStr];
//                    break;
//                default:
//                    break;
//            }
//        }
//    /***********/
//    }else if (billDetailType == BillDetailAccountWithDrawal){//账户提现
//        if (section == 0) {
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"交易名称";
//                    self.valueLabel.text = @"提现";
//                    break;
//                case 1:
//                    self.keyLabel.text = @"申请时间";
//                    self.valueLabel.text = [model getAccountTiXianShenQingTimeStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"到账时间";
//                    self.valueLabel.text = [model getAccountTiXianDaoZhangTimeStr];
//                    break;
//                case 3:
//                    self.keyLabel.text = @"交易状态";
//                    self.valueLabel.text = [model getAccountOrdStatusCodeStr];
//                    break;
//                case 4:
//                    self.keyLabel.text = @"支付单号";
//                    self.valueLabel.text = [model getAccountCasOrdNoStr];
//                    break;
//                case 5:
//                    self.keyLabel.text = @"转出至";
//                    self.valueLabel.text = [model getPayMentMeethodStr];
//                    break;
//                default:
//                    break;
//            }
//        }else if(section == 2){
//            switch (row) {
//                case 0:
//                    self.keyLabel.text = @"投诉状态";
//                    self.valueLabel.text = [model getAcceptStateStr];
//                    break;
//                case 1:
//                    self.keyLabel.text = @"投诉原因";
//                    self.valueLabel.text = [model getComRemarkStr];
//                    break;
//                case 2:
//                    self.keyLabel.text = @"投诉处理说明";
//                    self.valueLabel.text = [model getHandleRemarkStr];
//                    break;
//                default:
//                    break;
//            }
//        }
//        /***********/
//    }
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)keyLabel
{
    if (!_keyLabel) {
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.text = @"key";
        _keyLabel.textColor = FONTCOLOR;
        _keyLabel.font = [UIFont systemFontOfMutableSize:12];
        _keyLabel.numberOfLines = 0;
        [self.contentView addSubview:_keyLabel];
        [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(LEFTSPACE);
            make.width.mas_equalTo(SCALEZOOM(90));
             make.bottom.mas_equalTo(-8);
        }];
    }
    return _keyLabel;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = FONTCOLOR;
        _valueLabel.font = [UIFont systemFontOfMutableSize:12];
        _valueLabel.numberOfLines = 0;
        _valueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_valueLabel];
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(self.keyLabel.mas_right).offset(5);
            make.right.mas_equalTo(-LEFTSPACE);
            make.bottom.mas_equalTo(-8);
        }];
    }
    return _valueLabel;
}

@end
