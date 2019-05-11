//
//  YMTransferToBankCheckBankDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/9.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 转账到银行卡--验证银行卡dataModel  (data中数据)
 */

#import <Foundation/Foundation.h>

@interface YMTransferToBankCheckBankDataModel : NSObject

@property (nonatomic, copy) NSString *bankCardType;//银行卡类型
@property (nonatomic, copy) NSString *bankName;//银行名称
@property (nonatomic, copy) NSString *bankNo;//银行号
@property (nonatomic, copy) NSString *cardType;//银行卡类型
@property (nonatomic, copy) NSString *randomCode;//随机串


/**
 银行卡类型
 */
- (NSString *)getBankCardTypeStr;
/**
 银行名称
 */
- (NSString *)getBankNameStr;
/**
 银行号
 */
- (NSString *)getBankNoStr;
/**
 银行卡类型
 */
- (NSString *)getCardTypeStr;
/**
 随机串
 */
- (NSString *)getRandomCodeStr;

@end
