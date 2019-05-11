//
//  YMTransferCheckPayPwdDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferCheckPayPwdDataModel.h"
#import "NSString+AES.h"

@implementation YMTransferCheckPayPwdDataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
/**
 交易失败原因
 */
- (NSString *)getBackErrorStr
{
    NSString *str = @"";
    if (_backError != nil) {
        if (![_backError isEmptyStr]) {
            str = _backError;
        }
    }
    return str;
}

/**
 上个接口传过来的 转账订单号
 */
- (NSString *)getTraordNoStr
{
    NSString *str = @"";
    if (_traordNo != nil) {
        if (![_traordNo isEmptyStr]) {
            str = _traordNo;
        }
    }
    return str;
}

/**
 * 转账到银行卡处理中返回的 金额（因后台返回时加密的需要界面）
 */
- (NSString *)getTransferChuLiTxAmtStr
{
    NSString *str = @"";
    str = [NSString stringWithFormat:@"¥ %@",[self getTxAmtStr]];
    return str;
}
@end
