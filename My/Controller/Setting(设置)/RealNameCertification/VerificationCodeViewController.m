//
//  VerificationCodeViewController.m
//  WSYMPay
//
//  Created by MaKuiying on 16/9/23.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "VerificationCodeViewController.h"
#import "RealNameCertificationSucessViewController.h"
#import "FristSettingPayPasswordViewController.h"
#import "VerificationView.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
#import "YMBankCardModel.h"
#import "LKDBHelper.h"
#import "YMVerifyBankCardDataModel.h"

@interface VerificationCodeViewController ()
<FristSettingPayPasswordViewControllerDelegate,
VerificationViewDelegate>

@property (nonatomic, strong) LKDBHelper *listDB;
@property (nonatomic, strong) YMResponseModel *model;
@end

@implementation VerificationCodeViewController{

    UIButton         * submitBtn;
    VerificationView *_verificationView;
    BOOL              _isFirstLoad;
    
}

/**
 *  进入视图判断是否设置支付密码（1.2），未设置强制弹出设置框  如果已经设置了 直接发送验证码
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.title = @"添加银行卡";
    [self initViews];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self initDB];
    });
    // 判断是否设置支付密码
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([YMUserInfoTool shareInstance].payPwdStatus == 1) {
        //60秒内不得重复验证码
        if (self.resCode == 1) {
            
            [_verificationView createTimer];
        }
        
    }else{

        [self payPwdInitViews];//强制设置弹框
    }
    
}

//支付密码框
- (void)payPwdInitViews{
    FristSettingPayPasswordViewController* fristVC = [[FristSettingPayPasswordViewController alloc]init];
    fristVC.delegate =  self;
    [fristVC show];
}

- (void)initViews {
    
    UIView * allViews           = [UIView new];
    allViews.layer.borderWidth  = 1.0;
    allViews.layer.borderColor  = LAYERCOLOR.CGColor;
    allViews.layer.cornerRadius = 0;
    allViews.backgroundColor    = [UIColor whiteColor];
    [self.view addSubview:allViews];
    [allViews mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(LEFTSPACE);
        make.height.equalTo(allViews.mas_width).multipliedBy(0.145);
        
    }];
  
    VerificationView *verificationView    = [[VerificationView alloc]init];
    verificationView.delegate             = self;
    verificationView.countdownButtonTitle = @"发送验证码";
    [allViews addSubview:verificationView];
    _verificationView                  = verificationView;
    
    [verificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-LEFTSPACE);
        make.top.offset(1);
        make.bottom.offset(-1);
    }];
    
    
    submitBtn = [UIButton new];
    [submitBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"register"] forState:UIControlStateDisabled];
    [submitBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
    submitBtn.enabled = NO;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    submitBtn.titleLabel.font = [UIFont systemFontOfMutableSize:14];
    submitBtn.layer.cornerRadius = CORNERRADIUS;
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(verificationView.mas_bottom).offset(20);
        make.height.equalTo(submitBtn.mas_width).multipliedBy(0.144);
    }];

    
    
}

//提交按钮
- (void)submitAction{
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"正在实名..."];
    
    NSString* bankPreMobil = [self.bankPreMobil stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *bankAcNo     = [self.bankCardInfo.bankAcNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = currentInfo.token;
    params.validateCode  = _verificationView.verificationCode;
    params.bankName      = self.bankCardInfo.bankName;
    NSString *cardType   = [NSString stringWithFormat:@"%ld",(long)self.bankCardInfo.cardType];
    params.cardType      = cardType;
//    params.cardName      = self.cardName;
//    params.idCardNum     = self.idCardNum;
    params.cardDeadline  = self.cardDeadline;
    params.bankPreMobile = bankPreMobil;
    params.bankNo        = self.bankCardInfo.bankNo;
    params.bankAcNo      = bankAcNo;
    params.safetyCode    = self.safetyCode;
    params.tranCode      = VERIFICATIONATTACHTOBANK;
    params.chaneel_short = self.chaneel_short;
    params.trxId         =self.trxId;
    params.trxDtTm       =self.trxDtTm;
    params.smskey        = self.smskey;
    params.wl_url        =  self.wl_url;
 

    __weak typeof(self)  weakSelf = self;
    
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            
            /* 
             * app4期新修改
             * change by pzj 2017-8-2
             * 绑定信用卡的时候会返回信用卡对应的paySign,此时需要根据paySign将安全码存入本地数据库
             */
            self.model = m;
            if ([m.cardFlag isEqualToString:@"02"]) {
                [self saveDB];
            }
            
            [MBProgressHUD showText:m.resMsg];
            NSLog(@"weakSelf.idCardNum------..////----%@",weakSelf.idCardNum);
            NSLog(@"weakSelf.cardName-------..////----%@",weakSelf.cardName);

//            currentInfo.custCredNo = [weakSelf setSecurityText:weakSelf.idCardNum];
//            currentInfo.custName   = [weakSelf setSecurityText:weakSelf.cardName];
            currentInfo.usrStatus  = -2;
            [currentInfo saveUserInfoToSanbox];
            [currentInfo refreshUserInfo];
            RealNameCertificationSucessViewController * sucessVC = [[RealNameCertificationSucessViewController alloc] init];
            [self.navigationController pushViewController:sucessVC animated:YES];
            [self dissmissCurrentViewController:4];
        } else {
            
            [MBProgressHUD showText:m.resMsg];
            
        }

    } failure:^(NSError *error) {}];
    
}

#pragma mark -VerificationViewDelegate

-(void)verificationViewTextDidEditingChange:(NSString *)text
{
    if (text.length == 6) {
        
        submitBtn.enabled = YES;
    } else {
        
        submitBtn.enabled = NO;
    }

}

-(void)verificationViewCountdownButtonDidClick:(VerificationView *)verificationView
{
    //设置支付密码后直接倒计时-调用获取验证码接口
    [self getbankVerifyCodeURL];
}


#pragma mark - FristSettingPayPasswordViewControllerDelegate
-(void)fristSettingPayPasswordViewControllerSettingPayPasswordSuccess:(FristSettingPayPasswordViewController*)vc password:(NSString *)pwd{
    YMLog(@"Success");
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = currentInfo.token;
    params.payPwd        = pwd;
    params.newPayPwd     = pwd;
    params.tranCode      = SETPAYPWD;
    [MBProgressHUD show];
    
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            
            [self getbankVerifyCodeURL];
            currentInfo.payPwdStatus = 1;
            [currentInfo saveUserInfoToSanbox];
            [currentInfo refreshUserInfo];
            
        } else {
            
            [MBProgressHUD showText:m.resMsg];
            
        }
    } failure:^(NSError *error) {}];
    
    
}

-(void)fristSettingPayPasswordViewControllerSettingPayPasswordFail:(FristSettingPayPasswordViewController*)vc{
    YMLog(@"Fail");
    
}


//请求验证码接口
-(void)getbankVerifyCodeURL{
    [self.view endEditing:YES];
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = [YMUserInfoTool shareInstance].token;
    params.bankPreMobile = [self.bankPreMobil stringByReplacingOccurrencesOfString:@" " withString:@""];
//    params.cardName      = self.cardName;
//    params.idCardNum     = self.idCardNum;
    params.tranCode      = JUDEMENTSETPAYPWD;
    params.bankAcNo      =
    [MBProgressHUD showMessage:@"正在发送验证码"];
    
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (m.resCode == 1 || m.resCode == 36 || m.resCode == 48) {
            
            if (m.resCode == 48) {
                [YMUserInfoTool shareInstance].payPwdStatus = -1;
                [self payPwdInitViews];
            } else {
              [_verificationView createTimer];
              [MBProgressHUD showText:m.resMsg];
            }
            
        } else {
            
            [MBProgressHUD showText:m.resMsg];
        }

        
    } failure:^(NSError *error) {}];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];

}

//将文字转换成密文
-(NSString *)setSecurityText:(NSString *)str
{
    if (str.length < 5) {
        
        if (str.length == 1) return str;
        
        NSString * str1 = [str substringFromIndex:1];
        str1 = [@"*" stringByAppendingString:str1];
        return str1;
        
    } else {
        
        NSString *str1 = [str substringToIndex:4];
        NSString *str2 = [str substringFromIndex:16];
        return [[str1 stringByAppendingString:@"************"]stringByAppendingString:str2];
    }
}
-(void)setCardName:(NSString *)cardName{
    _cardName =  cardName;
}

#pragma mark - 数据库相关
- (void)initDB
{
    self.listDB = [YMVerifyBankCardDataModel getUsingLKDBHelper];
    YMLog(@"create table sql :\n%@\n",[YMVerifyBankCardDataModel getCreateTableSQL]);
}
//存入数据库
- (void)saveDB
{
    //清空表数据
    [LKDBHelper clearTableData:[YMVerifyBankCardDataModel class]];
    YMVerifyBankCardDataModel *m = [[YMVerifyBankCardDataModel alloc] init];
    m.paySingKey = self.model.paySign;
    m.safetyCode = self.safetyCode;
    [m saveToDB];
}
@end
