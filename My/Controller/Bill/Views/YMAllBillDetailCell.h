//
//  YMAllBillDetailCell.h
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 账单详情界面
 //BillDetailConsumeMobilePhoneRecharge         = 0,//消费---手机话费充值
 //BillDetailConsumeScan                        = 1,//消费---扫一扫超级收款码
 //BillDetailPCScan                             = 1,//扫一扫pc端生成的二维码
 //BillDetailTX                                 = 1,//TX
 //BillDetailAccountTransfer                    = 2,//转账(我要收款/ 扫一扫有名收款码)
 BillDetailAccountRecharge                    = 3,账户充值
 BillDetailAccountWithDrawal                  = 4,账户提现
 */
#import <UIKit/UIKit.h>
#import "YMAllBillDetailVC.h"
@class YMAllBillDetailDataModel;

@interface YMAllBillDetailCell : UITableViewCell

/** 订单类型 */
@property (nonatomic, copy) NSString *tranType;


- (void)sendBillDetailType:(BillDetailType)billDetailType section:(NSInteger)section row:(NSInteger)row model:(YMAllBillDetailDataModel *)model;

@end
