//
//  YMReChargeDetailsModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 收支明细--充值详情查询Model
 * 新修改的model
 */
#import <Foundation/Foundation.h>

@interface YMReChargeDetailsModel : NSObject

@property (nonatomic, copy) NSString *bankAcNo;//银行卡号后4位 (需解密)
@property (nonatomic, copy) NSString *bankName;//银行名称
@property (nonatomic, copy) NSString *ordStatus;//交易状态
@property (nonatomic, copy) NSString *orderDate;//交易时间
@property (nonatomic, copy) NSString *payordno;//交易单号 (需解密)
@property (nonatomic, copy) NSString *paytype;//支付方式
@property (nonatomic, copy) NSString *prdName;//交易类型名称
@property (nonatomic, copy) NSString *txAmt;//交易金额(需解密)

//自己本地添加的 区分金额显示 +  -
//是否是收入和支出(1支出2 收入)
@property (nonatomic, assign) NSInteger inOrOut;

/**
 * header title
 */
- (NSString *)getHeadTitleStr;
- (NSString *)getPrdNameStr;
- (NSString *)getOrderDateStr;
- (NSString *)getOrdStatusStr;
- (NSString *)getPayordnoStr;
- (NSString *)getTxAmtStr;
- (NSString *)getPaytypeStr;
- (NSString *)getBankAcNoStr;
- (NSString *)getBankNameStr;

//注：只有当支付方式为（03）快捷支付时，才会返回银行名称（bankname）以及银行卡后4位（bankAcNo）
/**
 * 交易方式对应的value值
 */
- (NSString *)getPayTypeValueStr;

@end
