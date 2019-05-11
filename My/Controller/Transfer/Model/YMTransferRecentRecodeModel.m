//
//  YMTransferRecentRecodeModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferRecentRecodeModel.h"
#import "YMTransferRecentRecodeDataModel.h"

@implementation YMTransferRecentRecodeModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMTransferRecentRecodeDataModel"};
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
- (YMTransferRecentRecodeDataModel *)getDataModel
{
    YMTransferRecentRecodeDataModel *model = [[YMTransferRecentRecodeDataModel alloc] init];
    if (_data) {
        model = _data;
    }else{
        model = nil;
    }
    return model;
}


@end
