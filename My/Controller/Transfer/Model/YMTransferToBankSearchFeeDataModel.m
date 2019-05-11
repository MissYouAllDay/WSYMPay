//
//  YMTransferToBankSearchFeeDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/9.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankSearchFeeDataModel.h"
#import "NSString+AES.h"

@implementation YMTransferToBankSearchFeeDataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
/**
 转账手续费 参数传递
 */
- (NSString *)getReqFeeStr
{
    NSString *str = @"";
    if (_reqFee != nil) {
        if (![_reqFee isEmptyStr]) {
            str = [_reqFee decryptAES];
        }
    }
    return str;
}
/**
 转账手续费（免服务费/转账手续费:）
 */
- (NSString *)getUserTransFeeStr
{
    NSString *str = @"转账手续费:";
    NSString *reqFee = [self getReqFeeStr];
    if (reqFee != nil) {
        if (![reqFee isEmptyStr]) {
            str = [NSString stringWithFormat:@"转账手续费:%@元",reqFee];
        }
    }
    return str;
}
/**
 持卡人姓名
 */
- (NSString *)getCardNameStr
{
    NSString *str = @"";
    if (_cardName != nil) {
        if (![_cardName isEmptyStr]) {
            str = _cardName;
        }
    }
    return str;
}
/**
 交易金额
 */
- (NSString *)getTxAmtStr
{
    NSString *str = @"";
    if (_txAmt != nil) {
        if (![_txAmt isEmptyStr]) {
            str = _txAmt;
        }
    }
    return str;
}
/**
 银行卡号
 */
- (NSString *)getBankAcNoStr
{
    NSString *str = @"";
    if (_bankAcNo != nil) {
        if (![_bankAcNo isEmptyStr]) {
            str = _bankAcNo;
        }
    }
    return str;
}

/**
 银行卡号后四位
 */
- (NSString *)getBankAcNoLastFourStr
{
    NSString *str = @"";
    NSString *bankAcNoStr = [self getBankAcNoStr];
    if (bankAcNoStr.length>4) {
        str = [bankAcNoStr substringFromIndex:bankAcNoStr.length - 4];
    }
    return str;
}
/**
 收款账号
 */
- (NSString *)getShouKuanMsgStr
{
    NSString *str = [NSString stringWithFormat:@"%@(%@)",[self getBankNameStr],[self getBankAcNoLastFourStr]];
    return str;
}

/**
 收款账号信息/银行卡信息（如：招商银行(8443)）
 */
- (NSString *)getBankAcMsgStr
{
    NSString *str = @"";
    if (_bankAcMsg != nil) {
        if (![_bankAcMsg isEmptyStr]) {
            str = _bankAcMsg;
        }
    }
    return str;
}
@end
