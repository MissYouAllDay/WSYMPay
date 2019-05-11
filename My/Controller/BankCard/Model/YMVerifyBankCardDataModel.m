//
//  YMVerifyBankCardDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/7/31.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMVerifyBankCardDataModel.h"

@implementation YMVerifyBankCardDataModel

#pragma mark - 数据库相关
//重载选择 使用的LKDBHelper
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[LKDBHelper alloc]init];
    });
    return db;
}
////主键（可不写，默认一个rowid为主键）
//+(NSString *)getPrimaryKey
//{
//    return @"index";
//}
//表名
+(NSString *)getTableName
{
    return @"YMVerifyBankCardDataModelDBTable";
}

/**
 删除所有表
 */
+ (void)deletAllDBTable
{
    [[YMVerifyBankCardDataModel getUsingLKDBHelper] dropAllTable];
}
#pragma mark - 取值

- (NSString *)getSafetyCodeStr
{
    NSString *str = @"";
    if (_safetyCode != nil) {
        if (![_safetyCode isEmptyStr]) {
            str = _safetyCode;
        }
    }
    return str;
}
@end
