//
//  YMTransferToBankCheckBankModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/9.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankCheckBankModel.h"
#import "YMTransferToBankCheckBankDataModel.h"

@implementation YMTransferToBankCheckBankModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMTransferToBankCheckBankDataModel"};
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
- (YMTransferToBankCheckBankDataModel *)getDtatModel
{
    YMTransferToBankCheckBankDataModel *model = [[YMTransferToBankCheckBankDataModel alloc] init];
    if (_data) {
        model = _data;
    }else{
        model = nil;
    }
    return model;
}

@end
