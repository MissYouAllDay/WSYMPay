//
//  YMPrepaidCardModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMPrepaidCardModel : NSObject

/**
 预付卡卡号
 */
@property (nonatomic, copy) NSString *prepaidNo;
/**
 txAmt
 */
@property (nonatomic, copy) NSString *txAmt;
/**
 支付密码
 */
@property (nonatomic, copy) NSString *payPwd;
/**
 商品订单号
 */
@property (nonatomic, copy) NSString *prdOrdNo;
/**
 随机码
 */
@property (nonatomic, copy) NSString *randomCode;
/**
 卡种 01：预付卡
 */
@property (nonatomic, copy) NSString *cardkindid;
/**
 绑定时间	
 */
@property (nonatomic, copy) NSString * insertt;
/**
 卡类型 	 面值卡  充值卡
 */
@property (nonatomic, copy) NSString *cardflag;
/**
 卡名称
 */
@property (nonatomic, copy) NSString *cardissueid;
/**
 绑定状态
 */
@property (nonatomic, copy) NSString *cardBindStatus;
/**
 卡bin
 */
@property (nonatomic, copy) NSString *bindno;

-(YMPrepaidCardModel *)getDecryptAESModel;

-(YMPrepaidCardModel *)getEnCryptAESModel;
@end
