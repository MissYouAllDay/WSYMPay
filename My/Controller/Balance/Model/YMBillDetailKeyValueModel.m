//
//  YMBillDetailKeyValueModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBillDetailKeyValueModel.h"

@implementation YMBillDetailKeyValueModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (NSString *)getKeyString
{
    NSString *str = @"";
    if (![_keyStr isEmptyStr]) {
        str = _keyStr;
    }
    return str;
}
- (NSString *)getValueString
{
    NSString *str = @"";
    if (![_valueStr isEmptyStr]) {
        str = _valueStr;
    }
    return str;
}

@end
