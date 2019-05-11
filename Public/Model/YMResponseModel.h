//
//  YMResponseModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/1/22.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMResponseModel : NSObject

@property (nonatomic, assign) NSInteger payPwdStatus;
@property (nonatomic, copy) NSString *cashAcBal;
@property (nonatomic, copy) NSString *frozBalance;
@property (nonatomic, copy) NSString *disableBalance;
@property (nonatomic, copy) NSString *custLogin;
@property (nonatomic, copy) NSString *usrEmail;
@property (nonatomic, copy) NSString *usrJob;
@property (nonatomic, copy) NSString *usrMobile;
@property (nonatomic, copy) NSString *phoneAddress;
@property (nonatomic, copy) NSString *custName;
@property (nonatomic, copy) NSString *custCredNo;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *resMsg;
@property (nonatomic, copy) NSString *randomCode;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankNo;
@property (nonatomic, copy) NSString *bankCardType;
@property (nonatomic, assign) NSInteger cardType;
@property (nonatomic, assign) NSInteger resCode;
@property (nonatomic, assign) NSInteger usrStatus;
@property (nonatomic, assign) NSInteger canWriteOff;
@property (nonatomic, copy) NSString *preOrderNo;//绑卡订单号
@property (nonatomic, copy) NSString *insFlag;//是否存在绑定关系
@property (nonatomic, copy) NSString *amountLimit;
@property (nonatomic, copy) NSString *surplusAMT;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *usrCateGory;
@property (nonatomic, copy) NSString *certNum;
@property (nonatomic, copy) NSString *threeAcLogin;
@property (nonatomic, copy) NSString *userID;//账户ID
@property (nonatomic, copy) NSString *paySign;//银行卡token（新增）(只有绑定信用卡的时候才会返回)
@property (nonatomic, copy) NSString *cardFlag;//02 信用卡


@property (nonatomic, copy) NSString *chaneel_short;//
@property (nonatomic, copy) NSString *trxId;//
@property (nonatomic, copy) NSString *trxDtTm;//
@property (nonatomic, copy) NSString *smskey;//
@property (nonatomic, copy) NSString *wl_url;//


@property (nonatomic, copy) NSDictionary *data;

+(instancetype)loadModelFromDic:(NSDictionary *)dic;

- (NSString *) getResMsg;
- (NSInteger) getResCode;
/**
 认证状态 -1是‘未实名’，-2 是'未认证'， '1' 是 '认证审核中'， '2' 是 '已通过认证'跳转到 ， '3' 是 '未通过认证' ‘0’ 是未登录
 */
- (NSInteger) getUsrStatus;
- (NSString *) getRandomCode;

@end
