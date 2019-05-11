//
//  YMBillDetailsModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

/**
 * 收支明细列表 ---
 * changed by pzj
 * 新修改
 * 这个model 还是 支付列表信息存入数据库的model
 */
#import "YMBaseDB.h"

@interface YMBillDetailsModel : YMBaseDB

#pragma mark - ********* 2期时做得收支明细列表中返回的字段
//交易类型名称
@property (nonatomic, copy) NSString *prdName;
//交易状态码
@property (nonatomic, copy) NSString *ordStatus;
//交易金额(单位为（元）)
@property (nonatomic, copy) NSString *txAmt;
//交易时间(格式为：2015-10-16 10:01:21)
@property (nonatomic, copy) NSString *orderDate;
//交易状态名称 (账户充值、提现、转账、退款、在线支付、手机充值、便民缴费、信用卡还款、预付费卡充值、提现调账)
@property (nonatomic, copy) NSString *ordStatusName;
//交易类型 1转账2充值3提现4预付费卡充值
@property (nonatomic, assign) NSInteger tranType;
//交易单号
@property (nonatomic, copy) NSString *prdOrdNo;
//是否是收入和支出(1支出 2 收入)
@property (nonatomic, assign) NSInteger inOrOut;
@property (nonatomic, assign) NSInteger pageNum;//页数

//date (自己增加的字段，分割日期用)
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, assign) NSInteger currentPageNum;//当前所在页数
@property (nonatomic, assign) NSInteger allCount;//总条数
@property (nonatomic, assign) NSInteger currentCount;//当前条数

#pragma mark - 数据库相关
/**
 删除所有表
 */
+ (void)deletAllDBTable;

#pragma mark - 取值
/**
 交易类型名称
 */
- (NSString *)getPrdNameStr;
/**
 交易状态名称
 */
- (NSString *)getOrdStatusNameStr;
/**
 交易时间
 */
- (NSString *)getOrderDateStr;
/**
 交易金额，解密
 */
- (NSString *)getTxAmtStr;
/**
 交易单号
 */
- (NSString *)getPrdOrdNoStr;

/**
 提现详情查询传参 orderType（交易类型）---- 提现3退款4
 
 add by 2017-4-12
 tranType=3&&_inOrOut=2 ---- 退款 orderType = 4；
 tranType=3&&_inOrOut=1 ---- 提现 orderType = 3；
 @return orderType
 */
- (NSInteger )getOrderTypeNum;

@end
