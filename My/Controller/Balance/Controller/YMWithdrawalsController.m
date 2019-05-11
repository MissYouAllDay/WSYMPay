//
//  YMWithdrawalsController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/15.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMWithdrawalsController.h"
#import "YMMyHttpRequestApi.h"
#import "YMBankCardModel.h"
#import "YMVerificationPaywordBoxView.h"
#import "YMPublicHUD.h"
#import "ChangePayPwdViewController.h"
#import "YMUserInfoTool.h"
#import "YMBankCardPaySuccessController.h"
#import "YMAddBankCardController.h"
#import "YMVerifyBankCardViewController.h"
#import "IDVerificationViewController.h"

@interface YMWithdrawalsController ()<CXFunctionDelegate>
@property (nonatomic, strong) YMVerificationPaywordBoxView *pwdBoxView;
@property (nonatomic, strong) NSURLSessionTask *task;
@end

@implementation YMWithdrawalsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.recharge = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)nextBtnClick
{
    [super nextBtnClick];
    
    if (self.bankCardArray.count) {
        RequestModel *params = [[RequestModel alloc]init];
        params.randomCode = [YMUserInfoTool shareInstance].randomCode;
        params.txAmt      = self.moneyTextField.text;
        params.paySign    = self.currentBankCard.paySign;
        [YMMyHttpRequestApi loadHttpRequestWithCheckWithdrawalsMoney:params success:^(NSInteger resCode, NSString *resMsg, NSString *casordNo) {
            switch (resCode) {
                case 1:
                {
                    self.currentBankCard.casordNo = casordNo;
                    [self havaFingerPay];
                    break;
                }
                case 74:
                {
                    [YMPublicHUD showAlertView:nil message:resMsg cancelTitle:@"取消" confirmTitle:@"升级账户" cancel:nil confirm:^{
                        [self goAddBankCard];
                    }];
                    break;
                }
                case 84:{
                    [YMPublicHUD showAlertView:nil message:resMsg cancelTitle:@"取消" confirmTitle:@"确定" cancel:nil confirm:^{
                        [self goVerificationBankCard];
                    }];
                    break;
                }
                default:
                {
                    [YMPublicHUD showAlertView:nil message:resMsg cancelTitle:@"确定" handler:nil];
                    break;
                }
            }
            
        }];
    }
}

- (void)havaFingerPay {
    
    CXFunctionTool *tool = [CXFunctionTool shareFunctionTool];
    tool.delegate = self;
    [tool fingerReg];
}

/** 指纹支付代理*/
- (void)functionWithFinger:(NSInteger)error {
    
    error == 0 ? [self loadPayPasswordBoxView] : [self fingerPay];
}

- (void)fingerPay {
    
    NSString *fingerText = [NSString stringWithFormat:@"{\"machineNum\":\"%@\",\"raw\":\"%@\",\"tee_n\":\"IOS\",\"tee_v\":\"%@\"}",[ObtainUserIDFVTool getIDFV],[YMUserInfoTool shareInstance].randomCode,[[UIDevice currentDevice] systemVersion]];
    [self loadCheckPwdData:[OpenSSLRSAManagers rsaSignStringwithString:fingerText] withPayType:1];
}

- (void)loadPayPasswordBoxView
{
    self.pwdBoxView = [YMVerificationPaywordBoxView getPayPwdBoxView];
    [self.pwdBoxView showPayPwdBoxViewResultSuccess:^(NSString *pwdStr) {
        self.pwdBoxView.loading = YES;
        YMLog(@"pwdStr = %@",pwdStr);
        [self loadCheckPwdData:pwdStr withPayType:0];
    } forgetPwdBtn:^{
        [self.pwdBoxView removeFromSuperview];
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navigationController pushViewController:changePayVC animated:YES];
    } quitBtn:^{
        [self.task cancel];
    }];
}

- (void)loadCheckPwdData:(NSString *)pwdStr withPayType:(int)payType
{
    NSString *fingerText = [NSString stringWithFormat:@"{\"machineNum\":\"%@\",\"raw\":\"%@\",\"tee_n\":\"IOS\",\"tee_v\":\"%@\"}",[ObtainUserIDFVTool getIDFV],[YMUserInfoTool shareInstance].randomCode,[[UIDevice currentDevice] systemVersion]];
    RequestModel *params = [[RequestModel alloc]init];
    params.pwdType = [NSString stringWithFormat:@"%d",payType];
    params.payPwd = pwdStr;
    params.randomCode = [YMUserInfoTool shareInstance].randomCode;
    params.prdOrdNo   = self.currentBankCard.prdOrdNo;
    params.paySign    = self.currentBankCard.paySign;
    params.fingerText = fingerText;
    params.machineNum = [ObtainUserIDFVTool getIDFV];
    params.casordNo   = self.currentBankCard.casordNo;
    
    self.pwdBoxView.loading = YES;
    self.task = [YMMyHttpRequestApi loadHttpRequestWithCheckWithdrawalsPWD:params success:^(NSInteger resCode, NSString *resMsg) {
        if (resCode == 1) {
            [[YMUserInfoTool shareInstance] loadUserInfoFromServer:nil];
            [self.pwdBoxView removeFromSuperview];
            YMBankCardPaySuccessController *success = [[YMBankCardPaySuccessController alloc]init];
            success.isRecharge = NO;
            success.billMoney  = self.moneyTextField.text;
            [self.navigationController pushViewController:success animated:YES];
            [self dissmissCurrentViewController:1];
        } else {
            [self showMessage:resMsg resCode:resCode];
        }
    }];
    
}

-(void)showMessage:(NSString *)message resCode:(NSInteger)code
{
    switch (code) {
        case 0:
        {//网络错误
            [self.pwdBoxView removeFromSuperview];
            break;
        }
        case PWDERRORTIMES_CODE:
        {//密码错误，还可以输入"+N+"次"
            [YMPublicHUD showAlertView:nil message:message cancelTitle:@"重新输入" confirmTitle:@"忘记密码" cancel:^{
                self.pwdBoxView.loading = NO;
            } confirm:^{
                [self goChangePayPassword];
            }];
            break;
        }
        case PAYPWDLOCK_CODE:
        {//支付密码已锁定！
            [self.pwdBoxView removeFromSuperview];
            [YMPublicHUD showAlertView:nil message:MSG15 cancelTitle:@"取消" confirmTitle:@"忘记密码" cancel:nil confirm:^{
                [self goChangePayPassword];
            }];
            break;
        }
            
        default:
        {//订单支付失败
            [self.pwdBoxView removeFromSuperview];
            [YMPublicHUD showAlertView:nil message:message cancelTitle:@"确定" handler:nil];;
            
            break;
        }
    }
    
}

-(void)goChangePayPassword
{
    [self.pwdBoxView removeFromSuperview];
    ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
    [self.navigationController pushViewController:changePayVC animated:YES];
}

-(void)goAddBankCard
{
    NSInteger status = [YMUserInfoTool shareInstance].usrStatus;
    if (status != 2) {
        if (status == -2){
            [MBProgressHUD showText:MSG19];
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusNotStart;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
            
        }else if (status  == 1){
            [MBProgressHUD showText:MSG20];
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusStarting;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
            
        }else if (status  == 3){
            [MBProgressHUD showText:MSG21];
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusFail;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
        }
        
    }else{
        YMAddBankCardController *addBankCardVC = [[YMAddBankCardController alloc]init];
        [self.navigationController pushViewController:addBankCardVC animated:YES];
    }
}
-(void)goVerificationBankCard
{
    YMVerifyBankCardViewController *vBankCardVC = [[YMVerifyBankCardViewController alloc]init];
    vBankCardVC.bankCardModel = self.currentBankCard;
    [self.navigationController pushViewController:vBankCardVC animated:YES];
}

@end
