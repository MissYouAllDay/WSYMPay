//
//  YMScanModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/10.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMScanModel.h"
#import <MJExtension.h>
#import "NSString+AES.h"
#import "YMBankCardModel.h"

@implementation YMScanModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"YMBankCardModel"};
}

-(void)setTxAmt:(NSString *)txAmt
{
    _txAmt = [txAmt copy];
    _txAmt = _txAmt.decryptAES;
}

-(NSString *)getPayType
{
    NSInteger useType = [self.useType integerValue];
    
    switch (useType) {
        case 0:
            return @"余额";
            break;
        case 1:
            return [self getPayBankCardInfo];
            break;
        case 2:
            //预付卡支付
            return @"请选择支付方式";
            break;
    
        default:
            return @"请选择支付方式";
            break;
    }
    
}

-(YMBankCardModel *)getPayBankCardModel
{
    
    for (YMBankCardModel *m in self.list) {
        if ([m.lastUsed isString:@"1"]) {
            return m;
            break;
        }
    }
    return nil;
}

-(NSString *)getPayBankCardInfo
{
    YMBankCardModel *m = [self getPayBankCardModel];
    
    if (m) {
        return [NSString stringWithFormat:@"%@%@(%@)",m.bankName,[m getBankTypeStr],m.bankAcNo];
    } else {
        return @"";
    }
}

-(BOOL)getCanAcbalUse
{
    if ([self.acbalUse isString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)getCanPayCard
{
    if ([self.canPayCard isString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
