//
//  YMTransferCheckAccountDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferCheckAccountDataModel.h"

@implementation YMTransferCheckAccountDataModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
/**
 转入方用户名
 */
- (NSString *)getCustNameStr
{
    NSString *str = @"";
    if (_custName != nil) {
        if (![_custName isEmptyStr]) {
            str = _custName;
        }
    }
    return str;
}

/**
 转出方限额信息
 */
- (NSString *)getAccountMsgStr
{
    NSString *str = @"";
    if (_accountMsg != nil) {
        if (![_accountMsg isEmptyStr]) {
            str = _accountMsg;
        }
    }
    return str;
}

/**
 账户状态是否异常（1正常 0异常）
 */
- (NSInteger)getAccountStatusNum
{
    NSInteger num;
    num = _accountStatus;
    return num;
}

/**
 是否是注册用户（1为注册用户）
 */
- (NSInteger)getIsRegisNum
{
    NSInteger num;
    num = _isRegis;
    return num;
}

/**
 账户等级(一类账户，弹框提示/二、三类账户，进入有名钱包账户转账 转账金额界面)
 */
- (NSInteger)getUsrCateGoryNum
{
    NSInteger num;
    num = _usrCateGory;
    return num;
}
/**
 随机码
 */
- (NSString *)getRandomCodeStr
{
    NSString *str = @"";
    if (_randomCode != nil) {
        if (![_randomCode isEmptyStr]) {
            str = _randomCode;
        }
    }
    return str;
}
/**
 * 根据返回的信息判断需要执行什么操作
 * 1、该用户还未注册有名钱包
 * 2、账户被冻结或禁用，进行提示
 * 3、对方账户为一类账户，弹框提示
 * 4、检测到账户为二、三类账户，进入有名钱包账户转账 转账金额界面
 */
- (NSInteger)goToAction
{
    NSInteger num;
    if ([self getIsRegisNum]==1) {//注册用户
        if ([self getAccountStatusNum]==1) {//1正常 0异常
            if ([self getUsrCateGoryNum]==1) {//一类账户
                num = 3;
            }else{
                num = 4;
            }
        }else{
            num = 2;
        }
    }else{//未注册
        num = 1;
    }
    return num;
}
/**
 手机号信息（遮蔽）
 */
- (NSString *)getUsrmpStr
{
    NSString *str = @"";
    if (_usrMp != nil) {
        if (![_usrMp isEmptyStr]) {
            NSString *accountStr = _usrMp;
            NSInteger len = [accountStr length];
            if (len>8) {
                NSRange headerRange = NSMakeRange(0, 3);
                NSString *headerStr = [accountStr substringWithRange:headerRange];
                NSRange footerRange = NSMakeRange(len-4, 4);
                NSString *footerStr = [accountStr substringWithRange:footerRange];
                accountStr = [NSString stringWithFormat:@"%@****%@",headerStr,footerStr];
                str = accountStr;
            }
        }
    }
    return str;
}

/**
 手机号信息（未遮蔽）
 */
- (NSString *)getAccountStr
{
    NSString *str = @"";
    if (_usrMp != nil) {
        if (![_usrMp isEmptyStr]) {
            str = _usrMp;
        } 
    }
    return str;
}

@end
