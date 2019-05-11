//
//  YMPrepaidCardBaseModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBankCardBaseModel.h"
#import "YMBankCardDataModel.h"

@implementation YMBankCardBaseModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMBankCardDataModel"};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
- (YMBankCardDataModel *)getBankCardDataModel
{
    if (_data) {
        return _data;
    }
    return nil;
}
- (NSInteger )getResCodeNum
{
    NSInteger resCode;
    resCode = _resCode;
    return resCode;
}
- (NSString *)getResMsgStr
{
    NSString *str = @"";
    if (![_resMsg isEmptyStr]) {
        str = _resMsg;
    }
    return str;
}

@end
