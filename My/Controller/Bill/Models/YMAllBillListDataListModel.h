//
//  YMAllBillListDataListModel.h
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAllBillListDataListModel : NSObject

#pragma mark - app4期中账单列表中返回的字段
@property (nonatomic, copy) NSString *ordDate;//订单日期
@property (nonatomic, copy) NSString *ordStatus;//订单状态(消费（tranType为1、2）（00:未支付 01:支付成功  02:支付失败 90处理中99:超时）充值（01:支付成功  02:支付失败 90处理中）提现（01:提现处理中  02:提现成功  03:提现失败）转账（01:转账成功  02:转账失败 03转账处理中）)
@property (nonatomic, copy) NSString *ordTime;//订单时间
@property (nonatomic, copy) NSString *orderMsg;//订单内容
@property (nonatomic, copy) NSString *orderNo;//订单号 (加密)
@property (nonatomic, copy) NSString *tranType;//交易类型（(对应详情分类)1消费2手机充值3充值4转账5提现）
@property (nonatomic, copy) NSString *txAmt;//金额(加密)

//本地增加字段
@property (nonatomic, copy) NSString *dateString;

/**
 订单日期
 */
- (NSString *)getOrdDateStr;
/**
 订单时间
 */
- (NSString *)getOrdTimeStr;
/**
 订单金额 (加密)
 */
- (NSString *)getOrdTxAmtStr;
/**
 订单内容
 */
- (NSString *)getOrderMsgStr;
/**
 订单状态(消费（tranType为1、2）（00:未支付 01:支付成功  02:支付失败 90处理中99:超时）充值（01:支付成功  02:支付失败 90处理中）提现（01:提现处理中  02:提现成功  03:提现失败）转账（01:转账成功  02:转账失败 03转账处理中）)
 */
- (NSString *)getOrdStatusStr;
/**
 订单号 (加密)
 */
- (NSString *)getOrderNoStr;
/**
 交易类型(对应详情分类)（1消费2手机充值3充值4转账5提现）
 */
- (NSString *)getTranTypeStr;


- (NSString *)getDateString;

@end
