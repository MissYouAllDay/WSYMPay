//
//  YMScanPayTool.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/19.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMScanPayTool.h"

#import "YMMyHttpRequestApi.h"
#import "YMUserInfoTool.h"
#import "YMCashierDeskView.h"
#import "YMAddBankCardController.h"
#import "YMVerificationPaywordBoxView.h"
#import "ChangePayPwdViewController.h"
#import "YMPublicHUD.h"
#import "RequestModel.h"
#import "YMScanModel.h"
#import "YMResponseModel.h"
#import "YMVerifyBankCardViewController.h"
#import "YMMyHttpRequestApi.h"

#import "YMScanPaySuccessVC.h"
#import "YMScanPayFailVC.h"

#import "YMPaymentMethodView.h"
#import "YMBankCardModel.h"
#import "IDVerificationViewController.h"

@interface YMScanPayTool ()<
YMCashierDeskViewdelegate,
YMPaymentMethodViewDelegate,
YMVerificationPaywordBoxViewDelegate>
@property (nonatomic, strong) YMCashierDeskView *cashierDeskView;
@property (nonatomic, strong) YMBankCardModel   *currentBankCard;
@property (nonatomic, strong) YMVerificationPaywordBoxView *payPasswordBoxView;
@property (nonatomic, strong) YMPaymentMethodView *paymentView;
@property (nonatomic, assign) BOOL isCanPay;
@property (nonatomic, weak)   NSURLSessionTask *task;
@property (nonatomic, strong) UINavigationController *navVC;
@end

@implementation YMScanPayTool

#pragma mark - 懒加载
-(YMCashierDeskView *)cashierDeskView
{
    if (!_cashierDeskView) {
        _cashierDeskView = [[YMCashierDeskView alloc]init];
        _cashierDeskView.delegate = self;
    }
    
    return _cashierDeskView;
}
-(YMVerificationPaywordBoxView *)payPasswordBoxView
{
    if (!_payPasswordBoxView) {
        
        _payPasswordBoxView = [[YMVerificationPaywordBoxView alloc]init];
        _payPasswordBoxView.delegate = self;
    }
    
    return _payPasswordBoxView;
}
-(YMPaymentMethodView *)paymentView
{
    
    if (!_paymentView) {
        _paymentView = [[YMPaymentMethodView alloc]init];
        _paymentView.scanModel = self.dataModel;
        _paymentView.delegate = self;
    }
    return _paymentView;
}


#pragma mark - YMCashierDeskViewDelegate
-(void)cashierDeskViewSelecterBankCardButtonDidClick:(YMCashierDeskView *)deskView
{
    [self.paymentView show];
}

-(void)cashierDeskViewDeterminePaymentButtonDidClick:(YMCashierDeskView *)deskView
{
    if (!self.isCanPay) {
        [MBProgressHUD showText:@"选择支付方式"];
        return;
    }
    [deskView removeFromSuperview];
    [self.payPasswordBoxView show];
}

#pragma mark - YMPaymentMethodViewDelegate
-(void)paymentMethodViewWithAddBankCard:(YMPaymentMethodView *)view
{
    [self.cashierDeskView removeFromSuperview];
    [view removeFromSuperview];
    [self goAddBankCard];
}
-(void)goAddBankCard
{
    NSInteger status = [YMUserInfoTool shareInstance].usrStatus;
    if (status != 2) {
        if (status == -2){
            [MBProgressHUD showText:MSG19];
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusNotStart;
            [self.navVC pushViewController:ifvc animated:YES];
            
        }else if (status  == 1){
            [MBProgressHUD showText:MSG20];
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusStarting;
            [self.navVC pushViewController:ifvc animated:YES];
            
        }else if (status  == 3){
            [MBProgressHUD showText:MSG21];
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusFail;
            [self.navVC pushViewController:ifvc animated:YES];
        }
        
    }else{
        YMAddBankCardController *addBankCardVC = [[YMAddBankCardController alloc]init];
        [self.navVC pushViewController:addBankCardVC animated:YES];
    }
}
-(void)paymentMethodView:(YMPaymentMethodView *)view withBalance:(NSString *)balance
{
    self.currentBankCard = nil;
    self.cashierDeskView.bankInfo = balance;
}

-(void)paymentMethodView:(YMPaymentMethodView *)view withBankCard:(YMBankCardModel *)card
{
    self.currentBankCard = card;
    self.cashierDeskView.bankInfo = [self.currentBankCard getBankStr];
}

-(void)verificationPaywordBoxView:(YMVerificationPaywordBoxView *)boxView completeInput:(NSString *)str
{
    boxView.loading = YES;
    [self verifyPayPwd:str];
}
-(void)verificationPaywordBoxViewQuitButtonDidClick:(YMVerificationPaywordBoxView *)boxView
{
    [self.task cancel];
}

-(void)verificationPaywordBoxViewForgetButtonDidClick:(YMVerificationPaywordBoxView *)boxView
{   [boxView removeFromSuperview];
    ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
    [self.navVC pushViewController:changePayVC animated:YES];
}

#pragma mark - 其他
-(void)goVerificationBankCard
{
    YMVerifyBankCardViewController *vBankCardVC = [[YMVerifyBankCardViewController alloc]init];
    vBankCardVC.bankCardModel                   = self.currentBankCard;
    [self.navVC pushViewController:vBankCardVC animated:YES];
    
}
-(void)showCashierDeskView
{
    
    NSString *moRenStr = nil;
    
    //默认选择的支付方式0余额1银行卡2预付卡9请选择支付方式
    switch ([self.dataModel.useType integerValue]) {
        case 1:
            if (!self.currentBankCard) {
                self.currentBankCard = [self.dataModel getPayBankCardModel];
            }
            moRenStr = [self.currentBankCard getBankStr];
            break;
        default:
            moRenStr = [self.dataModel getPayType];
            break;
    }
    
    self.cashierDeskView.rechargeMoney = self.dataModel.txAmt;
    self.cashierDeskView.bankInfo      = moRenStr;
    self.cashierDeskView.mainTitle     = self.dataModel.prdName;
    if ([moRenStr isEqualToString:@"选择支付方式"]) {
        self.isCanPay = NO;
    }else{
        self.isCanPay = YES;
    }
    [self.cashierDeskView show];
}


/**
 使用银行卡校验支付密码完成充值
 */
- (void)verifyPayPwd:(NSString *)payPwd
{
    RequestModel *params = [[RequestModel alloc]init];
    params.payPwd     = payPwd;
    params.prdOrdNo   = self.dataModel.prdOrdNo;
    params.randomCode = [YMUserInfoTool shareInstance].randomCode;
    params.paySign    = self.currentBankCard.paySign;
    params.pType      = self.currentBankCard?@"1":@"0";
    params.merNo      = self.dataModel.merNo;
    WEAK_SELF;
    self.task = [YMMyHttpRequestApi loadHttpRequestWithScanToPay:params success:^(NSInteger resCode, NSString *resMsg) {
       
        switch (resCode) {
                
            case 0:
            {//网络错误
                [weakSelf.payPasswordBoxView removeFromSuperview];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [YMPublicHUD showAlertView:nil message:@"请查询订单状态之后再确定支付，以免重复支付造成损失" cancelTitle:@"确定" handler:nil]; 
                });
                break;
            }
            case 1:
            {//订单支付成功
                [weakSelf.payPasswordBoxView removeFromSuperview];
                if (self.payResultBlock) {
                    self.payResultBlock(YES, nil);
                }
                break;
            }
            case PWDERRORTIMES_CODE:
            {//密码错误，还可以输入"+N+"次"
                 [weakSelf showPwdErrorMessage:resMsg cancelTitle:@"重新输入" confirmTitle:@"忘记密码"];
                break;
            }
            case PAYPWDLOCK_CODE:
            {//支付密码已锁定！
                [weakSelf.payPasswordBoxView removeFromSuperview];
                [weakSelf showPwdLockMessage:resMsg cancelTitle:@"取消" confirmTitle:@"忘记密码"];
                break;
            }
            case 84:
            {//重新验证银行卡
                [weakSelf.payPasswordBoxView removeFromSuperview];
                [YMPublicHUD showAlertView:nil message:resMsg cancelTitle:@"取消" confirmTitle:@"确定" cancel:nil confirm:^{
                    [self goVerificationBankCard];
                }];
                break;
            }
            default:
            {//订单支付失败
                [weakSelf.payPasswordBoxView removeFromSuperview];
                
                if (self.payResultBlock) {
                    self.payResultBlock(NO, resMsg);
                }
                
                break;
            }
        }
    }];
}


//密码错误，还可以输入"+N+"次"
- (void)showPwdErrorMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle{
    WEAK_SELF;
    [YMPublicHUD showAlertView:nil message:message cancelTitle:cancelTitle confirmTitle:confirmTitle cancel:^{
        weakSelf.payPasswordBoxView.loading = NO;
    } confirm:^{
        [weakSelf.payPasswordBoxView removeFromSuperview];
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navVC pushViewController:changePayVC animated:YES];
    }];
}
//支付密码已锁定！
- (void)showPwdLockMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle{
    [YMPublicHUD showAlertView:nil message:message cancelTitle:cancelTitle confirmTitle:confirmTitle cancel:nil confirm:^{
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navVC pushViewController:changePayVC animated:YES];
    }];
}

-(void)setNavigationVC:(UINavigationController *)navVC
{
    self.navVC = navVC;
}

-(void)setDataModel:(YMScanModel *)dataModel
{
    _dataModel = dataModel;
    _paymentView.scanModel = self.dataModel;
    self.currentBankCard   = nil;
}
@end
