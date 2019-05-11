//
//  YMCollectionBaseListModel.m
//  WSYMPay
//
//  Created by pzj on 2017/8/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCollectionBaseListModel.h"
#import "NSString+AES.h"

@implementation YMCollectionBaseListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (NSString *)getOrderMsgStr
{
    NSString *str = @"";
    if (_orderMsg != nil) {
        if (![_orderMsg isEmptyStr]) {
            str = _orderMsg;
        }
    }
    return str;
}
- (NSString *)getOrderNoStr
{
    NSString *str = @"";
    if (_orderNo != nil) {
        if (![_orderNo isEmptyStr]) {
            str = [_orderNo decryptAES];
        }
    }
    return str;
}
- (NSString *)getTranTypeStr
{
    NSString *str = @"";
    if (_tranType != nil) {
        if (![_tranType isEmptyStr]) {
            str = _tranType;
        }
    }
    return str;
}
- (NSString *)getOrdDateStr
{
    NSString *str = @"";
    if (_ordDate != nil) {
        if (![_ordDate isEmptyStr]) {
            str = _ordDate;
        }
    }
    return str;
}
- (NSString *)getOrdStatusStr
{
    NSString *str = @"";
    if (_ordStatus != nil) {
        if (![_ordStatus isEmptyStr]) {
            str = _ordStatus;
        }
    }
    return str;
}
- (NSString *)getOrdTimeStr
{
    NSString *str = @"";
    if (_ordTime != nil) {
        if (![_ordTime isEmptyStr]) {
            str = _ordTime;
        }
    }
    return str;
}
- (NSString *)getTxAmStr
{
    NSString *str = @"";
    if (_txAmt != nil) {
        if (![_txAmt isEmptyStr]) {
            str = _txAmt;
        }
    }
    return str;
}
@end
