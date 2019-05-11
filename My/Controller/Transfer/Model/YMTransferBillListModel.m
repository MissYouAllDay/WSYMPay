//
//  YMTransferBillListModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferBillListModel.h"
#import "NSString+AES.h"
@implementation YMTransferBillListModel
-(void)setTxAmt:(NSString *)txAmt
{
    _txAmt = [txAmt copy];
    _txAmt = _txAmt.decryptAES;
}
-(NSString *)ordStatus
{
    if ([_ordStatus isString:@"00"]) {
        return @"待付款";
    } else if ([_ordStatus isString:@"01"]) {
        return @"转账成功";
    }  else if ([_ordStatus isString:@"02"]) {
        return @"转账失败";
    } else if ([_ordStatus isString:@"03"]) {
        return @"转账处理中";
    } else {
        return @"超时";
    }
}
@end
