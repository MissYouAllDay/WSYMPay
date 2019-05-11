//
//  YMResponseModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/1/22.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMResponseModel.h"
#import "NSString+AES.h"
@implementation YMResponseModel
+(instancetype)loadModelFromDic:(NSDictionary *)dic
{    
    YMResponseModel *m = [[self alloc] init];
    m.resCode          = [dic[@"resCode"] integerValue];
    m.payPwdStatus     = [dic[@"data"][@"payPwdStatus"] integerValue];
    m.cashAcBal        = dic[@"data"][@"cashAcBal"];
    m.frozBalance      = dic[@"data"][@"frozBalance"];
    m.disableBalance   = dic[@"data"][@"disableBalance"];
    m.custLogin        = dic[@"data"][@"custLogin"];
    m.usrEmail         = dic[@"data"][@"usrEmail"];
    m.usrJob           = dic[@"data"][@"usrJob"];
    m.usrMobile        = dic[@"data"][@"usrMobile"];
    m.usrStatus        = [dic[@"data"][@"usrStatus"] integerValue];
    m.phoneAddress     = dic[@"data"][@"phoneAddress"];
    m.custName         = dic[@"data"][@"custName"];
    m.custCredNo       = dic[@"data"][@"custCredNo"];
    m.token            = dic[@"data"][@"token"];
    m.resMsg           = dic[@"resMsg"];
    m.randomCode       = dic[@"data"][@"randomCode"];
    m.bankName         = dic[@"data"][@"bankName"];
    m.bankNo           = dic[@"data"][@"bankNo"];
    m.cardType         = [dic[@"data"][@"cardType"] integerValue];
    m.bankCardType     = dic[@"data"][@"bankCardType"];
    m.amountLimit      = dic[@"data"][@"amountLimit"];
    m.surplusAMT       = dic[@"data"][@"surplusAMT"];
    m.category         = dic[@"data"][@"category"];
    m.usrCateGory      = dic[@"data"][@"usrCateGory"];
    m.certNum          = dic[@"data"][@"certNum"];
    m.threeAcLogin     = dic[@"data"][@"threeAcLogin"];
    m.data = dic[@"data"];
    NSDictionary *dict = dic[@"data"];
    if ([dict.allKeys containsObject:@"userID"]) {
        m.userID = dict[@"userID"];
    }
    if ([dict.allKeys containsObject:@"preOrderNo"]) {
        m.preOrderNo = dict[@"preOrderNo"];
    }
    if ([dict.allKeys containsObject:@"insFlag"]) {
        m.insFlag = dict[@"insFlag"];
    }
    if ([dict.allKeys containsObject:@"paySign"]) {
        m.paySign = dict[@"paySign"];
    }
    if ([dict.allKeys containsObject:@"cardFlag"]) {
        m.cardFlag = dict[@"cardFlag"];
    }
    return m;
}

-(void)setCustLogin:(NSString *)custLogin
{
    if (custLogin.length == 0) {
        return;
    }
    _custLogin = [custLogin copy];
    _custLogin = [_custLogin decryptAESWithKey:AESKEYS];
}

-(void)setUsrEmail:(NSString *)usrEmail
{
    _usrEmail = [usrEmail copy];
    _usrEmail = [_usrEmail decryptAESWithKey:AESKEYS];
}

-(void)setUsrMobile:(NSString *)usrMobile
{
    _usrMobile = [usrMobile copy];
    _usrMobile = [_usrMobile decryptAESWithKey:AESKEYS];
}

-(void)setCustCredNo:(NSString *)custCredNo
{
    _custCredNo = [custCredNo copy];
    _custCredNo = [_custCredNo decryptAESWithKey:AESKEYS];
}

-(void)setAmountLimit:(NSString *)amountLimit
{
    _amountLimit = [amountLimit copy];
    
    _amountLimit = _amountLimit.decryptAES;
}
-(void)setSurplusAMT:(NSString *)surplusAMT
{
    _surplusAMT = [surplusAMT copy];
    _surplusAMT = _surplusAMT.decryptAES;
}
- (void)setUserID:(NSString *)userID
{
    _userID = [userID copy];
    _userID = _userID.decryptAES;
}

- (NSString *)getResMsg
{
    NSString *str;
    if (![_resMsg isEmptyStr]) {
        str = _resMsg;
    }
    return str;
}
- (NSInteger) getResCode
{
    NSInteger code;
    code = _resCode;
    return code;
}
- (NSInteger) getUsrStatus
{
    NSInteger status;
    status = _usrStatus;
    return status;
}
- (NSString *) getRandomCode
{
    NSString *str;
    if (![_randomCode isEmptyStr]) {
        str = _randomCode;
    }
    return str;
}
@end
