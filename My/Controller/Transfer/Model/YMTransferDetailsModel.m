//
//  YMTransferBillListModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferDetailsModel.h"
#import "NSString+AES.h"
@implementation YMTransferDetailsModel
-(void)setTxAmt:(NSString *)txAmt
{
    _txAmt = [txAmt copy];
    _txAmt = _txAmt.decryptAES;
}

-(NSString *)getOrdStatus
{
    NSInteger index = [_ordStatus integerValue];
    
    if ([self.tranType isString:@"转账"]) {
        switch (index) {
            case 0:
                return @"待付款";
                break;
            case 1:
                return @"转账成功";
                break;
            case 2:
                return @"转账失败";
                break;
            case 3:
                return @"转账处理中";
                break;
            default:
                return @"超时";
                break;
        }
        
    } else {
        switch (index) {
            case 0:
                return @"未支付";
                break;
            case 1:
                return @"支付成功";
                break;
            case 2:
                return @"支付失败";
                break;
            case 3:
                return @"退款审核中";
                break;
            case 4:
                return @"退款处理中";
                break;
            case 5:
                return @"退款成功";
                break;
            case 6:
                return @"退款失败";
                break;
            case 7:
                return @"撤销审核中";
                break;
            case 8:
                return @"同意撤销";
                break;
            case 9:
                return @"撤销成功";
                break;
            case 10:
                return @"撤销失败";
                break;
            case 11:
                return @"订单作废";
                break;
            case 12:
                return @"预付款";
                break;
            case 13:
                return @"延迟付款审核中";
                break;
            case 14:
                return @"冻结";
                break;
            case 15:
                return @"同意延迟付款";
                break;
            case 16:
                return @"拒绝延迟付款";
                break;
            case 90:
                return @"支付处理中";
                break;
                
            default:
                return @"超时";
                break;
        }
    }
}
@end
