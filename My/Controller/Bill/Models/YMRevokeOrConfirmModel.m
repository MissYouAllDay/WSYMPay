//
//  YMRevokeOrConfirmModel.m
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMRevokeOrConfirmModel.h"
#import "YMRevokeOrConfirmDataModel.h"

@implementation YMRevokeOrConfirmModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMRevokeOrConfirmDataModel"};
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
- (YMRevokeOrConfirmDataModel *)getDataModel;
{
    YMRevokeOrConfirmDataModel *model = [[YMRevokeOrConfirmDataModel alloc] init];
    if (_data) {
        model = _data;
    }else{
        model = nil;
    }
    return model;
}

@end
