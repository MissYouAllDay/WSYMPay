//
//  YMTransferToBankSearchFeeDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/9.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 转账到银行卡 --- 查询转账手续费 data Model
 */
#import "YMTransferToBankCheckBankDataModel.h"

@interface YMTransferToBankSearchFeeDataModel : YMTransferToBankCheckBankDataModel
@property (nonatomic, copy) NSString *reqFee;//转账手续费
@property (nonatomic, copy) NSString *bankAcMsg;//银行卡信息（如：招商银行(8443)）

//本地增加的字段 传到下个界面用（转账到余额--有名钱包账户转账界面）
@property (nonatomic, copy) NSString *cardName;//持卡人姓名
@property (nonatomic, copy) NSString *txAmt;//交易金额
@property (nonatomic, copy) NSString *bankAcNo;//银行卡号

/**
 转账手续费 参数传递
 */
- (NSString *)getReqFeeStr;
/**
 转账手续费
 */
- (NSString *)getUserTransFeeStr;
/**
 持卡人姓名
 */
- (NSString *)getCardNameStr;
/**
 交易金额
 */
- (NSString *)getTxAmtStr;
/**
 银行卡号
 */
- (NSString *)getBankAcNoStr;
/**
 收款账号
 */
- (NSString *)getShouKuanMsgStr;

/**
 收款账号信息/银行卡信息（如：招商银行(8443)）
 */
- (NSString *)getBankAcMsgStr;

@end
