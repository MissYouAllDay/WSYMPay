//
//  CurrencyModel.h
//  WSYMPay
//
//  Created by W-Duxin on 16/10/31.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestModel : NSObject
@property (nonatomic, copy) NSString *idNoBegDate;
@property (nonatomic, copy) NSString *idNoEndDate;
/**
 *  登录账号
 */
@property (nonatomic, copy) NSString *custLogin;
/**
 *  验证码
 */
@property (nonatomic, copy) NSString *validateCode;
/**
 *  标识
 */
@property (nonatomic, copy) NSString *token;
/**
 *  随机数 修改登录密码时使用
 */
@property (nonatomic, copy) NSString *randomCode;

/**
 *  登录密码 
 */
@property (nonatomic, copy) NSString *custPwd;
/**
 *  新手机号/邮箱
 */
@property (nonatomic, copy) NSString *usrMp;
/**
 *交易终端
 */
@property (nonatomic, copy) NSString *tradeTerminal;
/**
 *经度
 */
@property (nonatomic, copy) NSString *longitude;
/**
 纬度
 */
@property (nonatomic, copy) NSString *latitude;
/**
 手机获取地址
 */
@property (nonatomic, copy) NSString *phoneAddress;

/**
   职业信息
 */
@property (nonatomic, copy) NSString *usrJobOpt;

/**
   mac地址
 */
@property (nonatomic, copy) NSString *macAddress;
/**
 *  身份证号
 */
@property (nonatomic, copy) NSString *idCardNum;
/**
 *  新手机号
 */
@property (nonatomic, copy, getter=x_newUsrMp, setter =setX_newUsrMp:) NSString *newUsrMp;
/**
 *  新密码
 */
@property (nonatomic, copy, getter=x_newCustPwd, setter =setX_newCustPwd:) NSString *newCustPwd;
/**
 * 新支付密码
 */
@property (nonatomic, copy,getter=x_newPayPwd, setter =setX_newPayPwd:) NSString *newPayPwd;
/**
 *支付密码
 */
@property (nonatomic, copy) NSString *payPwd;
@property (nonatomic, copy) NSString *payPwd1;

#pragma mark 银行卡相关
@property (nonatomic, copy) NSString *cardNo;
/**
 *  银行卡号
 */
@property (nonatomic, copy) NSString *bankAcNo;
/**
 *  银行卡类型编号
 */
@property (nonatomic, copy) NSString *cardType;
/**
 *  持卡人姓名
 */
@property (nonatomic, copy) NSString *cardName;
/**
 *  银行预留手机号
 */
@property (nonatomic, copy) NSString *bankPreMobile;
/**
 *  银行简称
 */
@property (nonatomic, copy) NSString *bankNo;
/**
 *  信用卡安全码
 */
@property (nonatomic, copy) NSString *safetyCode;
/**
 *  发卡行
 */
@property (nonatomic, copy) NSString *bankName;
/**
 *  有效期
 */
@property (nonatomic, copy) NSString *cardDeadline;

@property (nonatomic, copy) NSString *phoneModel;

@property (nonatomic, copy) NSString *ipAddress;

@property (nonatomic, copy) NSString *machineNum;

@property (nonatomic, copy) NSString *tranCode;

@property (nonatomic, copy) NSString *service_type;

@property (nonatomic, copy) NSString *flag;
/**
 金额
 */
@property (nonatomic, copy) NSString *txAmt;
/**
 交易单号
 */
@property (nonatomic, copy) NSString *prdOrdNo;

/**
 页数
 */
@property (nonatomic, copy) NSString *pageNum;
/**
 每页显示条数
 */
@property (nonatomic, copy) NSString *numPerPag;

/**
 支付标记化token
 */
@property (nonatomic, copy) NSString *paySign;
/**
 提现订单号
 */
@property (nonatomic, copy) NSString *casordNo;
/**
 注销原因
 */
@property (nonatomic, copy) NSString *logoutReason;
/**
 预付卡卡号
 */
@property (nonatomic, copy) NSString *prepaidNo;
/**
  绑卡订单号
 */
@property (nonatomic, copy) NSString *preOrderNo;
/**
 是否存在绑定关系
 */
@property (nonatomic, copy) NSString *insFlag;

/**
 * 交易类型 提现3 退款4
 */
@property (nonatomic, assign) NSInteger orderType;
/**
 转账订单号
 */
@property (nonatomic, copy) NSString *traordNo;

/**
 * 接收方手机号
 */
@property (nonatomic, copy) NSString *toAccount;
/**
 * 接收方用户名
 */
@property (nonatomic, copy) NSString *toAccName;
/**
 * 备注
 */
@property (nonatomic, copy) NSString *remarks;

/**
 查询的交易类型
 */
@property (nonatomic, copy) NSString *tranTypeSel;
/**
 关键字
 */
@property (nonatomic, copy) NSString *keyWords;

/**
 手续费
 */
@property (nonatomic, copy) NSString *reqFee;
/**
 商户号
 */
@property (nonatomic, copy) NSString *merNo;
/**
 支付类型
 */
@property (nonatomic, copy) NSString *pType;
/**
 重新认证银行卡标识 默认值01
 */
@property (nonatomic, copy) NSString *reAuthBankCard;
/*
 * 订单号 app4期新修改
 */
@property (nonatomic, copy) NSString *orderNo;
/*
 * 订单类型 app4期新修改
 */
@property (nonatomic, copy) NSString *orderTypeSel;
/*
 * 投诉原因 app4期新
 */
@property (nonatomic, copy) NSString *comRemark;
/*
 * 投诉操作类型 app4期新 1 撤销 2 确认
 */
@property (nonatomic, copy) NSString *optType;
/*
 * 功能来源 app4期新 1 普通转账 2 收款码
 */
@property (nonatomic, copy) NSString *functionSource;
/*
 * 终端来源PC APP app4期新 电脑端PC 移动端 APP
 */
@property (nonatomic, copy) NSString *terminalSource;

@property (nonatomic, copy) NSString *userID;//用户编号 扫码转账必传

@property (nonatomic, copy) NSString *tranMark;//查询标识 扫码转账时传 1
/*
 * 结算支付标记 储蓄卡
 */
@property (nonatomic, copy) NSString *toPaySign;


@property (nonatomic, copy) NSString *backType;

@property (nonatomic, copy) NSString *backView;

@property (nonatomic, copy) NSString *beginDate;
@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *chaneel_short;
@property (nonatomic, copy) NSString *trxDtTm;
@property (nonatomic, copy) NSString *trxId;
@property (nonatomic, copy) NSString *wl_url;
@property (nonatomic, copy) NSString *smskey;


/** 公钥 */
@property (nonatomic, copy) NSString *Publickey;
/** 指纹支付原串 */
@property (nonatomic, copy) NSString *fingerText;
/** 密码方式 */
@property (nonatomic, copy) NSString *pwdType;

/** 转账  实时到账   次日到账 */
@property (nonatomic, copy) NSString *PaymentDate; // 0：实时到账 1：次日到账
//身份证号
@property (nonatomic, copy) NSString *custIdNo; 
//真实名字
@property (nonatomic, copy) NSString *custName;

/** 最大交易金额 */
@property (nonatomic, copy) NSString *maxTxAmt;

/** 最小交易金额 */
@property (nonatomic, copy) NSString *minTxAmt;


@end
