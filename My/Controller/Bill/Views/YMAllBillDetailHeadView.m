//
//  YMAllBillDetailHeadView.m
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillDetailHeadView.h"
#import "YMAllBillDetailDataModel.h"

@implementation YMAllBillDetailHeadView

+ (YMAllBillDetailHeadView *)instanceView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"YMAllBillDetailHeadView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)sendBillDetailType:(BillDetailType)billDetailType model:(YMAllBillDetailDataModel *)model
{
    switch (billDetailType) {
        case BillDetailConsumeScan://(消费---扫一扫超级收款码/扫一扫pc端生成的二维码/TX)
        {
            self.nameLabel.text = [model getPrdNameStr];
            self.txAmtLabel.text = [model getTxAmtStr];
            self.statusLabel.text = [model getXiaoFeiOrderStatusStr];
        }
            break;
        case BillDetailConsumeMobilePhoneRecharge://消费---手机话费充值
        {
            self.nameLabel.text = [model getProdispTypeStr];
            self.txAmtLabel.text = [model getTxAmtStr];
            self.statusLabel.text = [model getXiaoFeiOrderStatusStr];
        }
            break;
        case BillDetailAccountTransfer://转账(我要收款/ 扫一扫有名收款码)
        {
            self.nameLabel.text = [model getToAccNameStr];
            self.txAmtLabel.text = [model getTxAmtStr];
            self.statusLabel.text = [model getZhuanZhangOrdStatusStr];
        }
            break;
        case BillDetailAccountRecharge://账户充值
        {
            self.nameLabel.text = @"充值金额";
            self.txAmtLabel.text = [model getTxAmtStr];
            self.statusLabel.text = [model getXiaoFeiOrderStatusStr];
        }
            break;
        case BillDetailAccountWithDrawal://账户充值
        {
            self.nameLabel.text = @"提现金额";
            self.txAmtLabel.text = [model getTxAmtStr];
            self.statusLabel.text = [model getAccountOrdStatusCodeStr];
        }
            break;

        default:
            break;
    }
}
@end
