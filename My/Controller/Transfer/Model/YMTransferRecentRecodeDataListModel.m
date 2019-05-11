//
//  YMTransferRecentRecodeDataListModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferRecentRecodeDataListModel.h"

@implementation YMTransferRecentRecodeDataListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
/**
 接收方用户名
 */
- (NSString *)getToAccNameStr
{
    NSString *str = @"";
    if (_toAccName != nil) {
        if (![_toAccName isEmptyStr]) {
            str = _toAccName;
        }
    }
    return str;
}

/**
 接收方手机号/银行卡号（遮蔽）
 */
- (NSString *)getToAccountStr
{
    NSString *str = @"";
    if (_toAccount != nil) {
        if (![_toAccount isEmptyStr]) {
            str = _toAccount;
        }
    }
    return str;
}
/**
 接收方手机号/银行卡号 （未遮蔽）
 */
- (NSString *)getToAccountsStr
{
    NSString *str = @"";
    if (_toAccounts != nil) {
        if (![_toAccounts isEmptyStr]) {
            str = _toAccounts;
        }
    }
    return str;
}

/**
 银行卡名称
 */
- (NSString *)getBankNameStr
{
    NSString *str = @"";
    if (_bankName != nil) {
        if (![_bankName isEmptyStr]) {
            str = _bankName;
        }
    }
    return str;
}

/**
 转账说明(01余额转余额 06余额转银行卡)
 */
- (NSString *)getTratypeStr
{
    NSString *str = @"";
    if (_tratype != nil) {
        if (![_tratype isEmptyStr]) {
            str = _tratype;
        }
    }
    return str;
}

/**
 限额说明 limit
 */
- (NSString *)getLmitMaxAmtStr
{
    NSString *str = @"";
    if (_lmitMaxAmt != nil) {
        if (![_lmitMaxAmt isEmptyStr]) {
            str = _lmitMaxAmt;
        }
    }
    return str;
}

@end
