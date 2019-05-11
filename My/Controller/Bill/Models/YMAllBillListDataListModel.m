//
//  YMAllBillListDataListModel.m
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillListDataListModel.h"
#import "NSString+AES.h"

@implementation YMAllBillListDataListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}


/**
 订单日期
 */
- (NSString *)getOrdDateStr
{
    NSString *str = @"";
    if (_ordDate != nil) {
        if (![_ordDate isEmptyStr]) {
            str = _ordDate;
        }
    }
    return str;
}
/**
 订单时间
 */
- (NSString *)getOrdTimeStr
{
    NSString *str = @"";
    if (_ordTime != nil) {
        if (![_ordTime isEmptyStr]) {
            str = _ordTime;
        }
    }
    return str;
}
/**
 订单金额 (加密)
 */
- (NSString *)getOrdTxAmtStr
{
    NSString *str = @"";
    if (_txAmt != nil) {
        if (![_txAmt isEmptyStr]) {
            str = [_txAmt decryptAES];
        }
    }
    return str;
}
/**
 订单内容
 */
- (NSString *)getOrderMsgStr
{
    NSString *str = @"";
    if (_orderMsg != nil) {
        if (![_orderMsg isEmptyStr]) {
            str = _orderMsg;
        }
    }
    return str;
}
/**
 订单状态(消费（tranType为1、2）（00:未支付 01:支付成功  02:支付失败 90处理中99:超时）充值（01:充值成功  02:充值失败90处理中）提现（01:提现处理中  02:提现成功  03:提现失败）转账（01:转账成功  02:转账失败 03转账处理中）)
 */
- (NSString *)getOrdStatusStr
{
    NSString *str = @"";
    NSString *tranTypeStr = [self getTranTypeStr];
    NSString *orderStatusStr = [self getOrderStatusString];
    if ([tranTypeStr isEqualToString:@"1"]||[tranTypeStr isEqualToString:@"2"]) {//消费
        if ([orderStatusStr isEqualToString:@"00"]) {
            str = @"未支付";
        }else if ([orderStatusStr isEqualToString:@"02"]){
            str = @"支付失败";
        }else if ([orderStatusStr isEqualToString:@"90"]){
            str = @"处理中";
        }else if ([orderStatusStr isEqualToString:@"99"]){
            str = @"超时";
        }else{//01 支付成功不显示
            str = @"";
        }
    }else if ([tranTypeStr isEqualToString:@"3"]){//充值
        if ([orderStatusStr isEqualToString:@"02"]) {
            str = @"充值失败";
        }else if ([orderStatusStr isEqualToString:@"90"]){
            str = @"处理中";
        }
    }else if ([tranTypeStr isEqualToString:@"5"]){//提现
        if ([orderStatusStr isEqualToString:@"01"]) {
            str = @"提现处理中";
        }else if ([orderStatusStr isEqualToString:@"03"]){
            str = @"提现失败";
        }
    }else if ([tranTypeStr isEqualToString:@"4"]){//转账
        if ([orderStatusStr isEqualToString:@"02"]) {
            str = @"转账失败";
        }else if ([orderStatusStr isEqualToString:@"03"]){
            str = @"转账处理中";
        }
    }
    return str;
}

/**
 订单号 (加密)
 */
- (NSString *)getOrderNoStr
{
    NSString *str = @"";
    if (_orderNo != nil) {
        if (![_orderNo isEmptyStr]) {
            str = [_orderNo decryptAES];
        }
    }
    return str;
}

/**
 交易类型(对应详情分类)（1消费2手机充值3充值4转账5提现）
 */
- (NSString *)getTranTypeStr
{
    NSString *str = @"";
    if (_tranType != nil) {
        if (![_tranType isEmptyStr]) {
            str = _tranType;
        }
    }
    return str;
}

- (NSString *)getOrderStatusString
{
    NSString *str = @"";
    if (_ordStatus != nil) {
        if (![_ordStatus isEmptyStr]) {
            str = _ordStatus;
        }
    }
    return str;
}

- (NSString *)getDateString
{
    NSString *str = @"";
    NSString *ordDateStr = [self getOrdDateStr];
    NSArray *dateArr = [ordDateStr componentsSeparatedByString:@"-"];
    if (dateArr.count>=1) {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@",dateArr[0],dateArr[1]];
        str = dateStr;
    }
    return str;
}
@end
