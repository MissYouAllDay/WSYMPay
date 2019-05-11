//
//  YMTransferToBankLimitDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/11.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankLimitDataModel.h"

@implementation YMTransferToBankLimitDataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
/**
 当前账户余额
 
 @return string
 */
- (NSString *)getCashAcBalStr
{
    NSString *str = @"";
    if (_cashAcBal != nil) {
        if (![_cashAcBal isEmptyStr]) {
            str = _cashAcBal;
        }
    }
    return str;
}

/**
 单笔可转账
 
 @return string
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

/**
 日最大交易限额
 
 @return string
 */
- (NSString *)getLimitDayAmtStr
{
    NSString *str = @"";
    if (_limitDayAmt != nil) {
        if (![_limitDayAmt isEmptyStr]) {
            str = _limitDayAmt;
        }
    }
    return str;
}

/**
 限额说明

 @return str
 */
- (NSString *)getLimitDescStr
{
    NSString *str = [NSString stringWithFormat:@"当前用户账户余额%@元，单笔可转账金额%@元，且最大交易限额%@元",[self getCashAcBalStr],[self getLmitMaxAmtStr],[self getLimitDayAmtStr]];
    return str;
}
@end
