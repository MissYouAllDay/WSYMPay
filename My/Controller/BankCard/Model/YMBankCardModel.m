//
//  YMBankCardModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/2.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMBankCardModel.h"
#import <MJExtension.h>

#import "NSString+AES.h"

@implementation YMBankCardModel
MJCodingImplementation
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
-(YMBankCardModel *)getDecryptAESModel
{
    self.bankAcNo = self.bankAcNo.decryptAES;
    self.paySign  = self.paySign.decryptAES;
    return self;
}

-(YMBankCardModel *)getEnCryptAESModel
{
    self.bankAcNo = self.bankAcNo.encryptAES;
    self.bankAcNo = self.bankAcNo.encryptAES;
    return self;
}
/***** add by pzj ****/
//最后添加的借记卡
- (NSString *)getLastUsedStr
{
    NSString *str = @"";
    if (![_lastUsed isEmptyStr]) {
        str = _lastUsed;
    }
    return str;
}
//银行卡名
- (NSString *)getBankNameStr
{
    NSString *str = @"";
    if (![_bankName isEmptyStr]) {
        str = _bankName;
    }
    return str;
}
//银行卡后四位
- (NSString *)getBankAcNoStr
{
    NSString *str = @"";
    if (![_bankAcNo isEmptyStr]) {
        str = _bankAcNo;
    }
    return str;
}
//银行卡类型
- (NSString *)getBankTypeStr
{
    NSString *str = @"";
    if (_cardType == 01) {
        str = @"储蓄卡";
    }else if(_cardType == 02){
        str = @"信用卡";
    }
    return str;
}
/**
 默认的银行卡信息
 */
- (NSString *)getBankStr
{
    NSString *str = @"";
    str = [NSString stringWithFormat:@"%@%@(%@)",[self getBankNameStr],[self getBankTypeStr],[self getBankAcNoStr]];
    return str;
}

/**
 logo
 */
- (NSString *)getLogoPicStr
{
    NSString *str = @"";
    if (![_logoPic isEmptyStr]) {
        str = [NSString stringWithFormat:@"%@%@",IP,_logoPic];
    }
    return str;
}
/**
 根据银行卡类型或者isFlag判断该卡是否可用（不可用置灰）
 银行卡类型编号 01（借记卡）02（贷记卡）
 3期新逻辑：
 cardType 02 或者 isFlag 为 1，都是不可用的
 */
- (NSInteger)getCardTypeNum
{
    NSInteger count;
    if (_cardType == 2 || _isFlag == 1) {//不可用
        count = 2;
    }else{//可用
        count = 1;
    }
    return count;
}
/***** add by pzj ****/


-(void)setLastUsed:(NSString *)lastUsed
{
    _lastUsed = lastUsed;
    self.selected = [_lastUsed isString:@"1"];
    
}

@end
