//
//  YMTransferMoneyVC.m
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferMoneyVC.h"
#import "YMTransferMoneyTool.h"
#import "YMVerificationPaywordBoxView.h"
#import "ChangePayPwdViewController.h"

#import "YMTransferProcessVC.h"
#import "YMTransferSuccessVC.h"
#import "YMTransferFailVC.h"

#import "YMTransferCheckAccountDataModel.h"
#import "YMMyHttpRequestApi.h"
#import "RequestModel.h"
#import "YMTransferCreatOrderDataModel.h"
#import "YMResponseModel.h"
#import "YMPublicHUD.h"
#import "YMTransferCheckPayPwdModel.h"
#import "YMTransferCheckPayPwdDataModel.h"
#import "YMAddBankCardController.h"
#import "YMUserInfoTool.h"

#import "YMBankCardBaseModel.h"
#import "YMBankCardDataModel.h"
#import "YMBankCardModel.h"
#import "YMPayCardListView.h"//选择支付方式列表弹框
#import "YMVerifyBankCardViewController.h"
#import "IDVerificationViewController.h"
#import "YMAllBillDetailVC.h"
#import "ObtainUserIDFVTool.h"
#import "OpenSSLRSAManagers.h"

@interface YMTransferMoneyVC ()<YMTransferMoneyToolDelegate,YMVerificationPaywordBoxViewDelegate,CXFunctionDelegate>
@property (nonatomic, strong) YMTransferMoneyTool *tableViewTool;
@property (nonatomic, strong) YMVerificationPaywordBoxView *pwdBoxView;
@property (nonatomic, copy) NSString *reMarksStr;
@property (nonatomic, strong) YMTransferCreatOrderDataModel *creatOrderDataModel;
@property (nonatomic, strong) NSURLSessionTask *task;

@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;
#pragma mark - 直接调起选择支付方式 弹框view
@property (nonatomic, strong) YMBankCardModel *payTypeModel;//当前支付的model
@property (nonatomic, strong) NSMutableArray *bankListArray;
@property (nonatomic, copy) NSString *payTypeStr;
/** 扫码支付 金额 仅仅在创建订单使用 */
@property (nonatomic, copy) NSString *payMoney;


@end

@implementation YMTransferMoneyVC

#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.payTypeModel = nil;
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - privateMethods               - Method -
- (void)initViews
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.title = @"有名钱包转账";
//    self.moneyStr = @"0";
    self.bankListArray = [[NSMutableArray alloc] init];
    self.tableView.delegate = [self tableViewTool];
    self.tableView.dataSource = [self tableViewTool];
    [self tableViewTool].vc = self;
}
- (void)loadData//开始查询支付方式
{
    RequestModel *params = [[RequestModel alloc] init];
    params.txAmt = self.moneyStr;
    self.payMoney = self.moneyStr;
    params.tranTypeSel = @"3";
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *baseModel) {
        STRONG_SELF;
        YMBankCardDataModel *dataM = [baseModel getBankCardDataModel];
        strongSelf.bankCardDataModel = dataM;
        [strongSelf tableViewTool].payTypeStr = [strongSelf.bankCardDataModel getPayBankStr];
        [strongSelf.tableView reloadData];
    }];
    [self tableViewTool].scanMoney = self.moneyStr;
}
- (void)loadChangePayTypeData//点击更换后查询支付方式
{
    RequestModel *params = [[RequestModel alloc] init];
    params.txAmt = self.moneyStr;
    params.tranTypeSel = @"3";
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *baseModel) {
        STRONG_SELF;
        YMBankCardDataModel *dataM = [baseModel getBankCardDataModel];
        strongSelf.bankCardDataModel = dataM;
        [strongSelf loadPayCashierTypeView];
        [strongSelf.tableView reloadData];
    }];
}

//创建订单 (需区分银行卡支付还是余额支付)
- (void)loadCreateOrderData
{
    RequestModel *parameters = [[RequestModel alloc] init];
    BOOL isBalencePay = NO;
    NSString *paySing = @"";
    if (self.payTypeModel == nil) {
        if ([self.bankCardDataModel getUseType]==0) {//余额
            isBalencePay = YES;
        }else if([self.bankCardDataModel getUseType] == 1){
            paySing = [self.bankCardDataModel getDefPaySignStr];
        }else if([self.bankCardDataModel getUseType] == 9){
            [MBProgressHUD showText:@"请选择支付方式"];
            return ;
        }
    }else{
        isBalencePay = self.payTypeModel.isSelectBalance;
        paySing = [self.payTypeModel getPaySignStr];
    }
    
    if (isBalencePay) {//余额
        parameters.tranCode = TRANSFERBALANCECREATORDER;
    }else{//银行卡
        parameters.tranCode = TransBankToBalanceCreatOrder;
        parameters.paySign = paySing;
    }
    
    parameters.txAmt = self.moneyStr;
    parameters.toAccount = [self.dataModel getAccountStr];
    parameters.toAccName = [self.dataModel getCustNameStr];
    parameters.remarks = self.reMarksStr;
    parameters.randomCode = [YMUserInfoTool shareInstance].randomCode;
    parameters.functionSource = self.functionSource;
    parameters.PaymentDate =self.paymentDate;
    parameters.terminalSource = @"APP";
    if ([self.functionSource integerValue] == 2) {
        parameters.txAmt = self.payMoney;
    }
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithTransferToBalanceCreatOrderParameters:parameters success:^(YMTransferCreatOrderDataModel *model,NSString *resCode,NSString *resMsg) {
        STRONG_SELF;
        if ([resCode isEqualToString:@"1"]) {
            [WSYMNSNotification postNotificationName:WSYMRefreshTransferNotification object:nil];
            strongSelf.creatOrderDataModel = model;
            //转账订单创建成功后再调取支付密码
            [strongSelf havaFingerPay];
        }else if([resCode intValue] == CardInfoChange_CODE){//卡片信息变更，请重新验证
            [YMPublicHUD showAlertView:nil message:resMsg cancelTitle:@"取消" confirmTitle:@"确定" cancel:nil confirm:^{
                [strongSelf goVerificationBankCard];
            }];
        }
        [strongSelf.tableView reloadData];
    }];
}

//校验支付密码，建立支付订单 (需区分银行卡支付还是余额支付)
- (void)loadCheckPwdData:(NSString *)payPwd withPayType:(int)payType
{
    RequestModel *parameters = [[RequestModel alloc] init];
    parameters.pwdType       = (NSString *)@(payType);
    BOOL isBalencePay = NO;
    NSString *paySing = @"";
    if (self.payTypeModel == nil) {
        if ([self.bankCardDataModel getUseType]==0) {//余额
            isBalencePay = YES;
        }else if([self.bankCardDataModel getUseType] == 1){
            paySing = [self.bankCardDataModel getDefPaySignStr];
        }
    }else{
        isBalencePay = self.payTypeModel.isSelectBalance;
        paySing = [self.payTypeModel getPaySignStr];
    }

    if (isBalencePay) {//余额
        parameters.tranCode = TRANSFERBALANCECHECKPAYPWD;
    }else{//银行卡
        parameters.tranCode = TransBankToBalanceCheckPayPwd;
        parameters.paySign = paySing;
    }
    parameters.randomCode = [YMUserInfoTool shareInstance].randomCode;
    parameters.payPwd = payPwd;
    parameters.traordNo = [self.creatOrderDataModel getTraordNoStr];
    parameters.token    = [YMUserInfoTool shareInstance].token;
    
    NSString *fingerText = [NSString stringWithFormat:@"{\"machineNum\":\"%@\",\"raw\":\"%@\",\"tee_n\":\"IOS\",\"tee_v\":\"%@\"}",[ObtainUserIDFVTool getIDFV],[YMUserInfoTool shareInstance].randomCode,[[UIDevice currentDevice] systemVersion]];
    parameters.fingerText    = fingerText;
    parameters.machineNum    = [ObtainUserIDFVTool getIDFV];

    WEAK_SELF;
    self.task = [YMMyHttpRequestApi loadHttpRequestWithTransferToBalanceCheckPayPwdParameters:parameters success:^(YMTransferCheckPayPwdModel *model) {
        STRONG_SELF;
        NSInteger resCode = [model getResCodeNum];
        NSString *resMsg = [model getResMsgStr];
        /*
         * 跳转到下一界面需要传递的model
         * backError --- 交易失败原因
         * traordNo --- 转账订单号
         * txAmt --- 转账金额
         */
        YMTransferCheckPayPwdDataModel *dataModel = [model getDtatModel];
        dataModel.txAmt = strongSelf.moneyStr;
        dataModel.cardName = strongSelf.dataModel.custName;//转入方用户名
        dataModel.bankAcMsg = strongSelf.dataModel.usrMp;//收款账号
        
        if (resCode == 1) {//成功//转账成功
            [strongSelf.pwdBoxView removeFromSuperview];
            YMTransferSuccessVC *vc = [[YMTransferSuccessVC alloc] init];
            vc.dataModel = dataModel;
            if ([self.functionSource integerValue] == 2) { vc.transferMoney = self.payMoney;  }
            [strongSelf.navigationController pushViewController:vc animated:YES];
            NSMutableArray *VCs = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
            [VCs removeObjectAtIndex:[VCs count] - 2];
            [self.navigationController  setViewControllers:VCs];
            
        }else if (resCode == PWDERRORTIMES_CODE){//密码错误，还可以输入"+N+"次"
            
            [strongSelf showPwdErrorAlertViewTitle:nil message:resMsg cancelTitle:@"重新输入" confirmTitle:@"忘记密码"];
            
        }else if (resCode == PAYPWDLOCK_CODE){//支付密码已锁定！
            
            [strongSelf.pwdBoxView removeFromSuperview];
            [strongSelf showPwdLockAlertViewTitle:nil message:resMsg cancelTitle:@"取消" confirmTitle:@"忘记密码"];
            
        }else if (resCode == TransChuLi_CODE){//处理中
            
            [strongSelf.pwdBoxView removeFromSuperview];
            YMTransferProcessVC *processVC = [[YMTransferProcessVC alloc] init];
            processVC.dataModel = dataModel;
            [strongSelf.navigationController pushViewController:processVC animated:YES];
            NSMutableArray *VCs = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
            [VCs removeObjectAtIndex:[VCs count] - 2];
            [self.navigationController  setViewControllers:VCs];
            
        }else{//失败----跳转到失败界面
            
            [strongSelf.pwdBoxView removeFromSuperview];

            [MBProgressHUD showText:resMsg];

            YMTransferFailVC *failVC = [[YMTransferFailVC alloc] init];
            failVC.dataModel = dataModel;
            [strongSelf.navigationController pushViewController:failVC animated:YES];
            NSMutableArray *VCs = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
            [VCs removeObjectAtIndex:[VCs count] - 2];
            [self.navigationController  setViewControllers:VCs];
            
        }
        
    }];
}

#pragma mark - 直接调起选择支付方式 弹框view
- (void)loadPayCashierTypeView
{
    self.bankListArray = [self.bankCardDataModel getBankCardListArray];
    WEAK_SELF;
    [[YMPayCardListView getPayCardListView] showPayTypeViewWtihCurrentVC:self withBankCardDataModel:self.bankCardDataModel bankCardArray:self.bankListArray payTypeModel:self.payTypeModel isShowBalance:YES resultBlock:^(YMBankCardModel *payTypeModel, NSString *payTypeStr) {
        STRONG_SELF;
        strongSelf.payTypeStr = payTypeStr;
        strongSelf.payTypeModel = payTypeModel;
        if (payTypeModel == nil && payTypeStr == nil) {//添加新的银行卡
            [strongSelf goAddBankCard];
        }else{
            YMLog(@"payTypeStr = %@",payTypeStr);
            [strongSelf tableViewTool].payTypeStr = payTypeStr;
        }
        [strongSelf.tableView reloadData];
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
    [self loadCheckPwdData:[OpenSSLRSAManagers rsaSignStringwithString:fingerText] withPayType:1];
}
// TODO: 获取指纹
#pragma mark -//支付密码弹框
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

//密码错误，还可以输入"+N+"次"
- (void)showPwdErrorAlertViewTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle{
    WEAK_SELF;
    [YMPublicHUD showAlertView:title message:message cancelTitle:cancelTitle confirmTitle:confirmTitle cancel:^{
        STRONG_SELF;
        strongSelf.pwdBoxView.loading = NO;
    } confirm:^{
        STRONG_SELF;
        [strongSelf.pwdBoxView removeFromSuperview];
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [strongSelf.navigationController pushViewController:changePayVC animated:YES];
    }];
}
//支付密码已锁定！
- (void)showPwdLockAlertViewTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle{
    WEAK_SELF;
    [YMPublicHUD showAlertView:title message:message cancelTitle:cancelTitle confirmTitle:confirmTitle cancel:nil confirm:^{
        STRONG_SELF;
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [strongSelf.navigationController pushViewController:changePayVC animated:YES];
    }];
}
- (void)showAlertViewTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle{
    WEAK_SELF;
    [YMPublicHUD showAlertView:title message:message cancelTitle:cancelTitle handler:^{
        STRONG_SELF;
        [strongSelf.pwdBoxView removeFromSuperview];
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

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -(YMTransferMoneyToolDelegate)
- (void)selectPayTypeBtnWithMoneyStr:(NSString *)money
{
    self.moneyStr = self.moneyStr.length== 0 ? money : self.moneyStr;
    if (money == nil) {
        self.moneyStr = @"0";
    }
    [self loadChangePayTypeData];
}

- (void)selectSureTransferBtnWithMoney:(NSString *)money beiZhuMsg:(NSString *)beiZhuMsg
{//确认支付按钮 创建订单，订单生成之后弹出输密码弹框。。。
    YMLog(@"money = %@,\n beiZhuMsg = %@",money,beiZhuMsg);
    self.moneyStr = self.moneyStr.length==0?money:self.moneyStr;
    self.reMarksStr = beiZhuMsg;
    [self loadCreateOrderData];
}

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (YMTransferMoneyTool *)tableViewTool
{
    if (!_tableViewTool) {
        _tableViewTool = [[YMTransferMoneyTool alloc] initWithTableView];
        _tableViewTool.tableView = self.tableView;
        _tableViewTool.delegate = self;
    }
    return _tableViewTool;
}

- (void)setDataModel:(YMTransferCheckAccountDataModel *)dataModel
{
    _dataModel = dataModel;
    if (_dataModel == nil) {
        return;
    }
    [self tableViewTool].dataModel = _dataModel;
    [self.tableView reloadData];
}
- (void)setFunctionSource:(NSString *)functionSource
{
    _functionSource = functionSource;
}
-(void)setPaymentDate:(NSString *)paymentDate
{
    _paymentDate = paymentDate;
}

@end
