//
//  YMTransferCheckPayPwdDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 转账到余额校验支付密码 总model中的data Model
 */
/*
 * 转账到银行卡校验支付密码 总model中的data Model
 */

#import "YMTransferToBankSearchFeeDataModel.h"

@interface YMTransferCheckPayPwdDataModel : YMTransferToBankSearchFeeDataModel

@property (nonatomic, copy) NSString *backError;//交易失败原因
@property (nonatomic, copy) NSString *traordNo;//转账订单号(本地增加的，非这个接口请求回的)

//因为继承自YMTransferToBankSearchFeeDataModel 所以不用再写下面的了
//@property (nonatomic, copy) NSString *cardName;//持卡人姓名
//@property (nonatomic, copy) NSString *txAmt;//交易金额 转账 金额 描述（本地增加）
//@property (nonatomic, copy) NSString *bankAcNo;//银行卡号
//@property (nonatomic, copy) NSString *bankAcMsg;//银行名称，银行卡号(如：招商银行(8443)）/收款账号信息

/**
 交易失败原因
 */
- (NSString *)getBackErrorStr;

/**
 上个接口传过来的 转账订单号
 */
- (NSString *)getTraordNoStr;

/**
 * 转账到银行卡处理中返回的 金额（因后台返回时加密的需要界面）
 */
- (NSString *)getTransferChuLiTxAmtStr;

@end
