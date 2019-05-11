//
//  YMTransferToBankLimitModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/11.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankLimitModel.h"
#import "YMTransferToBankLimitDataModel.h"

@implementation YMTransferToBankLimitModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMTransferToBankLimitDataModel"};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
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
- (YMTransferToBankLimitDataModel *)getDataModel
{
    YMTransferToBankLimitDataModel *model = [[YMTransferToBankLimitDataModel alloc] init];
    if (_data) {
        model = _data;
    }else{
        model = nil;
    }
    return model;
}
@end
