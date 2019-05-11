//
//  YMTransferToBankSearchReqFeeModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/9.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankSearchReqFeeModel.h"
#import "YMTransferToBankSearchFeeDataModel.h"

@implementation YMTransferToBankSearchReqFeeModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMTransferToBankSearchFeeDataModel"};
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
- (YMTransferToBankSearchFeeDataModel *)getDtatModel
{
    YMTransferToBankSearchFeeDataModel *model = [[YMTransferToBankSearchFeeDataModel alloc] init];
    if (_data) {
        model = _data;
    }else{
        model = nil;
    }
    return model;
}

@end
