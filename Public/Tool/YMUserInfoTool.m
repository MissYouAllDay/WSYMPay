//
//  YMUserInfo.m
//  WSYMPay
//
//  Created by W-Duxin on 16/10/24.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMUserInfoTool.h"
#import "NSString+AES.h"
#import <MJExtension.h>
#import "YMResponseModel.h"
#import "YMMyHttpRequestApi.h"
#import "YMBillDetailsModel.h"

//token
#define TOKEN        @"SDFSDFSDFEWEWDS"
//账户名
#define CUSTLOGIN    @"ASDASDZXCZEDSZA"
//认证状态 1未实名认证 2为已实名认证
#define USRSTATUS    @"DASDASDSZCZXAFS"
//手机号
#define USRMOBILE    @"DFGDFEWFXZCZASC"
//登录状态 YES 登录过/注销 NO
#define LOGINSTATUS  @"XSDXZCAWSDSASDD"
//支付密码设置状态
#define PAYPWDSTATUS @"ADADbHjHEKrOsBl"
//用户邮箱
#define USREMAIL     @"KKGbKHkhhbTTCkv"
//职业
#define USRJOB       @"lJKBuVBNvNVvEmW"
//地址
#define PHONEADDRESS @"PnTaziEbnTFmCkv"
//客户名称
#define CUSTNAME     @"GbJgLgJgMBKhtVB"
//证件号码
#define CUSTCREDNO   @"KJHgkFkFhTRvDhF"

#define CASHACBAL    @"KBjvhMBNvjJBvhjB"

#define ISHIDDENMONY @"HKHKJSABAsajhKBK"

#define BANKCARDLIST @"hjksadKBJKbkbbjb"

#define PREPAIDCARDLIST @"saJHhvJHGvghJGh"
//总额度
#define AMOUNTLIMIT  @"DSJKLlnlnNLJNLK"
//剩余额度
#define SURPLUSAMT   @"PMMJNBHJNBFGMWS"
//几类数字
#define CATEGORY     @"1HJHIUANNAUSNDK"
//几类文字
#define USRCATEGORY  @"hjhb7gh9gJJNJAD"
//实名认证数量
#define CERTNUM      @"88NHHJBHHkkasjd"
//账户ID
#define USERID       @"adqwdsferwgfcre"

#define YMAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.accs"]
static id _instance = nil;

@interface YMUserInfoTool ()<NSCoding>

@end

@implementation YMUserInfoTool

//声明单例方法
+ (instancetype)shareInstance
{
    return [[self alloc]init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
//把数据存储到沙盒
-(void)saveUserInfoToSanbox
{
    [NSKeyedArchiver archiveRootObject:[YMUserInfoTool shareInstance] toFile:YMAccountPath];
}

//从沙河中加载数据
-(void)loadUserInfoFromSanbox
{
    YMUserInfoTool  * userInfo = [YMUserInfoTool shareInstance];
    //网络默认是可用的
    userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:YMAccountPath];
    userInfo.networkStatus = YES;
}


//清空沙盒中数据
-(void)removeUserInfoFromSanbox
{
    _token        = nil;
    _usrMobile    = nil;
    _loginStatus  = NO;
    _usrJob       = nil;
    _usrEmail     = nil;
    _phoneAddress = nil;
    _usrStatus    = 0;
    _payPwdStatus = -2;
    _custCredNo   = nil;
    _custName     = nil;
    _cashAcBal    = nil;
    _HiddenMony   = NO;
    _bankCardArray = nil;
    _prepaidCardArray = nil;
    _amountLimit = nil;//总额度
    _surplusAMT = nil;//剩余额度
    _category = nil;//几类数字
    _usrCateGory = nil;//几类文字
    _certNum = nil;//实名认证数量
    _userID = nil;//账户ID
    //删除数据库所有表
    [self saveUserInfoToSanbox];
    [YMBillDetailsModel deletAllDBTable];
    [self refreshUserInfo];
}
/**********/

-(void)setToken:(NSString *)token
{
    _token = [token copy];
    _loginStatus = YES;

}

-(void)setResponseModel:(YMResponseModel *)responseModel
{
    _responseModel = responseModel;
    _usrMobile    = _responseModel.usrMobile;
    _usrJob       = _responseModel.usrJob;
    _usrEmail     = _responseModel.usrEmail;
    _phoneAddress = _responseModel.phoneAddress;
    _usrStatus    = _responseModel.usrStatus;
    _payPwdStatus = _responseModel.payPwdStatus;
    _custCredNo   = _responseModel.custCredNo;
    _custName     = _responseModel.custName;
    _cashAcBal    = _responseModel.cashAcBal;
    _custLogin    = _responseModel.custLogin;
    _amountLimit  = _responseModel.amountLimit;//总额度
    _surplusAMT   = _responseModel.surplusAMT;//剩余额度
    _category     = _responseModel.category;//几类数字
    _usrCateGory  = _responseModel.usrCateGory;//几类文字
    _certNum      = _responseModel.certNum;//实名认证数量
    _userID       = _responseModel.userID;//账户ID
    if (_responseModel.token.length) {
       self.token    = _responseModel.token;   
    }
}

-(NSURLSessionTask *)loadUserInfoFromServer:(void (^)())success
{
    RequestModel   *params          = [[RequestModel alloc]init];
    params.token                    = _token;
    params.tranCode                 = FINDACCOUNTNEWESTINFO;
    __weak typeof(self) weakSelf    = self;
   return [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        
        if (success) {
            success();
        }
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            weakSelf.responseModel = m;
            [weakSelf saveUserInfoToSanbox];
            [weakSelf refreshUserInfo];
        }

    } failure:^(NSError *error) {
        if (success) {
            success();
        }
    }];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.token         forKey:TOKEN];
    [aCoder encodeObject:self.custLogin     forKey:CUSTLOGIN];
    [aCoder encodeInteger:self.usrStatus    forKey:USRSTATUS];
    [aCoder encodeObject:self.usrMobile     forKey:USRMOBILE];
    [aCoder encodeInteger:self.payPwdStatus forKey:PAYPWDSTATUS];
    [aCoder encodeObject:self.usrEmail      forKey:USREMAIL];
    [aCoder encodeObject:self.usrJob        forKey:USRJOB];
    [aCoder encodeObject:self.phoneAddress  forKey:PHONEADDRESS];
    [aCoder encodeObject:self.custName      forKey:CUSTNAME];
    [aCoder encodeObject:self.custCredNo    forKey:CUSTCREDNO];
    [aCoder encodeBool:self.loginStatus     forKey:LOGINSTATUS];
    [aCoder encodeObject:self.cashAcBal     forKey:CASHACBAL];
    [aCoder encodeBool:self.HiddenMony      forKey:ISHIDDENMONY];
    [aCoder encodeObject:self.bankCardArray forKey:BANKCARDLIST];
    [aCoder encodeObject:self.prepaidCardArray forKey:PREPAIDCARDLIST];
    [aCoder encodeObject:self.amountLimit forKey:AMOUNTLIMIT];
    [aCoder encodeObject:self.surplusAMT forKey:SURPLUSAMT];
    [aCoder encodeObject:self.category forKey:CATEGORY];
    [aCoder encodeObject:self.usrCateGory forKey:USRCATEGORY];
    [aCoder encodeObject:self.certNum forKey:CERTNUM];
    [aCoder encodeObject:self.userID forKey:USERID];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _token        = [aDecoder decodeObjectForKey:TOKEN];
        _custLogin    = [aDecoder decodeObjectForKey:CUSTLOGIN];
        _usrMobile    = [aDecoder decodeObjectForKey:USRMOBILE];
        _loginStatus  = [aDecoder decodeBoolForKey:LOGINSTATUS];
        _payPwdStatus = [aDecoder decodeIntegerForKey:PAYPWDSTATUS]?:-2;
        _usrEmail     = [aDecoder decodeObjectForKey:USREMAIL];
        _usrJob       = [aDecoder decodeObjectForKey:USRJOB];
        _phoneAddress = [aDecoder decodeObjectForKey:PHONEADDRESS];
        _custName     = [aDecoder decodeObjectForKey:CUSTNAME];
        _custCredNo   = [aDecoder decodeObjectForKey:CUSTCREDNO];
        _cashAcBal    = [aDecoder decodeObjectForKey:CASHACBAL];
        _HiddenMony   = [aDecoder decodeBoolForKey:ISHIDDENMONY];
        _prepaidCardArray = [aDecoder decodeObjectForKey:PREPAIDCARDLIST];
        _bankCardArray = [aDecoder decodeObjectForKey:BANKCARDLIST];
        _amountLimit  = [aDecoder decodeObjectForKey:AMOUNTLIMIT];
        _surplusAMT   = [aDecoder decodeObjectForKey:SURPLUSAMT];
        _category     = [aDecoder decodeObjectForKey:CATEGORY];
        _usrCateGory  = [aDecoder decodeObjectForKey:USRCATEGORY];
        _certNum      = [aDecoder decodeObjectForKey:CERTNUM];
        _userID       = [aDecoder decodeObjectForKey:USERID];

        if (_loginStatus) {
            _usrStatus    = [aDecoder decodeIntegerForKey:USRSTATUS]?:-1;
        } else {
            _usrStatus    = 0;
        }
    }
    return self;
}


-(void)refreshUserInfo
{
    [WSYMNSNotification postNotificationName:WSYMRefreshUserInfoNotification object:nil];
}
/**
 可用余额
 */
- (NSString *)getCashAcBalStr
{
    NSString *str = @"0.00";
    if (!_cashAcBal.isEmptyStr) {
        str = _cashAcBal;
    }
    return str;
}

-(NSString *)getShowAccountStr
{
    if (!self.loginStatus) return @"";
    NSLog(@"%@",self.custLogin);
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",self.custLogin];
    if (string.length>=7) {
        [string replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    if (self.usrStatus == -1) {
        return [NSString stringWithFormat:@"%@(未实名)",string];
    }
    return string;
    
}

@end
