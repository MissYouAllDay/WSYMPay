//
//  YMOrderDetailsVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMScanPayDetailsVC.h"
#import "YMGetUserInputCell.h"
#import "YMRedBackgroundButton.h"
#import "YMScanModel.h"
#import "YMMoneyView.h"
#import "YMScanPaySuccessVC.h"
#import "YMScanPayFailVC.h"
#import "YMPublicHUD.h"
#import "YMScanPayTool.h"
#import "YMMyHttpRequestApi.h"

#import "YMBankCardBaseModel.h"
#import "YMBankCardDataModel.h"
#import "YMBankCardModel.h"
#import "YMPayCashierView.h"
#import "YMVerificationPaywordBoxView.h"
#import "YMAddBankCardController.h"
#import "ChangePayPwdViewController.h"
#import "YMUserInfoTool.h"
#import "YMVerifyBankCardViewController.h"
#import "IDVerificationViewController.h"

@interface YMScanPayDetailsVC ()<CXFunctionDelegate>
@property (nonatomic, strong) YMScanPayTool *payTool;
@property (nonatomic, assign) BOOL haveNewBankCard;

@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;
@property (nonatomic, strong) YMBankCardModel *payTypeModel;//当前支付的model
#pragma mark - 调起收银台弹框相关
@property (nonatomic, copy) NSString *payMoneyStr;
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) YMVerificationPaywordBoxView *pwdBoxView;

@end

@implementation YMScanPayDetailsVC

#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单信息";
    self.haveNewBankCard      = NO;
    self.moneyView.money      = [NSString stringWithFormat:@"￥%@元",self.details.txAmt];
    self.moneyView.mainTtitle = self.details.prdName;
    [self addNotification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setShouldResignOnTouchOutside:NO];
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setShouldResignOnTouchOutside:YES];
}

#pragma mark - privateMethods               - Method -
//查询支付方式接口
- (void)loadData//消费
{
    RequestModel *params = [[RequestModel alloc] init];
    params.txAmt = self.details.txAmt;
    params.merNo = self.details.merNo;
    params.tranTypeSel = @"1";
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *baseModel) {
        STRONG_SELF;
        YMBankCardDataModel *dataM = [baseModel getBankCardDataModel];
        strongSelf.bankCardDataModel = dataM;
    }];
}
//校验支付密码
- (void)loadPayPwdData:(NSString *)payPwd withPayType:(int)paytype
{
    BOOL isBalencePay = NO;
    NSString *paySing = @"";
    NSString *safetyCodeStr = @"";
    if (self.payTypeModel == nil) {
        if ([self.bankCardDataModel getUseType]==0) {//余额
            isBalencePay = YES;
        }else if([self.bankCardDataModel getUseType] == 1){//银行卡
            paySing = [self.bankCardDataModel getDefPaySignStr];
            safetyCodeStr = [self.bankCardDataModel getCurrentPayTypeModel:self.bankCardDataModel.getDefPaySignStr].safetyCode;
        }
    }else{
        isBalencePay = self.payTypeModel.isSelectBalance;
        paySing = [self.payTypeModel getPaySignStr];
        safetyCodeStr = self.payTypeModel.safetyCode;
    }
    
    RequestModel *params = [[RequestModel alloc] init];
    params.pwdType = [NSString stringWithFormat:@"%d",paytype];
    params.prdOrdNo = self.details.prdOrdNo;
    params.payPwd = payPwd;
    params.randomCode = [YMUserInfoTool shareInstance].randomCode;
    params.merNo = self.details.merNo;
    params.safetyCode = safetyCodeStr;
    if (isBalencePay) {
        params.pType = @"0";
    }else{
        params.pType = @"1";
        params.paySign = paySing;
    }
    NSString *fingerText = [NSString stringWithFormat:@"{\"machineNum\":\"%@\",\"raw\":\"%@\",\"tee_n\":\"IOS\",\"tee_v\":\"%@\"}",[ObtainUserIDFVTool getIDFV],[YMUserInfoTool shareInstance].randomCode,[[UIDevice currentDevice] systemVersion]];
    params.fingerText = fingerText;
    params.machineNum = [ObtainUserIDFVTool getIDFV];
    
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithScanToPay:params success:^(NSInteger resCode, NSString *resMsg) {
        
        switch (resCode) {
                
            case 0:
            {//网络错误
                [weakSelf.pwdBoxView removeFromSuperview];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [YMPublicHUD showAlertView:nil message:@"请查询订单状态之后再确定支付，以免重复支付造成损失" cancelTitle:@"确定" handler:nil];
                });
                break;
            }
            case 1:
            {//订单支付成功
                [weakSelf.pwdBoxView removeFromSuperview];
                
                YMScanPaySuccessVC *successVC = [[YMScanPaySuccessVC alloc]init];
                successVC.transferMoney = weakSelf.details.txAmt;
                successVC.orderNo       = weakSelf.details.prdOrdNo;
                [weakSelf.navigationController pushViewController:successVC animated:YES];
                [weakSelf dissmissCurrentViewController:2];
                
                break;
            }
            case PWDERRORTIMES_CODE:
            {//密码错误，还可以输入"+N+"次"
                [weakSelf showPwdErrorMessage:resMsg cancelTitle:@"重新输入" confirmTitle:@"忘记密码"];
                break;
            }
            case PAYPWDLOCK_CODE:
            {//支付密码已锁定！
                [weakSelf.pwdBoxView removeFromSuperview];
                [weakSelf showPwdLockMessage:resMsg cancelTitle:@"取消" confirmTitle:@"忘记密码"];
                break;
            }
            case 84:
            {//重新验证银行卡
                [weakSelf.pwdBoxView removeFromSuperview];
                [YMPublicHUD showAlertView:nil message:resMsg cancelTitle:@"取消" confirmTitle:@"确定" cancel:nil confirm:^{
                    [self goVerificationBankCard];
                }];
                break;
            }
            default:
            {//订单支付失败
                [weakSelf.pwdBoxView removeFromSuperview];
                
                YMScanPayFailVC  *failVC = [[YMScanPayFailVC alloc]init];
                failVC.errorCode = resMsg;
                failVC.orderNo   = weakSelf.details.prdOrdNo;
                [weakSelf.navigationController pushViewController:failVC animated:YES];
                [weakSelf dissmissCurrentViewController:1];
                
                break;
            }
        }
        
    }];
    
}

- (void)loadPayCashierView
{
    WEAK_SELF;
    [[YMPayCashierView getPayCashierView] showPayCashierDeskViewWtihCurrentVC:self withBankCardDataModel:self.bankCardDataModel withMoney:self.details.txAmt resultBlock:^(YMBankCardModel *bankCardModel, BOOL isAddCard) {
        STRONG_SELF;
        if (isAddCard) {//跳转使用其他银行卡界面
            [strongSelf goAddBankCard];
        }else{
            strongSelf.payTypeModel = bankCardModel;
            [strongSelf havaFingerPay];
        }
    }];
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
    [self loadPayPwdData:[OpenSSLRSAManagers rsaSignStringwithString:fingerText] withPayType:1];
}


- (void)loadPayPasswordBoxView//支付密码弹框
{
    self.pwdBoxView = [YMVerificationPaywordBoxView getPayPwdBoxView];
    [self.pwdBoxView showPayPwdBoxViewResultSuccess:^(NSString *pwdStr) {
        self.pwdBoxView.loading = YES;
        [self loadPayPwdData:pwdStr withPayType:0];
    } forgetPwdBtn:^{
        [self.pwdBoxView removeFromSuperview];
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navigationController pushViewController:changePayVC animated:YES];
    } quitBtn:^{
        [self.task cancel];
    }];
}

//密码错误，还可以输入"+N+"次"
- (void)showPwdErrorMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle{
    WEAK_SELF;
    [YMPublicHUD showAlertView:nil message:message cancelTitle:cancelTitle confirmTitle:confirmTitle cancel:^{
        weakSelf.pwdBoxView.loading = NO;
    } confirm:^{
        [weakSelf.pwdBoxView removeFromSuperview];
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navigationController pushViewController:changePayVC animated:YES];
    }];
}
//支付密码已锁定！
- (void)showPwdLockMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle{
    [YMPublicHUD showAlertView:nil message:message cancelTitle:cancelTitle confirmTitle:confirmTitle cancel:nil confirm:^{
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navigationController pushViewController:changePayVC animated:YES];
    }];
}
-(void)goVerificationBankCard
{
    YMVerifyBankCardViewController *vBankCardVC = [[YMVerifyBankCardViewController alloc]init];
    vBankCardVC.bankCardModel = self.payTypeModel;
    [self.navigationController pushViewController:vBankCardVC animated:YES];
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
#pragma mark - eventResponse                - Method -
#pragma mark - 确认支付按钮
-(void)nextBtnClick
{
    [self loadPayCashierView];
}

#pragma mark - notification                 - Method -
-(void)addNotification
{
    [WSYMNSNotification addObserver:self selector:@selector(refreshOrderDetails) name:WSYMUserAddBankCardSuccessNotification object:nil];
}

-(void)refreshOrderDetails
{
    self.haveNewBankCard = YES;
}

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion) ;
}

-(YMGetUserInputCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"cell";
    YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YMGetUserInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.userInputTF.enabled   = NO;
        cell.userInputTF.textColor = FONTDARKCOLOR;
        cell.userInputTF.font      = COMMON_FONT;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.leftTitle = @"订单详情";
            cell.userInputTF.text = self.details.prdName;
            break;
            
        case 1:
            cell.leftTitle = @"　订单号";
            cell.userInputTF.text = self.details.prdOrdNo;
            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
            self.nextBtn.width   = SCREENWIDTH * 0.9;
            self.nextBtn.height  = rect.size.height;
            self.nextBtn.centerX = SCREENWIDTH * 0.5;
            self.nextBtn.y       = CGRectGetMaxY(rect) + rect.size.height;
            [self.nextBtn setTitle:@"确认支付" forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - getters and setters          - Method -
-(YMScanPayTool *)payTool
{
    if (!_payTool) {
        _payTool = [[YMScanPayTool alloc]init];
        _payTool.dataModel = self.details;
        [_payTool setNavigationVC:self.navigationController];
    }
    return _payTool;
}

@end
