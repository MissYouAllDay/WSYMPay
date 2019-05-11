//
//  YMAccountBalanceViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/7.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAccountBalanceViewController.h"
#import "YMMoneyView.h"
#import "YMRedBackgroundButton.h"
#import "YMUserOfUpgradeButton.h"
#import "YMAccountGradesView.h"
#import "YMNavigationController.h"
#import "YMAccountDescriptionViewController.h"
#import "YMUserInfoTool.h"
#import "YMExistingHighestOfAccountView.h"
#import "YMBillDetailsController.h"
#import "PromptBoxView.h"
#import "FirstRealNameCertificationViewController.h"
#import "YMUpgradeSuccessController.h"
#import "YMRechargeController.h"
#import "YMWithdrawalsController.h"
#import "YMBankCardModel.h"
#import "YMMyHttpRequestApi.h"
#import "YMAddBankCardController.h"
#import "YMBankCardBaseModel.h"
#import "YMBankCardDataModel.h"
#import "IDVerificationViewController.h"

@interface YMAccountBalanceViewController ()<YMAccountGradesViewDelegate,PromptBoxViewDelegate>

@property (nonatomic, weak) YMRedBackgroundButton*rechargeBtn;

@property (nonatomic, weak) YMRedBackgroundButton*withdrawalsBtn;

@property (nonatomic, strong)YMAccountGradesView *accountGradesView;

@property (nonatomic, strong)PromptBoxView  *promptBoxView;

@property (nonatomic, weak) YMMoneyView *moneyView;
@end

@implementation YMAccountBalanceViewController

-(PromptBoxView *)promptBoxView
{
    if (!_promptBoxView) {
        
        _promptBoxView = [[PromptBoxView alloc]init];
        _promptBoxView.title = @"您的账户未实名认证,为保证您的安全，请先实名认证";
        _promptBoxView.leftButtonTitle = @"取消";
        _promptBoxView.rightButtonTitle = @"去认证";
        _promptBoxView.delegate = self;
    }
    
    return _promptBoxView;
}

-(YMAccountGradesView *)accountGradesView
{
    
    if (!_accountGradesView) {
        _accountGradesView = [[YMAccountGradesView alloc]init];
        _accountGradesView.delegate    = self;
        _accountGradesView.frame = KEYWINDOW.bounds;
        _accountGradesView.accountType = [YMUserInfoTool shareInstance].category;
        _accountGradesView.amountLimit = [YMUserInfoTool shareInstance].amountLimit;
        _accountGradesView.surplusAMT  = [YMUserInfoTool shareInstance].surplusAMT;
    }
    
    return _accountGradesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setNavigationItem];
    [self setupNotification];
}

-(void)setupNotification
{
    [WSYMNSNotification addObserver:self selector:@selector(refreshMoney) name:WSYMRefreshUserInfoNotification object:nil];
}
-(void)refreshMoney
{
    self.moneyView.money = [YMUserInfoTool shareInstance].cashAcBal;
    _accountGradesView.accountType = [YMUserInfoTool shareInstance].category;
    _accountGradesView.amountLimit = [YMUserInfoTool shareInstance].amountLimit;
    _accountGradesView.surplusAMT  = [YMUserInfoTool shareInstance].surplusAMT;
    _withdrawalsBtn.enabled = [[YMUserInfoTool shareInstance].cashAcBal doubleValue] > 0;
}


-(void)setNavigationItem
{
    self.navigationItem.title = @"账户余额";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"收支明细" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTtemDidClick)];
    
}

-(void)setupSubviews
{
    
    self.view.backgroundColor = VIEWGRAYCOLOR;
    
    YMUserOfUpgradeButton *userOfUpgradeBtn = [[YMUserOfUpgradeButton alloc]init];
    [userOfUpgradeBtn addTarget:self action:@selector(userOfUpgradeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userOfUpgradeBtn];
    
    
    YMMoneyView *moneyView    = [[YMMoneyView alloc]init];
    moneyView.backgroundColor = [UIColor whiteColor];
    moneyView.money           = [YMUserInfoTool shareInstance].cashAcBal;
    moneyView.leftTitle       = @"可用余额(元)";
    self.moneyView            = moneyView;
    [self.view addSubview:moneyView];
    
    //注册按钮
    YMRedBackgroundButton*rechargeBtn = [[YMRedBackgroundButton alloc]init];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
    self.rechargeBtn = rechargeBtn;
    
    //ti
    YMRedBackgroundButton*withdrawalsBtn = [[YMRedBackgroundButton alloc]init];
    [withdrawalsBtn setTitle:@"提现" forState:UIControlStateNormal];
    withdrawalsBtn.enabled = [[YMUserInfoTool shareInstance].cashAcBal doubleValue] > 0;
    
    [withdrawalsBtn addTarget:self action:@selector(withdrawalsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withdrawalsBtn];
    self.withdrawalsBtn = withdrawalsBtn;
    
    
    [userOfUpgradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(LEFTSPACE * 1.5);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(SCREENHEIGHT * 0.17);
        make.top.equalTo(userOfUpgradeBtn.mas_bottom);
        make.left.mas_equalTo(0);
        
    }];
    
    [withdrawalsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
    }];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(withdrawalsBtn.mas_top).offset(-(LEFTSPACE*0.7));
        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
    }];
}
#pragma mark - 充值网络请求/提现网络请求
- (void)loadRechangeData
{
    RequestModel *params = [[RequestModel alloc] init];
    params.tranTypeSel = @"2";//后台说此处传2
    params.txAmt = @"0";
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *model) {
        STRONG_SELF;
        YMBankCardDataModel *dataModel = [model getBankCardDataModel];
        NSMutableArray *bankArray = dataModel.list;
        if (bankArray.count>0) {
            YMRechargeController *rechargeVC = [[YMRechargeController alloc]init];
            rechargeVC.bankCardDataModel = dataModel;
            [strongSelf.navigationController pushViewController:rechargeVC animated:YES];
        }else{
            [MBProgressHUD showText:@"请先绑定银行卡"];
            return;
        }
    }];
}

//提现
- (void)loadDrawalsData
{
    [YMMyHttpRequestApi loadHttpRequestWithCheckBankListsuccess:^(NSArray<YMBankCardModel *> *response) {
        if (response.count>0) {
            YMWithdrawalsController  *rechargeVC = [[YMWithdrawalsController  alloc]init];
            rechargeVC.recharge = NO;
            rechargeVC.bankCardArray = [NSMutableArray arrayWithArray:response];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }else{
            [MBProgressHUD showText:@"请先绑定银行卡"];
            return;
        }
        
    }];
}

-(void)userOfUpgradeBtnClick
{
    if ([YMUserInfoTool shareInstance].usrStatus == -1) {
        
        [self.promptBoxView show];
        return;
    }
    [KEYWINDOW addSubview:self.accountGradesView];
}

#pragma mark - YMAccountGradesViewDelegate

-(void)accountGradesViewKnowMoreButtonDidClick:(YMAccountGradesView *)aView
{
    YMAccountDescriptionViewController *accountDescriptionVC = [[YMAccountDescriptionViewController alloc]init];
    accountDescriptionVC.topView = aView;
    [self.navigationController pushViewController:accountDescriptionVC animated:YES];
}

-(void)accountGradesViewUpgradeAccountButtonDidClick:(YMAccountGradesView *)aView
{
    [aView removeFromSuperview];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    if ([currentInfo.category isEqualToString:@"1"]) {
        [self goAddBankCard];
    }
    
    if ([currentInfo.category isEqualToString:@"2"]) {
        [YMMyHttpRequestApi loadHttpRequestWithCheckAccountsuccess:^(NSInteger resCode, NSString *threeAcLogin) {
            if (resCode == 1) {
                [self goAddBankCard];
            } else {
                YMExistingHighestOfAccountView *accountView = [[YMExistingHighestOfAccountView alloc]init];
                accountView.userName = threeAcLogin;
                accountView.frame    = KEYWINDOW.bounds;
                [KEYWINDOW addSubview:accountView];
            }
        }];
    }
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
//充值
-(void)rechargeBtnClick
{
    if ([YMUserInfoTool shareInstance].usrStatus == -1) {
        [self.promptBoxView show];
        return;
    }
    [self loadRechangeData];
}

//提现
-(void)withdrawalsBtnClick
{
    if ([YMUserInfoTool shareInstance].usrStatus == -1) {
        [self.promptBoxView show];
        return;
    }
    [self loadDrawalsData];
}

-(void)rightBarButtonTtemDidClick
{
    YMBillDetailsController *billDetailsVC = [[YMBillDetailsController  alloc]init];
    [self.navigationController pushViewController:billDetailsVC animated:YES];
}

#pragma mark - PromptBoxViewDelegate
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{
    
}

-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    
    FirstRealNameCertificationViewController * firstCerVC = [[FirstRealNameCertificationViewController alloc] init];
    firstCerVC.hidesBottomBarWhenPushed                   = YES;
    [self.navigationController pushViewController:firstCerVC animated:YES];
    
}
-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}
@end
