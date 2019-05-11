//
//  YMBillDetailsModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMBillDetailsModel.h"
#import "NSString+AES.h"

@implementation YMBillDetailsModel

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
    return @"YMBillListModelDBTable";
}

/**
 删除所有表
 */
+ (void)deletAllDBTable
{
    [[YMBillDetailsModel getUsingLKDBHelper] dropAllTable];
}

#pragma mark - 取值
/**
 交易类型名称
 */
- (NSString *)getPrdNameStr
{
    NSString *str = @"";
    if (![_prdName isEmptyStr]) {
        str = _prdName;
    }
    return str;
}
/**
 交易状态名称
 */
- (NSString *)getOrdStatusNameStr
{
    NSString *str = @"";
    if (![_ordStatusName isEmptyStr]) {
        str = _ordStatusName;
    }
    return str;
}
/**
 交易时间
 */
- (NSString *)getOrderDateStr{
    NSString *str = @"";
    if (![_orderDate isEmptyStr]) {
        NSString *dateStr = [[NSString alloc] initWithString:_orderDate];
        NSMutableString *string = [NSMutableString stringWithString:dateStr];
        str = [string substringFromIndex:5];
    }
    return str;
}

/**
 * 交易金额,解密
 */
- (NSString *)getTxAmtStr
{
    NSString *str = @"";
    if (![_txAmt isEmptyStr]) {
        str = [_txAmt decryptAES];
        if (_inOrOut == 1) {//支出 -
            if ([str hasPrefix:@"-"]) {
                str = str;
            }else{
                str = [NSString stringWithFormat:@"-%@",str];
            }
        }else if(_inOrOut == 2){//收入 +
            if ([str hasPrefix:@"+"]) {
                str = str;
            }else{
                str = [NSString stringWithFormat:@"+%@",str];
            }
        }
    }
    return str;
}
/**
 交易单号
 */
- (NSString *)getPrdOrdNoStr
{
    NSString *str = @"";
    if (![_prdOrdNo isEmptyStr]) {
        str = _prdOrdNo;
    }
    return str;
}

/**
 提现详情查询传参 orderType（交易类型）---- 提现3退款4
 
 add by 2017-4-12
 tranType=3&&_inOrOut=2 ---- 退款 orderType = 4；
 tranType=3&&_inOrOut=1 ---- 提现 orderType = 3；
 @return orderType
 */
- (NSInteger )getOrderTypeNum
{
    NSInteger orderTypeNum;
    if (_tranType==3 && _inOrOut==2) {//退款
        orderTypeNum = 4;
    }else{//提现
        orderTypeNum = 3;
    }
    return orderTypeNum;
}
@end
