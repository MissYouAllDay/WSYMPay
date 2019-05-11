//
//  YMReChargeDetailsModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMReChargeDetailsModel.h"
#import "NSString+AES.h"

@implementation YMReChargeDetailsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
/**
 * header title
 */
- (NSString *)getHeadTitleStr
{
    NSString *str = @"";
    str = [NSString stringWithFormat:@"%@金额",[self getPrdNameStr]];
    return str;
}

- (NSString *)getPrdNameStr
{
    NSString *str = @"";
    if (![_prdName isEmptyStr]) {
        str = _prdName;
    }
    return str;
}
- (NSString *)getOrderDateStr
{
    NSString *str = @"";
    if (![_orderDate isEmptyStr]) {
        str = _orderDate;
    }
    return str;
}
- (NSString *)getOrdStatusStr
{
    NSString *str = @"";
    if (![_ordStatus isEmptyStr]) {
        str = _ordStatus;
    }
    return str;
}
- (NSString *)getPayordnoStr
{
    NSString *str = @"";
    if (![_payordno isEmptyStr]) {
//        str = [_payordno decryptAES];
        str = _payordno;
    }
    return str;
}

/**
 * 金额
 */
- (NSString *)getTxAmtStr
{
    NSString *str = @"";
    if (![_txAmt isEmptyStr]) {
        str = [_txAmt decryptAES];
        if (_inOrOut == 1) {//支出 -
            if ([str hasPrefix:@"-"]) {
                str = str;
            }else{
                str = [NSString stringWithFormat:@"-%@",str];
            }
        }else if(_inOrOut == 2){//收入 +
            if ([str hasPrefix:@"+"]) {
                str = str;
            }else{
                str = [NSString stringWithFormat:@"+%@",str];
            }
        }
    }
    return str;
}

- (NSString *)getPaytypeStr
{
    NSString *str = @"";
    if (![_paytype isEmptyStr]) {
        str = _paytype;
    }
    return str;
}

- (NSString *)getBankAcNoStr
{
    NSString *str = @"";
    if (![_bankAcNo isEmptyStr]) {
        str = [_bankAcNo decryptAES];
    }
    return str;
}
- (NSString *)getBankNameStr
{
    NSString *str = @"";
    if (![_bankName isEmptyStr]) {
            str = _bankName;
    }
    return str;
}

/**
 * 交易方式对应的value值
 */
- (NSString *)getPayTypeValueStr
{
    NSString *str = @"";
    if ((![[self getBankNameStr] isEmptyStr])&&(![[self getBankAcNoStr]isEmptyStr])) {
        NSString *bankNameStr = [self getBankNameStr];
        if (bankNameStr == nil) {
            bankNameStr = @"";
        }
        str = [NSString stringWithFormat:@"%@(%@)",bankNameStr,[self getBankAcNoStr]];
    }else{
        str = [self getPaytypeStr];
    }
    return str;
}

@end
