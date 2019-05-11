//
//  YMPrepaidCardDetailsModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPrepaidCardDetailsModel.h"
#import "NSString+AES.h"

@implementation YMPrepaidCardDetailsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
/**
 * header title
 */
- (NSString *)getHeadTitleStr
{
    NSString *str = @"";
    str = [NSString stringWithFormat:@"%@金额",[self getPrdNameStr]];
    return str;
}
/**
 * 交易类型名称
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
 * 申请时间
 * 退款 --- 交易时间
 * 否则 --- 申请时间
 */
- (NSString *)getOrderDateStr
{
    NSString *str = @"";
    if (![_orderDate isEmptyStr]) {
        str = _orderDate;
    }
    return str;
}
/**
 * 受理时间
 * 退款 --- 不显示
 * 否则 --- 显示
 */
- (NSString *)getEndTimeStr
{
    NSString *str = @"";
    if (![_endTime isEmptyStr]) {
        str = _endTime;
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
- (NSString *)getPrdOrdNoStr
{
    NSString *str = @"";
    if (![_prdOrdNo isEmptyStr]) {
        str = _prdOrdNo;
    }
    return str;
}
/**
 * 预付卡卡号
 * 格式：卡类型（预付卡号前6位与后4位展示，中间部分用 * 代替）
 */
- (NSString *)getPrepaidNoStr
{
    NSString *str = @"";
    if (![_prepaidNo isEmptyStr]) {
        str = _prepaidNo;
        NSString *prepaidNoStr = [str decryptAES];
        NSInteger len = [prepaidNoStr length];
        if (len > 11) {
            NSRange headerRange = NSMakeRange(0, 6);
            NSString *headerStr = [prepaidNoStr substringWithRange:headerRange];
            NSRange footerRange = NSMakeRange(len-4, 4);
            NSString *footerStr = [prepaidNoStr substringWithRange:footerRange];
            prepaidNoStr = [NSString stringWithFormat:@"%@****%@",headerStr,footerStr];
            str = prepaidNoStr;
        }
    }
    return str;
}
/**
 * 卡类型
 */
- (NSString *)getCardFlagStr
{
    NSString *str = @"";
    if (![_cardflag isEmptyStr]) {
        str = _cardflag;
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
 * 预付卡卡号
 * 格式：卡类型（预付卡号前6位与后4位展示，中间部分用 * 代替）
 */
- (NSString *)getPrepaidCardMsgStr
{
    NSString *str = @"";
    str = [NSString stringWithFormat:@"%@(%@)",[self getCardFlagStr],[self getPrepaidNoStr]];
    return str;
}

#pragma mark - key
/** key **/
/**
 * key：
 * 退款 ---交易时间
 * 否则 ---申请时间
 */
- (NSString *)getOrderDateKeyStr
{
    NSString *str = @"";
    NSString *ordetStatusStr = [self getOrdStatusStr];
    if ([ordetStatusStr containsString:@"退款"]) {
        str = @"交易时间";
    }else{
        str = @"申请时间";
    }
    return str;

}

/**
 * key：
 * 退款 ---不显示到账时间
 * 否则 ---显示到账时间这一行
 */
- (BOOL)isShowEndTimeKey
{
    BOOL isShow = NO;
    NSString *ordetStatusStr = [self getOrdStatusStr];
    if ([ordetStatusStr containsString:@"退款"]) {
        isShow = NO;
    }else{
        isShow = YES;
    }
    return isShow;
}

/**
 * key：
 * 退款 ---不显示预付卡信息这一行
 * 否则 ---显示预付卡信息这一行
 */
- (BOOL)isShowPrepaidCard
{
    BOOL isShow = NO;
    NSString *ordetStatusStr = [self getOrdStatusStr];
    if ([ordetStatusStr containsString:@"退款"]) {
        isShow = NO;
    }else{
        isShow = YES;
    }
    return isShow;
}
@end
