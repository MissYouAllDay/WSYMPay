//
//  YMPrepaidCardDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 预付充值卡  银行卡相关充值卡 data  model
 */
#import <Foundation/Foundation.h>

@class YMBankCardModel;

@interface YMBankCardDataModel : NSObject

@property (nonatomic, assign) NSInteger acbalUse;//余额是否足够,0不足1足够
@property (nonatomic, assign) NSInteger hasBank;//是否绑定有银行卡（选择支付方式时，0不展示可用银行卡，1时展示）
@property (nonatomic, assign) NSInteger useType;//默认选择的支付方式(判断付款方式  0余额1银行卡2预付卡9请选择支付方式)
@property (nonatomic, copy) NSString *prdOrdNo;//商品订单号
@property (nonatomic, copy) NSString *randomCode;//随机码
@property (nonatomic, assign) NSInteger canAcbalUse;//是否支持余额支付（选择支付方式时，0不展示余额，1时展示）
@property (nonatomic, copy) NSString *canPayCard;//是否支持快捷
@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, copy) NSString *useTypeValue;//默认支付方式
@property (nonatomic, copy) NSString *defPaySign;//默认银行卡paysign
@property (nonatomic, copy) NSString *cashAcBal;//账户余额tranTypeSel为3时返回


/**
 获得 list array
 */
- (NSMutableArray *)getBankCardListArray;
/**
 获取默认选择方式的信息
 */
- (NSString *)getBindingBankStr;
/**
 获取默认卡的信息
 */
- (YMBankCardModel *)getBindingBankModel;
/**
 商品订单号
 */
- (NSString *)getPrdOrdNoStr;
/**
 随机码
 */
- (NSString *)getRandomCodeStr;
/**
 余额是否足够
 */
- (BOOL)isAcbalUsed;


#pragma mark - app4期收银台
/**
 获取默认选择方式的信息
 */
- (NSString *)getPayBankStr;

/**
 获取默认支付方式，0余额1银行卡2预付卡9请选择支付方式
 */
- (NSInteger)getUseType;

/**
 余额是否足够 0不足1足够（YES 足够，NO 不足）
 
 @return （YES 足够，NO 不足）
 */
- (BOOL)getIsAcbalUse;

/**
 paysing
 */
- (NSString *)getDefPaySignStr;
//当前选中的model
- (YMBankCardModel *)getPayTypeModel;
//根据paySign找到对应的model
- (YMBankCardModel *)getCurrentPayTypeModel:(NSString *)paySign;

@end
