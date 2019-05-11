//
//  YMTransferCreatOrderDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferCreatOrderDataModel.h"

@implementation YMTransferCreatOrderDataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (NSString *) getPrdOrdNoStr
{
    NSString *str = @"";
    if (_prdOrdNo != nil) {
        if (![_prdOrdNo isEmptyStr]) {
            str = _prdOrdNo;
        }
    }
    return str;
}
/**
 转账订单
 */
- (NSString *) getTraordNoStr
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
 随机码
 */
- (NSString *) getRandomCodeStr
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
