//
//  YMBankCardModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/2.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMBaseResponseModel.h"
//add by pzj
#import <Foundation/Foundation.h>

@interface YMBankCardModel : NSObject
/**
 银行卡号
 */
@property (nonatomic, copy) NSString *bankAcNo;
/**
银行卡名称
 */
@property (nonatomic, copy) NSString *bankName;
/**
 银行卡类型名称
 */
@property (nonatomic, copy) NSString *bankCardType;
/**
 银行卡类型编号 01（借记卡）02（贷记卡）03(预付卡)
 */
@property (nonatomic, assign) NSInteger cardType;
/**
 银行卡logo
 */
@property (nonatomic, copy) NSString *logoPic;
/**
 银行卡背景色
 */
@property (nonatomic, copy) NSString *backgroudColor;
/**
 支付标记化token
 */
@property (nonatomic, copy) NSString *paySign;
/**
 随机码
 */
@property (nonatomic, copy) NSString *randomCode;
/**
 银行号 ICBC\ABC等
 */
@property (nonatomic, copy) NSString *bankNo;
/**
 订单号
 */
@property (nonatomic, copy) NSString *prdOrdNo;
/**
 最后添加的借记卡
 */
@property (nonatomic, copy) NSString *lastUsed;
/**
 提现订单号
 */
@property (nonatomic, copy) NSString *casordNo;
/**
 *  有效期
 */
@property (nonatomic, copy) NSString *cardDeadline;
/**
 安全码
 */
@property (nonatomic, copy) NSString *safetyCode;
/**
 持卡人
 */
@property (nonatomic, copy) NSString *cardName;
/**
 身份证号
 */
@property (nonatomic, copy) NSString *idCardNum;
/**
 银行预留手机号
 */
@property (nonatomic, copy) NSString *bankPreMobile;

//@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) NSInteger isFlag;//是否可用（0可用1不可用）

#pragma mark - app4期新增
//add by pzj 2017-7-18
/**
 是否为默认卡 未选中卡不传
 */
@property (nonatomic, assign) BOOL defaultCard;
@property (nonatomic, assign) BOOL isSelectBalance;//本地是否选中余额
@property (nonatomic, copy) NSString *useTypeValue;//发卡行信息
@property (nonatomic, assign) NSInteger userTypeNum;//本地增加的，当userType=9时，请选择支付方式是赋值

-(YMBankCardModel *)getDecryptAESModel;

-(YMBankCardModel *)getEnCryptAESModel;


/***** add by pzj ****/
//最后添加的借记卡
- (NSString *)getLastUsedStr;
//银行卡名
- (NSString *)getBankNameStr;
//银行卡后四位
- (NSString *)getBankAcNoStr;
//银行卡类型
- (NSString *)getBankTypeStr;
/**
 银行卡名+银行卡类型
 */
- (NSString *)getBankNameAndTypeStr;
/**
 银行卡信息
 */
- (NSString *)getBankStr;
/**
 logo
 */
- (NSString *)getLogoPicStr;
/**
 根据银行卡类型或者isFlag判断该卡是否可用（不可用置灰）
 银行卡类型编号 01（借记卡）02（贷记卡）
 3期新逻辑：
 cardType 02 或者 isFlag 为 1，都是不可用的
 */
- (NSInteger)getCardTypeNum;

/***** add by pzj ****/

#pragma mark - app4期，收银台新修改
/**
 是否可用（isFlag 字段 0可用1不可用)/YES可用，NO不可用
 
 @return YES可用，NO不可用
 */
- (BOOL)isCanUseFlag;

/**
 是否为默认卡(YES可用，NO不可用)

 @return YES可用，NO不可用
 */
- (BOOL)isDefaultCard;

/**
 银行卡类型编号 01（借记卡）02（贷记卡）03(预付卡)

 @return 1（借记卡）2（贷记卡）3(预付卡)
 */
- (NSInteger)getCardTypeCount;
/*
 * 支付标记 银行卡
 */
- (NSString *)getPaySignStr;







@end
