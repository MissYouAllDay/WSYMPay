//
//  YMAllBillDetailDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillDetailDataModel.h"
#import "NSString+AES.h"

@implementation YMAllBillDetailDataModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
#pragma mark - header
/**
 商户名称
 */
- (NSString *)getMerNamStr
{
    NSString *str = @"";
    if (_merNam != nil) {
        if (![_merNam isEmptyStr]) {
            str = _merNam;
        }
    }
    return str;
}
/**
 订单金额（加密）
 */
- (NSString *)getTxAmtStr
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
 订单状态 文字提示 00:未支付 01:支付成功  02:支付失败 90处理中99:超时）
 */
- (NSString *)getOrderStatusStr
{
    NSString *str = @"";
    NSString *statusStr = [self getStatusCodeStr];
    if ([statusStr isEqualToString:@"00"]) {
        str = @"未支付";
    }else if ([statusStr isEqualToString:@"01"]){
        str = @"支付成功";
    }else if ([statusStr isEqualToString:@"02"]){
        str = @"支付失败";
    }else if ([statusStr isEqualToString:@"90"]){
        str = @"处理中";
    }else if ([statusStr isEqualToString:@"99"]){
        str = @"超时";
    }
    return str;
}


/*
 * 转账订单状态 01:转账成功  02:转账失败 03转账处理中 04转账待处理 05转账冻结 06转账撤销 07后台撤销）
 */
- (NSString *)getTransOrderStatusStr
{
    NSString *str = @"";
    NSString *statusStr = [self getStatusCodeStr];
    if ([statusStr isEqualToString:@"01"]){
        str = @"转账成功";
    }else if ([statusStr isEqualToString:@"02"]){
        str = @"转账失败";
    }else if ([statusStr isEqualToString:@"03"]){
        str = @"转账处理中";
    }else if ([statusStr isEqualToString:@"04"]){
        str = @"转账待处理";
    }else if ([statusStr isEqualToString:@"05"]){
        str = @"转账冻结";
    }else if ([statusStr isEqualToString:@"06"]){
        str = @"转账撤销";
    }else if ([statusStr isEqualToString:@"07"]){
        str = @"后台撤销";
    }
    return str;
}
/**
 订单状态 状态码 00:未支付 01:支付成功  02:支付失败 90处理中99:超时）
 */
- (NSString *)getStatusCodeStr;
{
    NSString *str = @"";
    if (_ordStatus != nil) {
        if (![_ordStatus isEmptyStr]) {
            str = _ordStatus;
        }
    }
    return str;
}

#pragma mark - 投诉
/**
 投诉状态 文字提示（0未投诉1未处理  2已处理 3已确认）
 */
- (NSString *)getAcceptStateStr
{
    NSString *str = @"";
    NSString *acceptStateCode = [self getAcceptStateCodeStr];
    if ([acceptStateCode isEqualToString:@"0"]) {
        str = @"未投诉";
    }else if ([acceptStateCode isEqualToString:@"1"]){
        str = @"未处理";
    }else if ([acceptStateCode isEqualToString:@"2"]){
        str = @"已处理";
    }else if ([acceptStateCode isEqualToString:@"3"]){
        str = @"已确认";
    }
    return str;
}
/**
 投诉状态 状态码（0未投诉1未处理  2已处理 3已确认）  //001:转账成功  02:转账失败 03转账处理中 04转账待处理 05转账冻结 06转账撤销 07后台撤销
 */
- (NSString *)getAcceptStateCodeStr
{
    NSString *str = @"";
    if (_acceptState != nil) {
        if (![_acceptState isEmptyStr]) {
            str = _acceptState;
        }
    }
    return str;
}
/**
 投诉原因
 */
- (NSString *)getComRemarkStr
{
    NSString *str = @"";
    if (_comRemark != nil) {
        if (![_comRemark isEmptyStr]) {
            str = _comRemark;
        }
    }
    return str;
}
/**
 投诉处理说明
 */
- (NSString *)getHandleRemarkStr
{
    NSString *str = @"";
    if (_handleRemark != nil) {
        if (![_handleRemark isEmptyStr]) {
            str = _handleRemark;
        }
    }
    return str;
}

#pragma mark -------------------
/**
 消费/手机充值/转账/消费---扫一扫超级收款码/扫一扫pc端生成的二维码/TX    付款方式
 */
- (NSString *)getPayMentMeethodStr
{
    NSString *str = @"";
    if (_paymentMethod != nil) {
        if (![_paymentMethod isEmptyStr]) {
            str = _paymentMethod;
        }
    }
    return str;
}
/**
 商品名称
 */
- (NSString *)getPrdNameStr
{
    NSString *str = @"";
    if (_prdName != nil) {
        if (![_prdName isEmptyStr]) {
            str = _prdName;
        }
    }
    return str;
}

/**
 商品订单号
 */
- (NSString *)getPrdOrdNoStr
{
    NSString *str = @"";
    if (_prdOrdNo != nil) {
        if (![_prdOrdNo isEmptyStr]) {
            str = _prdOrdNo;
        }
    }
    return str;
}
/**
 支付订单号（充值时是支付订单号）
 */
- (NSString *)getPayOrdNoStr
{
    NSString *str = @"";
    if (_payOrdNo != nil) {
        if (![_payOrdNo isEmptyStr]) {
            str = _payOrdNo;
        }
    }
    return str;
}



#pragma mark - 消费样式相关
- (NSString *)getShangPinXinXiStr
{
    NSString *str = [NSString stringWithFormat:@"%@",[self getPrdNameStr]];
    return str;
}
- (NSString *)getOrderTimeStr
{
    NSString *str = @"";
    if (_orderTime != nil) {
        if (![_orderTime isEmptyStr]) {
            str = _orderTime;
        }
    }
    return str;
}
- (NSString *)getShangPinDingDanHaoStr
{
    NSString *str = @"";
    if (_prdOrdNo != nil) {
        if (![_prdOrdNo isEmptyStr]) {
            str = _prdOrdNo;
        }
    }
    return str;
}
- (NSString *)getZhiFuLiuShuiHaoStr
{
    NSString *str = @"";
    if (_payOrdNo != nil) {
        if (![_payOrdNo isEmptyStr]) {
            str = _payOrdNo;
        }
    }
    return str;
}

//(消费---扫一扫超级收款码/扫一扫pc端生成的二维码/TX)
/**
 订单状态 状态码 00:未支付 01:支付成功  02:支付失败 90处理中99:超时）
 */
- (NSString *)getXiaoFeiOrderStatusCode
{
    NSString *str = @"";
    if (_ordStatus != nil) {
        if (![_ordStatus isEmptyStr]) {
            str = _ordStatus;
        }
    }
    return str;
}
//(消费---扫一扫超级收款码/扫一扫pc端生成的二维码/TX)
/**
 订单状态 状态码 00:未支付 01:支付成功  02:支付失败 90处理中99:超时）
 */
- (NSString *)getXiaoFeiOrderStatusStr{
    NSString *str = @"";
    NSString *statusStr = [self getXiaoFeiOrderStatusCode];
    if ([statusStr isEqualToString:@"00"]) {
        str = @"未支付";
    }else if ([statusStr isEqualToString:@"01"]){
        str = @"交易成功";
    }else if ([statusStr isEqualToString:@"02"]){
        str = @"交易失败";
    }else if ([statusStr isEqualToString:@"90"]){
        str = @"处理中";
    }else if ([statusStr isEqualToString:@"99"]){
        str = @"超时";
    }
    return str;
}

#pragma mark - 消费手机充值相关
//充值说明（显示商品名称）
- (NSString *)getChonZhiDescStr
{
    NSString *str = [NSString stringWithFormat:@"%@",[self prdName]];
    return str;
}

//充值号码（加密）
- (NSString *)getPhoneNumberStr
{
    NSString *str = @"";
    if (_phoneNumber != nil) {
        if (![_phoneNumber isEmptyStr]) {
            str = [_phoneNumber decryptAES];
        }
    }
    return str;
}

//面值
- (NSString *)getProdContentStr
{
    NSString *str = @"";
    if (_prodContent != nil) {
        if (![_prodContent isEmptyStr]) {
            str = _prodContent;
        }
    }
    return str;
}

//交易对象 
- (NSString *)getProdispTypeStr
{
    NSString *str = @"";
    if (_prodispType != nil) {
        if (![_prodispType isEmptyStr]) {
            str = _prodispType;
        }
    }
    return str;
}
//创建时间
- (NSString *)getPhoneOrderTimeStr
{
    NSString *str = [self getOrderTimeStr];
    return str;
}

#pragma mark - 转账相关
//转账说明
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

//对方账号（加密）
- (NSString *)getTragetNoStr
{
    NSString *str = @"";
    if (_tragetNo != nil) {
        if (![_tragetNo isEmptyStr]) {
            str = [_tragetNo decryptAES];
        }
    }
    return str;
}

//转账创建时间
- (NSString *)getTraTimeStr
{
    NSString *str = @"";
    if (_traTime != nil) {
        if (![_traTime isEmptyStr]) {
            str = _traTime;
        }
    }
    return str;
}
//转账 支付流水号
- (NSString *)getTraOrdNoStr
{
    NSString *str = @"";
    if (_traOrdNo != nil) {
        if (![_traOrdNo isEmptyStr]) {
            str = _traOrdNo;
        }
    }
    return str;
}
//对方账户名
- (NSString *)getToAccNameStr
{
    NSString *str = @"";
    if (_toAccName != nil) {
        if (![_toAccName isEmptyStr]) {
            str = _toAccName;
        }
    }
    return str;
}
//01:转账成功  02:转账失败 03转账处理中
- (NSString *)getZhuanZhangOrdStatusCode{
    NSString *str = @"";
    if (_ordStatus != nil) {
        if (![_ordStatus isEmptyStr]) {
            str = _ordStatus;
        }
    }
    return str;
}
//01:转账成功  02:转账失败 03转账处理中 04转账待处理 05转账冻结 06转账撤销 07后台撤销）
- (NSString *)getZhuanZhangOrdStatusStr{
    NSString *str = @"";
    NSString *ordStatusCode = [self getZhuanZhangOrdStatusCode];
    if ([ordStatusCode isEqualToString:@"01"]) {
        str = @"转账成功";
    }else if ([ordStatusCode isEqualToString:@"02"]){
        str = @"转账失败";
    }else if ([ordStatusCode isEqualToString:@"03"]){
        str = @"转账处理中";
    }else if ([ordStatusCode isEqualToString:@"04"]){
        str = @"转账待处理";
    }else if ([ordStatusCode isEqualToString:@"05"]){
        str = @"转账冻结";
    }else if ([ordStatusCode isEqualToString:@"06"]){
        str = @"转账撤销";
    }else if ([ordStatusCode isEqualToString:@"07"]){
        str = @"后台撤销";
    }
    
    
    
    return str;
}

#pragma mark - 账户充值相关
//账户充值时间
- (NSString *)getAccountChonZhiTimeStr
{
    NSString *str = @"";
    if (_orderTime != nil) {
        if (![_orderTime isEmptyStr]) {
            str = _orderTime;
        }
    }
    return str;
}
//账户充值\交易单号
- (NSString *)getAccountChonZhiDanHaoStr
{
    NSString *str = @"";
    if (_payOrdNo != nil) {
        if (![_payOrdNo isEmptyStr]) {
            str = _payOrdNo;
        }
    }
    return str;
}

#pragma mark - 账户提现相关
//申请时间
- (NSString *)getAccountTiXianShenQingTimeStr
{
    NSString *str = @"";
    if (_orderTime != nil) {
        if (![_orderTime isEmptyStr]) {
            str = _orderTime;
        }
    }
    return str;
}
//到账时间
- (NSString *)getAccountTiXianDaoZhangTimeStr
{
    NSString *str = @"";
    if (_paymentTime != nil) {
        if (![_paymentTime isEmptyStr]) {
            str = _paymentTime;
        }
    }
    return str;
}
//订单状态 01:提现处理中  02:提现成功  03:提现失败
- (NSString *)getAccountOrdStatusCode
{
    NSString *str = @"";
    if (_ordStatus != nil) {
        if (![_ordStatus isEmptyStr]) {
            str = _ordStatus;
        }
    }
    return str;
}
//订单状态 01:提现处理中  02:提现成功  03:提现失败
- (NSString *)getAccountOrdStatusCodeStr
{
    NSString *str = @"";
    NSString *orderStatsStr = [self getAccountOrdStatusCode];
    if ([orderStatsStr isEqualToString:@"01"]) {
        str = @"提现处理中";
    }else if ([orderStatsStr isEqualToString:@"02"]){
        str = @"提现成功";
    }else if ([orderStatsStr isEqualToString:@"03"]){
        str = @"提现失败";
    }
    return str;
}
//提现订单号
- (NSString *)getAccountCasOrdNoStr
{
    NSString *str = @"";
    if (_casOrdNo != nil) {
        if (![_casOrdNo isEmptyStr]) {
            str = _casOrdNo;
        }
    }
    return str;
}
@end
