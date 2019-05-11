//
//  YMPrepaidCardDetailsModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//


/*
 * 收支明细--预付费卡充值查询Model
 * 新修改的model
 */
#import <Foundation/Foundation.h>

@interface YMPrepaidCardDetailsModel : NSObject

@property (nonatomic, copy) NSString *prepaidNo;//卡号(需解密)
@property (nonatomic, copy) NSString *cardflag;//卡类型
@property (nonatomic, copy) NSString *bankName;//银行名称 转出至
@property (nonatomic, copy) NSString *ordStatus;//交易状态
@property (nonatomic, copy) NSString *orderDate;//申请时间、交易时间
@property (nonatomic, copy) NSString *endTime;//受理时间
@property (nonatomic, copy) NSString *prdOrdNo;//交易单号
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
 * 交易类型名称
 */
- (NSString *)getPrdNameStr;
/**
 * 申请时间
 * 退款 --- 交易时间
 * 否则 --- 申请时间
 */
- (NSString *)getOrderDateStr;
/**
 * 受理时间
 * 退款 --- 不显示
 * 否则 --- 显示
 */
- (NSString *)getEndTimeStr;
/**
 * 交易状态
 */
- (NSString *)getOrdStatusStr;
/**
 * 交易单号
 */
- (NSString *)getPrdOrdNoStr;
/**
 * 预付卡卡号
 * 格式：卡类型（预付卡号前6位与后4位展示，中间部分用 * 代替）
 */
- (NSString *)getPrepaidNoStr;
/**
 * 卡类型
 */
- (NSString *)getCardFlagStr;
/**
 * 金额
 */
- (NSString *)getTxAmtStr;

/**
 * 预付卡卡号
 * 格式：卡类型（预付卡号前6位与后4位展示，中间部分用 * 代替）
 */
- (NSString *)getPrepaidCardMsgStr;


#pragma mark - key
/** key **/
/**
 * key：
 * 退款 ---交易时间
 * 否则 ---申请时间
 */
- (NSString *)getOrderDateKeyStr;

/**
 * key：
 * 退款 ---不显示到账时间
 * 否则 ---显示到账时间这一行
 */
- (BOOL)isShowEndTimeKey;

/**
 * key：
 * 退款 ---不显示预付卡信息这一行
 * 否则 ---显示预付卡信息这一行
 */
- (BOOL)isShowPrepaidCard;

@end
