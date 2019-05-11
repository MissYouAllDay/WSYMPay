//
//  YMCashDetailsModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 收支明细--提现详情查询Model
 * 新修改的model
 */

#import <Foundation/Foundation.h>

@interface YMCashDetailsModel : NSObject

@property (nonatomic, copy) NSString *bankAcNo;//银行卡号后4位 (需解密)
@property (nonatomic, copy) NSString *bankName;//银行名称 转出至
@property (nonatomic, copy) NSString *ordStatus;//交易状态
@property (nonatomic, copy) NSString *actdat;//申请时间、交易时间
@property (nonatomic, copy) NSString *sucdat;//到账时间
@property (nonatomic, copy) NSString *casordNo;//交易单号
@property (nonatomic, copy) NSString *prdName;//交易类型名称
@property (nonatomic, copy) NSString *txAmt;//金额(需解密)

//自己本地添加的 区分金额显示 +  -  
//是否是收入和支出(1支出2 收入)
@property (nonatomic, assign) NSInteger inOrOut;

/**
 * header title
 */
- (NSString *)getHeadTitleStr;
/**
 * 交易名称
 */
- (NSString *)getPrdNameStr;
/**
 * 申请时间、交易时间
 * 提现失败状态：只有交易时间，现在取申请时间。
 */
- (NSString *)getActdatStr;
/**
 * 到账时间
 */
- (NSString *)getSucdatStr;
/**
 * 交易状态
 */
- (NSString *)getOrdStatusStr;
/**
 * 交易单号
 */
- (NSString *)getCasordNoStr;
/**
 * 金额
 */
- (NSString *)getTxAmtStr;
/**
 * 银行卡后4位
 */
- (NSString *)getBankAcNoStr;
/**
 * 银行卡名
 */
- (NSString *)getBankNameStr;
/**
 * 转出至：
 * 银行卡名(银行卡后4位)
 */
- (NSString *)getBankMsgStr;

#pragma mark - key
/** key **/
/**
 * key：
 * 提现失败---交易时间
 * 否则   ---申请时间
 */
- (NSString *)getActdatKeyStr;

/**
 * key：
 * 提现失败---不显示到账时间
 * 否则   ---显示到账时间这一行
 */
- (BOOL)isShowSucdatKey;

/**
 * key：
 * 提现失败---不显示银行卡信息这一行
 * 否则   ---显示银行卡信息这一行
 */
- (BOOL)isShowBankMsgKey;

@end
