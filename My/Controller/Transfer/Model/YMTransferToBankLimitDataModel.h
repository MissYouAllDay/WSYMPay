//
//  YMTransferToBankLimitDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/11.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMTransferToBankLimitDataModel : NSObject

@property (nonatomic, copy) NSString *cashAcBal;//当前账户余额
@property (nonatomic, copy) NSString *limitDayAmt;//日最大交易限额
@property (nonatomic, copy) NSString *lmitMaxAmt;//单笔可转账

/**
 当前账户余额

 @return string
 */
- (NSString *)getCashAcBalStr;

/**
 单笔可转账
 
 @return string
 */
- (NSString *)getLmitMaxAmtStr;

/**
 日最大交易限额
 
 @return string
 */
- (NSString *)getLimitDayAmtStr;


/**
 限额说明
 
 @return str
 */
- (NSString *)getLimitDescStr;

@end
