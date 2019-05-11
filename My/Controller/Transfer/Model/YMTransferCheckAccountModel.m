//
//  YMTransferCheckAccountModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferCheckAccountModel.h"
#import "YMTransferCheckAccountDataModel.h"

@implementation YMTransferCheckAccountModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMTransferCheckAccountDataModel"};
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
- (YMTransferCheckAccountDataModel *)getDtatModel
{
    YMTransferCheckAccountDataModel *model = [[YMTransferCheckAccountDataModel alloc] init];
    if (_data) {
        model = _data;
    }else{
        model = nil;
    }
    return model;
}
@end
