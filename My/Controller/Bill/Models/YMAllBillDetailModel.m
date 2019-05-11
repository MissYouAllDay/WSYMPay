//
//  YMAllBillDetailModel.m
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillDetailModel.h"
#import "YMAllBillDetailDataModel.h"

@implementation YMAllBillDetailModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMAllBillDetailDataModel"};
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

- (YMAllBillDetailDataModel *)getDataModel;
{
    YMAllBillDetailDataModel *model = [[YMAllBillDetailDataModel alloc] init];
    if (_data) {
        model = _data;
    }else{
        model = nil;
    }
    return model;
}

@end
