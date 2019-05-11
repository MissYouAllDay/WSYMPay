//
//  YMTransferRecentRecodeDataListModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 转账--查询最近转账记录model中 data的model 中的list列表
 */

/*
 * 转账到银行卡---限额说明model(bankName/lmitMaxAmt)用这两个字段
 */

#import <Foundation/Foundation.h>

@interface YMTransferRecentRecodeDataListModel : NSObject

@property (nonatomic, copy) NSString *toAccName;//接收方用户名
@property (nonatomic, copy) NSString *toAccount;//接收方手机号（遮蔽）
@property (nonatomic, copy) NSString *toAccounts;//接收方手机号（未遮蔽）
@property (nonatomic, copy) NSString *bankName;//银行卡名称
@property (nonatomic, copy) NSString *tratype;//转账说明(01余额转余额 06余额转银行卡)

//转账到银行卡---限额说明model(bankName/lmitMaxAmt)用这两个字段
@property (nonatomic, copy) NSString *lmitMaxAmt;


/**
 接收方用户名
 */
- (NSString *)getToAccNameStr;

/**
 接收方手机号/银行卡号（遮蔽）
 */
- (NSString *)getToAccountStr;

/**
 接收方手机号/银行卡号 （未遮蔽）
 */
- (NSString *)getToAccountsStr;

/**
 银行卡名称
 */
- (NSString *)getBankNameStr;

/**
 转账说明(01余额转余额 06余额转银行卡)
 */
- (NSString *)getTratypeStr;

/**
 限额说明 limit
 */
- (NSString *)getLmitMaxAmtStr;


@end
