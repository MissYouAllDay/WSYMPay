//
//  YMScanModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/10.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YMBankCardModel;
@interface YMScanModel : NSObject

@property (nonatomic, copy) NSString *randomCode;	//随机串
@property (nonatomic, copy) NSString *hasBank;	//是否绑定有银行卡（选择支付方式时，0不展示可用银行卡，1时展示）
@property (nonatomic, copy) NSString *useType;	//默认选择的支付方式0余额1银行卡2预付卡9请选择支付方式
@property (nonatomic, copy) NSString *acbalUse;	//	余额是否足够0不足1足够
@property (nonatomic, copy) NSString *prepaidCard;//商户是否支持预付卡支付	0不支持1支持
@property (nonatomic, copy) NSString *prdName;//商品名
@property (nonatomic, copy) NSString *txAmt;//金额
@property (nonatomic, copy) NSString *merNo;//商户号
@property (nonatomic, copy) NSString *cashAcBal;//账户余额
@property (nonatomic, copy) NSString *canPayCard;//是否支持快捷
@property (nonatomic, copy) NSString *prdOrdNo;

@property (nonatomic, strong) NSArray <YMBankCardModel *>*list;


/**
 是否可用余额
 */
-(BOOL)getCanAcbalUse;

/**
 是否支持快捷支付
 */
-(BOOL)getCanPayCard;

-(NSString *)getPayType;
-(YMBankCardModel *)getPayBankCardModel;

@end
