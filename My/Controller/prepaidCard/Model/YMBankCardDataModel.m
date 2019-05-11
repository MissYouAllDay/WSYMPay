//
//  YMPrepaidCardDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBankCardDataModel.h"
#import "YMBankCardModel.h"
#import <MJExtension.h>
#import "NSString+AES.h"
@implementation YMBankCardDataModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"YMBankCardModel"};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
- (NSMutableArray *)getBankCardListArray
{
    NSMutableArray *array = [[NSMutableArray array] init];
    if (_list && _list.count>0) {
        array = _list;
    }
    return array;
}


/**
  获取查询的支付方式model
 (扫一扫可以用)
  create by pzj 2017-5-15
 @return model
 */
- (YMBankCardModel *)getPayTypeBankModel
{
    if ([_canPayCard isEqualToString:@"1"]) {//支持快捷支付
        for (YMBankCardModel *m in [self getBankCardListArray]) {
            if ([[m getLastUsedStr] isEqualToString:@"1"]) {
                return m;
                break;
            }
        }
    }
    return nil;
}
/**
 获取默认选择方式的信息
 */
- (NSString *)getBindingBankStr
{
    NSString *str = @"";
    if (_useType == 0) {//余额
        str = @"余额支付";
    }else if (_useType == 1){//银行卡(到list中去找lastUsed = 1 的银行卡信息(如果是信用卡提示选择支付方式。。。))
        
        NSString *bankMsg = @"";
        
        for (YMBankCardModel *model in [self getBankCardListArray]) {
            if ([[model getLastUsedStr]containsString:@"1"]) {
                if ([[model getLastUsedStr]isEqualToString:@"1"]){
                    if (model.cardType == 1) {//银行卡
                         bankMsg = [model getBankStr];
                    }else{
                        bankMsg = @"";
                    }
                }
            }
        }
        
        if ([bankMsg isEqualToString:@""]) {
            str = @"选择支付方式";
        }else{
            str = bankMsg;
        }
        
    }else if (_useType == 2){//预付卡
        str = @"选择支付方式";
    }else if (_useType == 9){//qing选择支付方式
        str = @"选择支付方式";
    }
    return str;
}

/**
 获取默认卡的信息
 */
- (YMBankCardModel *)getBindingBankModel
{
    YMBankCardModel *bankCardModel = [[YMBankCardModel alloc] init];
    if (_useType == 1) {
        
        YMBankCardModel *m = [[YMBankCardModel alloc] init];
        BOOL bank = NO;
        for (YMBankCardModel *model in [self getBankCardListArray]) {
            if ([[model getLastUsedStr]containsString:@"1"]) {
                if ([[model getLastUsedStr]isEqualToString:@"1"]) {
                    if (model.cardType == 1) {//银行卡
                        bank = YES;
                        m = model;
                    }else{
                        bank = NO;
                    }
                }
            }
        }
        
        if (bank) {
            bankCardModel = m;
        }else{
            bankCardModel = nil;
        }
        
    }else{
        bankCardModel = nil;
    }
    return bankCardModel;
}
/**
 商品订单号
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
 随机码
 */
- (NSString *)getRandomCodeStr
{
    NSString *str = @"";
    if (![_randomCode isEmptyStr]) {
        str = _randomCode;
    }
    return str;
}

/**
 余额是否足够
 3期修改：pzj
 是否支持余额支付canAcbalUse---0不支持，余额支付置灰
                         ---1支持---> acbalUse 余额是否足够---> 0不足，余额置灰
                                                        ---> 1足够，可余额支付。。。
 */
- (BOOL)isAcbalUsed
{
    BOOL isUsed;
    if (_canAcbalUse == 0) {
        isUsed = NO;
    }else{
        if (_acbalUse == 0) {
            isUsed = NO;
        }else{
            isUsed = YES;
        }
    }
    return isUsed;
}
@end
