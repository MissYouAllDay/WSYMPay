//
//  CurrencyModel.m
//  WSYMPay
//
//  Created by W-Duxin on 16/10/31.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "RequestModel.h"
#import "NSString+AES.h"
@implementation RequestModel

-(void)setCustPwd:(NSString *)custPwd
{
    _custPwd = [custPwd encryptAESWithKey:AESKEYS];
}

-(void)setCustLogin:(NSString *)custLogin
{
    _custLogin =[custLogin encryptAESWithKey:AESKEYS];
}

-(void)setX_newCustPwd:(NSString *)newCustPwd
{
    _newCustPwd = [newCustPwd encryptAESWithKey:AESKEYS];
}

-(void)setUsrMp:(NSString *)usrMp
{
    _usrMp = [usrMp encryptAESWithKey:AESKEYS];
}

-(void)setX_newPayPwd:(NSString *)newPayPwd
{

    _newPayPwd = [newPayPwd encryptAESWithKey:AESKEYS];
}

-(void)setPayPwd:(NSString *)payPwd
{
    if ([self.pwdType intValue] == 1) {
        _payPwd = payPwd;
    }else {
        _payPwd = [payPwd encryptAESWithKey:AESKEYS];
    }
}

-(void)setX_newUsrMp:(NSString *)newUsrMp
{
    _newUsrMp = [newUsrMp encryptAESWithKey:AESKEYS];
}
-(void)setBankPreMobile:(NSString *)bankPreMobile
{
    _bankPreMobile = [bankPreMobile encryptAESWithKey:AESKEYS];
}

-(void)setIdCardNum:(NSString *)idCardNum
{
    _idCardNum = [idCardNum encryptAESWithKey:AESKEYS];
}
- (void)setCardNo:(NSString *)cardNo{
    _cardNo = [cardNo encryptAESWithKey:AESKEYS];
}
-(void)setBankAcNo:(NSString *)bankAcNo
{
    _bankAcNo = [bankAcNo encryptAESWithKey:AESKEYS];
}

-(void)setSafetyCode:(NSString *)safetyCode
{
    _safetyCode = [safetyCode encryptAESWithKey:AESKEYS];
}
- (void)setTxAmt:(NSString *)txAmt
{
    _txAmt = [txAmt encryptAESWithKey:AESKEYS];
}
- (void)setPrepaidNo:(NSString *)prepaidNo
{
    _prepaidNo = [prepaidNo encryptAESWithKey:AESKEYS];
}

-(void)setPaySign:(NSString *)paySign
{
//    _paySign = paySign.encryptAES;
    _paySign = [paySign encryptAESWithKey:AESKEYS];

}
- (void)setToPaySign:(NSString *)toPaySign
{
    _toPaySign = toPaySign.encryptAES;
}
- (void)setReqFee:(NSString *)reqFee
{
    _reqFee = [reqFee encryptAESWithKey:AESKEYS];
}
- (void)setOrderNo:(NSString *)orderNo
{
    _orderNo = [orderNo encryptAESWithKey:AESKEYS];
}
- (void)setCustIdNo:(NSString *)custIdNo
{
    _custIdNo = [custIdNo encryptAESWithKey:AESKEYS];
}


@end
