//
//  YMCashDetailsModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCashDetailsModel.h"
#import "NSString+AES.h"

@implementation YMCashDetailsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
/**
 * header title
 */
- (NSString *)getHeadTitleStr
{
    NSString *str = @"";
    if (_inOrOut == 1) {//支出
        str = @"提现金额";
    }else if (_inOrOut == 2){//收入
        str = @"退款金额";
    }
    return str;
}
/**
 * 交易名称
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
 * 申请时间、交易时间
 * 提现失败状态：只有交易时间，现在取申请时间。
 */
- (NSString *)getActdatStr
{
    NSString *str = @"";
    if (![_actdat isEmptyStr]) {
        str = _actdat;
    }
    return str;
}
/**
 * 到账时间
 */
- (NSString *)getSucdatStr
{
    NSString *str = @"";
    if (![_sucdat isEmptyStr]) {
        str = _sucdat;
    }
    return str;
}
/**
 * 交易状态
 */
- (NSString *)getOrdStatusStr
{
    NSString *str = @"";
    if (![_ordStatus isEmptyStr]) {
        str = _ordStatus;
    }
    return str;
}
/**
 * 交易单号
 */
- (NSString *)getCasordNoStr
{
    NSString *str = @"";
    if (![_casordNo isEmptyStr]) {
        str = _casordNo;
    }
    return str;
}
/**
 * 金额
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
 * 银行卡后4位
 */
- (NSString *)getBankAcNoStr
{
    NSString *str = @"";
    if (![_bankAcNo isEmptyStr]) {
        str = [_bankAcNo decryptAES];
    }
    return str;
}
/**
 * 银行卡名
 */
- (NSString *)getBankNameStr
{
    NSString *str = @"";
    if (![_bankName isEmptyStr]) {
        str = _bankName;
    }
    return str;
}

/**
 * 转出至：
 * 银行卡名(银行卡后4位)
 */
- (NSString *)getBankMsgStr
{
    NSString *str = @"";
    str = [NSString stringWithFormat:@"%@(%@)",[self getBankNameStr],[self getBankAcNoStr]];
    return str;
}



/** key **/
/**
 key：
 提现失败---交易时间
 否则   ---申请时间
 */
- (NSString *)getActdatKeyStr
{
    NSString *str = @"";
    NSString *ordetStatusStr = [self getOrdStatusStr];
    if ([ordetStatusStr containsString:@"提现失败"]) {
        str = @"交易时间";
    }else{
        str = @"申请时间";
    }
    return str;
}

/**
 * key：
 * 提现失败---不显示到账时间
 * 否则   ---显示到账时间这一行
 */
- (BOOL)isShowSucdatKey
{
    BOOL isShow = NO;
    NSString *ordetStatusStr = [self getOrdStatusStr];
    if ([ordetStatusStr containsString:@"提现失败"]) {
        isShow = NO;
    }else{
        isShow = YES;
    }
    return isShow;
}

/**
 * key：
 * 提现失败---不显示银行卡信息这一行
 * 否则   ---显示银行卡信息这一行
 */
- (BOOL)isShowBankMsgKey
{
    BOOL isShow = NO;
    NSString *ordetStatusStr = [self getOrdStatusStr];
    if ([ordetStatusStr containsString:@"提现失败"]) {
        isShow = NO;
    }else{
        isShow = YES;
    }
    return isShow;
}

@end
