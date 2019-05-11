//
//  YMTransferCheckAccountDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 转账到余额 (校验校验转入方账户、转出方余额限额信息) data中 Model
 */
#import <Foundation/Foundation.h>

@interface YMTransferCheckAccountDataModel : NSObject

@property (nonatomic, copy) NSString *custName;//转入方用户名
@property (nonatomic, copy) NSString *accountMsg;//转出方限额信息
@property (nonatomic, assign) NSInteger accountStatus;//账户状态是否异常（1正常 0异常）
@property (nonatomic, assign) NSInteger isRegis;//是否是注册用户（1为注册用户）
@property (nonatomic, copy) NSString *randomCode;//随机码
@property (nonatomic, assign) NSInteger usrCateGory;//账户等级

/*下面这个不是后台返回的，本地的*/
@property (nonatomic, copy) NSString *usrMp;//本地增加的，用来记录此时的账户（手机号）


/**
 转入方用户名
 */
- (NSString *)getCustNameStr;
/**
 转出方限额信息
 */
- (NSString *)getAccountMsgStr;
/**
 账户状态是否异常（1正常 0异常）
 */
- (NSInteger)getAccountStatusNum;
/**
 是否是注册用户（1为注册用户）
 */
- (NSInteger)getIsRegisNum;
/**
 账户等级(一类账户，弹框提示/二、三类账户，进入有名钱包账户转账 转账金额界面)
 */
- (NSInteger)getUsrCateGoryNum;

/**
 随机码
 */
- (NSString *)getRandomCodeStr;

/**
 * 根据返回的信息判断需要执行什么操作
 * 1、该用户还未注册有名钱包
 * 2、账户被冻结或禁用，进行提示
 * 3、对方账户为一类账户，弹框提示
 * 4、检测到账户为二、三类账户，进入有名钱包账户转账 转账金额界面
 */
- (NSInteger)goToAction;
/**
 手机号信息（遮蔽）
 */
- (NSString *)getUsrmpStr;
/**
 手机号信息（未遮蔽）
 */
- (NSString *)getAccountStr;
@end
