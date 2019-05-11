//
//  YMUserInfo.h
//  WSYMPay
//
//  Created by W-Duxin on 16/10/24.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMResponseModel,YMBankCardModel;

@interface YMUserInfoTool : NSObject


+ (instancetype)shareInstance;
/**
 *toekn
 */
@property (nonatomic, copy)   NSString * token;
/**
 *账户名
 */
@property (nonatomic, copy)   NSString * custLogin;
/**
 -1 未绑定过银行卡，-2未上传过身份证，'1' 是 '认证审核中'， '2' 是 '已通过认证'跳转到 ， '3' 是 '未通过认证'
 //认证状态 -1是‘未实名’，-2 是'未认证'， '1' 是 '认证审核中'， '2' 是 '已通过认证'跳转到 ， '3' 是 '未通过认证' ‘0’ 是未登录
 */
@property (nonatomic, assign) NSInteger  usrStatus;
/**
 *  支付密码状态 1已设置支付密码-1未设置支付密码
 */
@property (nonatomic, assign) NSInteger  payPwdStatus;
/**
 *  手机号 
 */
@property (nonatomic, copy)   NSString * usrMobile;
/**
 *  用户邮箱
 */
@property (nonatomic, copy)   NSString * usrEmail;
/**
 *  职业
 */
@property (nonatomic, copy)   NSString * usrJob;
/**
 *  定位地址
 */
@property (nonatomic, copy)   NSString * phoneAddress;
/**
 *  登录状态 YES 登录过/注销 NO
 */
@property (nonatomic, assign) BOOL loginStatus;
/** 客户名称 */
@property (nonatomic, copy)   NSString * custName;
/** 证件号码 */
@property (nonatomic, copy)   NSString * custCredNo;
/** 可用余额 */
@property (nonatomic, copy)   NSString * cashAcBal;
/**
 银行卡信息列表
 */
@property (nonatomic, strong) NSArray *bankCardArray;
/**
 预付卡列表
 */
@property (nonatomic, strong) NSArray *prepaidCardArray;
/**
 全局随机码
 */
@property (nonatomic, copy) NSString *randomCode;

@property (nonatomic, assign, getter=isHiddenMony) BOOL HiddenMony;
@property (nonatomic, assign) BOOL  networkStatus;
@property (nonatomic, strong) YMResponseModel *responseModel;
@property (nonatomic, copy) NSString *amountLimit;//总额度
@property (nonatomic, copy) NSString *surplusAMT;//剩余额度
@property (nonatomic, copy) NSString *category;//几类数字
@property (nonatomic, copy) NSString *usrCateGory;//几类文字
@property (nonatomic, copy) NSString *certNum;//实名认证数量
@property (nonatomic, copy) NSString *userID;
/**
 *  从服务器获取最新用户数据
 */
-(NSURLSessionTask *)loadUserInfoFromServer:(void(^)())success;
/**
 *  从沙盒获取用户数据
 */
-(void)loadUserInfoFromSanbox;
/**
 *  存储用户信息到沙盒
 */
-(void)saveUserInfoToSanbox;
/**
 *  只保留账号
 */
-(void)removeUserInfoFromSanbox;

/**
  通知各界面刷新用户数据
 */
-(void)refreshUserInfo;

/**
 可用余额
 */
- (NSString *)getCashAcBalStr;
- (NSString *)getShowAccountStr;
@end
