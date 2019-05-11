//
//  YMTransferCheckPayPwdModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferCheckPayPwdModel.h"
#import "YMTransferCheckPayPwdDataModel.h"

@implementation YMTransferCheckPayPwdModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMTransferCheckPayPwdDataModel"};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (NSString *)getResMsgStr
{
    NSString *str = @"";
    if (_resMsg != nil) {
        if (![_resMsg isEmptyStr]) {
            str = _resMsg;
        }
    }
    return str;
}

- (NSString *)getResCodeStr
{
    NSString *str = @"";
    if (_resCode != nil) {
        if (![_resCode isEmptyStr]) {
            str = _resCode;
        }
    }
    return str;
}

- (NSInteger)getResCodeNum
{
    NSInteger num;
    num = [[self getResCodeStr] integerValue];
    return num;
}
- (YMTransferCheckPayPwdDataModel *)getDtatModel
{
    YMTransferCheckPayPwdDataModel *model = [[YMTransferCheckPayPwdDataModel alloc] init];
    if (_data) {
        model = _data;
    }
    
    return model;
}
@end
