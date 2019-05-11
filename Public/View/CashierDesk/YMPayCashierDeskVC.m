//
//  YMPayCashierDeskVC.m
//  WSYMPay
//
//  Created by pzj on 2017/7/18.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPayCashierDeskVC.h"
#import "YMMyHttpRequestApi.h"
#import "RequestModel.h"

#import "YMBankCardBaseModel.h"
#import "YMBankCardDataModel.h"
#import "YMBankCardModel.h"
#import "YMPayCashierView.h"

#import "YMVerificationPaywordBoxView.h"
#import "YMAddBankCardController.h"
#import "ChangePayPwdViewController.h"
#import "YMPayCardListView.h"
#import "IDVerificationViewController.h"

@interface YMPayCashierDeskVC ()<YMVerificationPaywordBoxViewDelegate,CXFunctionDelegate>

@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;
@property (nonatomic, strong) YMBankCardModel *payTypeModel;//当前支付的model

#pragma mark - 调起收银台弹框相关
@property (nonatomic, copy) NSString *payMoneyStr;


#pragma mark - 直接调起选择支付方式 弹框view
@property (nonatomic, strong) NSMutableArray *bankListArray;
@property (nonatomic, copy) NSString *payTypeStr;

#pragma mark - 密码弹框相关
@property (nonatomic, strong) NSURLSessionTask *task;

@property (nonatomic, assign) BOOL isSelectCreditCard;

@end

@implementation YMPayCashierDeskVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isSelectCreditCard) {
        [self loadPayCashierView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
}
- (void)initView
{
    self.isSelectCreditCard = NO;
    self.view.backgroundColor = VIEWGRAYCOLOR;
    NSArray *arr = @[@"收银台弹框",@"弹付款方式弹框"];
    for (int i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30, 100+i*60, 200, 50);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:FONTCOLOR forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        [self.view addSubview:btn];
    }
}
- (void)loadData
{
    self.payMoneyStr = @"98.00";
//    RequestModel *params = [[RequestModel alloc] init];
//    params.txAmt = self.payMoneyStr;
//    params.tranTypeSel = @"2";
//    WEAK_SELF;
//    [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *baseModel) {
//        STRONG_SELF;
//        YMBankCardDataModel *dataM = [baseModel getBankCardDataModel];
//        strongSelf.bankCardDataModel = dataM;
//    }];
    
    NSDictionary *dict = @{
                           @"data":@{
                                   @"useType":@"1",
                                   @"acbalUse":@"1",
                                   @"list":@[
                                           @{
                                               @"isFlag":@"0",
                                               @"logoPic":@"",
                                               @"bankName":@"中国建设银行",
                                               @"bankAcNo":@"6999",
                                               @"cardType":@"01",
                                               @"bankCardType":@"储蓄卡",
                                               @"paySign":@"Fd8gzOR05v7GmuSPGyXAMsnzsWdozrbqGSbNx99skGkXy18b3C/OlrfI+RPnoPRO"
                                               },
                                           @{
                                               @"isFlag":@"0",
                                               @"defaultCard":@"1",
                                               @"logoPic":@"",
                                               @"bankName":@"中国建设银行",
                                               @"bankAcNo":@"9958",
                                               @"cardType":@"01",
                                               @"bankCardType":@"储蓄卡",
                                               @"paySign":@"111111"
                                               },
                                           @{
                                               @"isFlag":@"0",
                                               @"logoPic":@"",
                                               @"bankName":@"中国农业银行",
                                               @"bankAcNo":@"0018",
                                               @"cardType":@"01",
                                               @"bankCardType":@"储蓄卡",
                                               @"paySign":@"111111"
                                               },
                                           @{
                                               @"isFlag":@"0",
                                               @"bankName":@"网上有名",
                                               @"bankAcNo":@"0259",
                                               @"cardType":@"03",
                                               @"bankCardType":@"预付卡",
                                               @"paySign":@"1000016662000259"
                                               },
                                           @{
                                               @"isFlag":@"0",
                                               @"bankName":@"网上有名",
                                               @"bankAcNo":@"0100",
                                               @"cardType":@"03",
                                               @"bankCardType":@"预付卡",
                                               @"paySign":@"1000021234180100"
                                               },


                                           ],
                                   @"useTypeValue":@"中国建设银行(9958)",
                                   @"defPaySign":@"4933000000384170515170127000005574"
                                   },
                           @"resCode":@"1",
                           @"resMag":@"查询成功"
                           };
    YMBankCardBaseModel *baseModel = [YMBankCardBaseModel mj_objectWithKeyValues:dict];
    YMBankCardDataModel *dataM = [baseModel getBankCardDataModel];
    self.bankCardDataModel = dataM;
    
}
- (void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            YMLog(@"1");
            [self loadPayCashierView];
        }
            break;
        case 101:
        {
            YMLog(@"2");
            [self loadPayCashierTypeView];
        }
            break;

        default:
            break;
    }
}
//- (void)dealloc
//{
//    [WSYMNSNotification removeObserver:self name:WSYMBankCardVerifyNotification object:nil];
//}
//- (void)loadNotification
//{
//    [WSYMNSNotification addObserver:self selector:@selector(refreshPayCashier:) name:WSYMBankCardVerifyNotification object:nil];
//}
//- (void)refreshPayCashier:(NSNotification *)note
//{
//    self.payTypeModel = note.object;
//    self.isSelectCreditCard = YES;
//}
#pragma mark - 调起收银台 弹框view
- (void)loadPayCashierView
{
    WEAK_SELF;
    YMPayCashierView *payCashierView = [YMPayCashierView getPayCashierView];
//    payCashierView.payTypeModel = self.payTypeModel;
    [payCashierView showPayCashierDeskViewWtihCurrentVC:self withBankCardDataModel:self.bankCardDataModel withMoney:self.payMoneyStr resultBlock:^(YMBankCardModel *bankCardModel, BOOL isAddCard) {
        STRONG_SELF;
        if (isAddCard) {//跳转使用其他银行卡界面
            [strongSelf goAddBankCard];
        }else{
            strongSelf.payTypeModel = bankCardModel;
            [strongSelf loadPayPasswordBoxView];
        }
    }];
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
#pragma mark - 直接调起选择支付方式 弹框view
- (void)loadPayCashierTypeView
{
    self.bankListArray = [self.bankCardDataModel getBankCardListArray];
    WEAK_SELF;
    [[YMPayCardListView getPayCardListView] showPayTypeViewWtihCurrentVC:self  withBankCardDataModel:self.bankCardDataModel bankCardArray:self.bankListArray payTypeModel:self.payTypeModel isShowBalance:YES resultBlock:^(YMBankCardModel *payTypeModel, NSString *payTypeStr) {
        STRONG_SELF;
        strongSelf.payTypeStr = payTypeStr;//选中的支付方式名称
        strongSelf.payTypeModel = payTypeModel;//选中支付方式对应的model
        YMLog(@"选择的支付方式 = %@\n 选择的支付方式model%@",payTypeStr,payTypeModel.mj_keyValues);
        if (payTypeModel == nil && payTypeStr == nil) {//使用其他银行卡---跳转新界面
            [strongSelf goAddBankCard];
        }else{
            [strongSelf loadPayPasswordBoxView];
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
#pragma mark -//支付密码弹框
- (void)loadPayPasswordBoxView
{
    YMVerificationPaywordBoxView *pwdBoxView = [YMVerificationPaywordBoxView getPayPwdBoxView];
    [pwdBoxView showPayPwdBoxViewResultSuccess:^(NSString *pwdStr) {
        pwdBoxView.loading = YES;
        YMLog(@"pwdStr = %@",pwdStr);
        [self loadPayPwdData:pwdStr withPayType:0];
    } forgetPwdBtn:^{
        [pwdBoxView removeFromSuperview];
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navigationController pushViewController:changePayVC animated:YES];
    } quitBtn:^{
        [self.task cancel];
    }];
}
//网络请求，需区分银行卡支付还是余额支付
- (void)loadPayPwdData:(NSString *)payPwd withPayType:(int)payType
{
    BOOL isBalencePay = self.payTypeModel.isSelectBalance;
    if (isBalencePay) {//余额
        YMLog(@"余额支付");
    }else{//银行卡
        YMLog(@"银行卡支付");
    }
}

- (NSMutableArray *)bankListArray
{
    if (!_bankListArray) {
        _bankListArray = [[NSMutableArray alloc] init];
    }
    return _bankListArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
