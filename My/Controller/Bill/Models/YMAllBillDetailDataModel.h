//
//  YMAllBillDetailDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAllBillDetailDataModel : NSObject

@property (nonatomic, copy) NSString *merNam;//商户名称
@property (nonatomic, copy) NSString *txAmt;//订单金额（加密）
@property (nonatomic, copy) NSString *ordStatus;//订单状态（00:未支付 01:支付成功  02:支付失败 90处理中99:超时）

@property (nonatomic, copy) NSString *acceptState;//投诉状态（0未投诉1未处理  2已处理 3已确认）
@property (nonatomic, copy) NSString *comRemark;//投诉原因
@property (nonatomic, copy) NSString *handleRemark;//投诉处理说明

@property (nonatomic, copy) NSString *paymentMethod;//付款方式
@property (nonatomic, copy) NSString *prdName;//商品名称
@property (nonatomic, copy) NSString *orderTime;//创建时间
@property (nonatomic, copy) NSString *prdOrdNo;//商品订单号
@property (nonatomic, copy) NSString *payOrdNo;//支付订单号

@property (nonatomic, copy) NSString *phoneNumber;//充值号码（加密）
@property (nonatomic, copy) NSString *prodContent;//面值
@property (nonatomic, copy) NSString *prodispType;//交易对象

@property (nonatomic, copy) NSString *orderMsg;//转账说明
@property (nonatomic, copy) NSString *tragetNo;//对方账号（加密）
@property (nonatomic, copy) NSString *traTime;//创建时间
@property (nonatomic, copy) NSString *traOrdNo;//支付流水号
@property (nonatomic, copy) NSString *toAccName;//对方账户名

\
@property (nonatomic, copy) NSString *paymentTime;//到账时间
@property (nonatomic, copy) NSString *casOrdNo;//提现订单号

#pragma mark - header
/**
 商户名称
 */
- (NSString *)getMerNamStr;
/**
 订单金额（加密）
 */
- (NSString *)getTxAmtStr;
/**
 订单状态 文字提示 00:未支付 01:支付成功  02:支付失败 90处理中99:超时）
 */
- (NSString *)getOrderStatusStr;
/*
 * 转账订单状态 01:转账成功  02:转账失败 03转账处理中
 */
- (NSString *)getTransOrderStatusStr;
/**
 订单状态 状态码 00:未支付 01:支付成功  02:支付失败 90处理中99:超时）
 */
- (NSString *)getStatusCodeStr;

#pragma mark - 投诉
/**
  投诉状态 文字提示（0未投诉1未处理  2已处理 3已确认）
 */
- (NSString *)getAcceptStateStr;
/**
 投诉状态 状态码（0未投诉1未处理  2已处理 3已确认）
 */
- (NSString *)getAcceptStateCodeStr;
/**
 投诉原因
 */
- (NSString *)getComRemarkStr;
/**
 投诉处理说明
 */
- (NSString *)getHandleRemarkStr;

#pragma mark ------------------- 
/**
 消费/手机充值/转账消费---扫一扫超级收款码/扫一扫pc端生成的二维码/TX   付款方式
 */
- (NSString *)getPayMentMeethodStr;
/**
 商品名称
 */
- (NSString *)getPrdNameStr;

/**
 商品订单号
 */
- (NSString *)getPrdOrdNoStr;
/**
 支付订单号
 */
- (NSString *)getPayOrdNoStr;

#pragma mark -------------------

#pragma mark -------------------

#pragma mark -------------------
/**
 创建时间
 */
- (NSString *)getActDatStr;
/**
 到账时间
 */
- (NSString *)getSucDatStr;

#pragma mark - 消费样式相关
- (NSString *)getShangPinXinXiStr;
- (NSString *)getOrderTimeStr;//创建时间
- (NSString *)getShangPinDingDanHaoStr;//商品订单号
- (NSString *)getZhiFuLiuShuiHaoStr;//支付流水号
- (NSString *)getXiaoFeiOrderStatusCode;//(消费---扫一扫超级收款码/扫一扫pc端生成的二维码/TX)
- (NSString *)getXiaoFeiOrderStatusStr;//(消费---扫一扫超级收款码/扫一扫pc端生成的二维码/TX)

#pragma mark - 消费手机充值相关
- (NSString *)getChonZhiDescStr;//充值说明（显示商品名称）
- (NSString *)getPhoneNumberStr;//充值号码（加密）
- (NSString *)getProdContentStr;//面值
- (NSString *)getProdispTypeStr;//交易对象(显示运营商名)
- (NSString *)getPhoneOrderTimeStr;//创建时间

#pragma mark - 转账相关
- (NSString *)getOrderMsgStr;//转账说明
- (NSString *)getTragetNoStr;//对方账号（加密）
- (NSString *)getTraTimeStr;//转账创建时间
- (NSString *)getTraOrdNoStr;//转账 支付流水号
- (NSString *)getToAccNameStr;//对方账户名
- (NSString *)getZhuanZhangOrdStatusCode;//01:转账成功  02:转账失败 03转账处理中 04转账待处理 05转账冻结 06转账撤销 07后台撤销）
- (NSString *)getZhuanZhangOrdStatusStr;//001:转账成功  02:转账失败 03转账处理中 04转账待处理 05转账冻结 06转账撤销 07后台撤销）

#pragma mark - 账户充值相关
- (NSString *)getAccountChonZhiTimeStr;//账户充值时间
- (NSString *)getAccountChonZhiDanHaoStr;//账户充值\交易单号

#pragma mark - 账户提现相关
- (NSString *)getAccountTiXianShenQingTimeStr;//申请时间
- (NSString *)getAccountTiXianDaoZhangTimeStr;//到账时间
- (NSString *)getAccountOrdStatusCode;//订单状态
- (NSString *)getAccountOrdStatusCodeStr;//订单状态
- (NSString *)getAccountCasOrdNoStr;//提现订单号

@end
