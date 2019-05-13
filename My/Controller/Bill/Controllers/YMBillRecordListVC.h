//
//  YMBillRecordListVC.h
//  WSYMPay
//
//  Created by junchiNB on 2019/4/23.
//  Copyright © 2019年 赢联. All rights reserved.
//
/*
 * app4期新修改整合 creat by pzj
 * 1、总账单中，点击4个分类，进入的账单列表界面
 * 消费、账户充值、账户提现、转账公用这一个界面
 * 2、手机充值---手机充值记录账单复用这个界面
 * 3、我要收款---收款账单复用这个界面
 ***************************************
 * *****注意*******：
 * 只有第1条中右上角有筛选按钮
 *
 */

typedef NS_ENUM(NSInteger, BillType) {
    BillConsume                 = 0,//消费
    BillAccountRecharge         = 1,//账户充值
    BillAccountWithDrawal       = 2,//账户提现
    BillAccountTransfer         = 3,//转账
    BillCollect                 = 4,//收款账单（我要收款界面进入的）
    BillMobilePhoneRecharge     = 5,//手机充值记录账单（手机充值界面进入的）
    BillTransaction             = 7,//交易记录
};
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMBillRecordListVC : UIViewController
@property (assign,nonatomic,readwrite) BillType billType;

@end

NS_ASSUME_NONNULL_END
