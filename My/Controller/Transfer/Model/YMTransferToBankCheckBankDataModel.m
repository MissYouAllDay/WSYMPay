//
//  YMTransferToBankCheckBankDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/9.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankCheckBankDataModel.h"

@implementation YMTransferToBankCheckBankDataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
/**
 银行卡类型
 */
- (NSString *)getBankCardTypeStr
{
    NSString *str = @"";
    if (_bankCardType != nil) {
        if (![_bankCardType isEmptyStr]) {
            str = _bankCardType;
        }
    }
    return str;
}
/**
 银行名称
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
 银行号
 */
- (NSString *)getBankNoStr{
    NSString *str = @"";
    if (_bankNo != nil) {
        if (![_bankNo isEmptyStr]) {
            str = _bankNo;
        }
    }
    return str;
}

/**
 银行卡类型
 */
- (NSString *)getCardTypeStr
{
    NSString *str = @"";
    if (_cardType != nil) {
        if (![_cardType isEmptyStr]) {
            str = _cardType;
        }
    }
    return str;
}
/**
 随机串
 */
- (NSString *)getRandomCodeStr
{
    NSString *str = @"";
    if (_randomCode != nil) {
        if (![_randomCode isEmptyStr]) {
            str = _randomCode;
        }
    }
    return str;
}
@end
