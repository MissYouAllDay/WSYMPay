//
//  YMPrepaidRechargeController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/16.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMPrepaidCardRechargeController.h"
#import "YMGetUserInputCell.h"
#import "YMRedBackgroundButton.h"
#import "YMPayPrepaidCardListView.h"
#import "YMMyHttpRequestApi.h"
#import "YMUserInfoTool.h"
#import "YMCashierDeskView.h"
#import "YMPayBankCardListView.h"
#import "YMBankCardModel.h"
#import "YMAddBankCardController.h"
#import "YMVerificationPaywordBoxView.h"
#import "ChangePayPwdViewController.h"
#import "YMPublicHUD.h"
#import "YMPrepaidCardPaySuccessViewController.h"
#import "RequestModel.h"
#import "YMBankCardBaseModel.h"
#import "YMBankCardDataModel.h"
#import "YMResponseModel.h"
#import "UITextField+Extension.h"
#import "YMVerifyBankCardViewController.h"

#import "YMPayCashierView.h"
#import "IDVerificationViewController.h"

@interface YMPrepaidCardRechargeController ()
<UITextFieldDelegate,
YMPayPrepaidCardListViewDelegate,
YMCashierDeskViewdelegate,
YMPayBankCardListViewDelegate,
YMVerificationPaywordBoxViewDelegate>

@property (nonatomic, weak) UITextField *cardNOTextField;
@property (nonatomic, weak) UITextField *moneyTextField;
@property (nonatomic, weak) YMRedBackgroundButton *nextBtn;
@property (nonatomic, strong) NSMutableArray *prepaidCardArray;//预付卡array
@property (nonatomic, strong) YMPayPrepaidCardListView *prepaidCardListView;
@property (nonatomic, strong) YMCashierDeskView *cashierDeskView;
@property (nonatomic, strong) YMPayBankCardListView *payBankCardListView;
//@property (nonatomic, strong) YMBankCardModel *currentBankCard;
@property (nonatomic, strong) YMVerificationPaywordBoxView *payPasswordBoxView;
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, copy)   NSString *prdOrdNo;
@property (nonatomic, strong) YMPublicHUD *hud;
@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) YMBankCardDataModel *dataModel;
@property (nonatomic, assign) BOOL isCanPay;


@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;
@property (nonatomic, strong) YMBankCardModel *payTypeModel;//当前支付的model
@property (nonatomic, copy) NSString *moneyStr;
@property (nonatomic, copy) NSString *cardStr;

@end

@implementation YMPrepaidCardRechargeController
#pragma mark - getters and setters          - Method -
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)prepaidCardArray
{
    if (!_prepaidCardArray) {
        _prepaidCardArray = [[NSMutableArray alloc] init];
    }
    return _prepaidCardArray;
}

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
-(YMPayPrepaidCardListView *)prepaidCardListView
{
    if (!_prepaidCardListView) {
        
        YMPayPrepaidCardListView *prepaidCardListView = [[YMPayPrepaidCardListView alloc]init];
        prepaidCardListView.delegate         = self;
        _prepaidCardListView = prepaidCardListView;
        
    }
    return _prepaidCardListView;
}
-(YMPayBankCardListView *)payBankCardListView
{
    if (!_payBankCardListView) {
        
        YMPayBankCardListView *payBankCardListView = [[YMPayBankCardListView alloc]init];
        payBankCardListView.delegate = self;
        _payBankCardListView = payBankCardListView;
    }
    
    return _payBankCardListView;
    
}
#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"预付卡充值";
    self.tableView.delaysContentTouches = NO;
    
    //确定按钮
    YMRedBackgroundButton*nextBtn = [[YMRedBackgroundButton alloc]init];
    nextBtn.enabled = NO;
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    [self loadDataWithPrepaidCard];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setShouldResignOnTouchOutside:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setShouldResignOnTouchOutside:YES];
}


#pragma mark - privateMethods               - Method -

/**
 预付卡列表 httpRequest
 */
- (void)loadDataWithPrepaidCard
{
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPrepaidCardListSuccess:^(NSArray<YMPrepaidCardModel *> *prepaidCardList) {
        STRONG_SELF;
        NSMutableArray *array = [NSMutableArray arrayWithArray:prepaidCardList];
        strongSelf.prepaidCardArray = array;
        [strongSelf.tableView reloadData];
    }];
}
/**
 预付卡充值—（输入卡号跟金额请求接口）
 查询支付方式接口
 app4期新修改
 */
- (void)loadData
{
    self.moneyStr = self.moneyTextField.text.clearSpace;
    self.cardStr = self.cardNOTextField.text.clearSpace;
//    RequestModel *params = [[RequestModel alloc] init];
//    params.prepaidNo = cardStr;
//    params.txAmt = moneyStr;
//    WEAK_SELF;
//    [YMMyHttpRequestApi loadHttpRequestWithRechargePrepaidParameters:params Success:^(YMBankCardBaseModel *bankCardBaseModel) {
//        
//        STRONG_SELF;
//        YMBankCardDataModel *dataM = [bankCardBaseModel getBankCardDataModel];
//        strongSelf.dataModel = dataM;
//        strongSelf.dataArray = [dataM getBankCardListArray];
//        [weakSelf showCashierDeskViewMoney:moneyStr];
//    }];
    RequestModel *params = [[RequestModel alloc] init];
    params.txAmt = self.moneyStr;
    params.tranTypeSel = @"2";
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *baseModel) {
        STRONG_SELF;
        YMBankCardDataModel *dataM = [baseModel getBankCardDataModel];
        strongSelf.bankCardDataModel = dataM;
        [self loadPayCashierView];
    }];
}

//创建订单
- (void)loadCreatOrderData{
    [MBProgressHUD showText:@"稍后修改。。。"];
}


#pragma mark - 收银台弹框
- (void)loadPayCashierView
{
    WEAK_SELF;
    [[YMPayCashierView getPayCashierView] showPayCashierDeskViewWtihCurrentVC:self withBankCardDataModel:self.bankCardDataModel withMoney:self.moneyStr resultBlock:^(YMBankCardModel *bankCardModel, BOOL isAddCard) {
        STRONG_SELF;
        if (isAddCard) {//跳转使用其他银行卡界面
            [strongSelf goAddBankCard];
        }else{
            strongSelf.payTypeModel = bankCardModel;
            [strongSelf loadCreatOrderData];
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

//
///**
// 预付卡充值—使用银行卡校验支付密码完成充值
// */
//- (void)loadPayByBankDataPayPwd:(NSString *)payPwd boxView:(YMVerificationPaywordBoxView *)boxView
//{
//    RequestModel *params = [[RequestModel alloc]init];
//    params.payPwd     = payPwd;
//    params.prdOrdNo   = [self.dataModel getPrdOrdNoStr];
//    params.randomCode = [YMUserInfoTool shareInstance].randomCode;
//    params.paySign    = self.currentBankCard.paySign;
//    
//    WEAK_SELF;
//  self.task = [YMMyHttpRequestApi loadHttpRequestWithPrepaidCardRechargeCheckPayPWD:params success:^(NSInteger resCode, NSString *resMsg) {
//       [weakSelf verifyPayPasswordResult:resCode with:resMsg];
//    }];
//}
//
///**
// 预付卡充值—使用虚拟账户校验支付密码完成充值
// */
//- (void)loadPayByBalanceDataPayPwd:(NSString *)payPwd boxView:(YMVerificationPaywordBoxView *)boxView
//{
//    RequestModel *params = [[RequestModel alloc]init];
//    params.payPwd        = payPwd;
//    params.prdOrdNo      = [self.dataModel getPrdOrdNoStr];
//    params.randomCode    = [YMUserInfoTool shareInstance].randomCode;
//    WEAK_SELF;
//    self.task = [YMMyHttpRequestApi loadHttpRequestWithPayByBlanceParams:params success:^(YMResponseModel *model) {
//        if (model.resCode == 1) {
//            //需要返回余额更新余额
//            YMUserInfoTool *userInfo = [YMUserInfoTool shareInstance];
//            userInfo.cashAcBal = model.cashAcBal;
//            [userInfo saveUserInfoToSanbox];
//            [userInfo refreshUserInfo];
//        }
//        
//        [weakSelf verifyPayPasswordResult:model.resCode with:model.resMsg];
//    }];
//}
//处理请求结果
-(void)verifyPayPasswordResult:(NSInteger)resCode with:(NSString *)resMsg
{
    switch (resCode) {
        case 1:
        {
            [self.payPasswordBoxView removeFromSuperview];
            YMPrepaidCardPaySuccessViewController * successVC = [[YMPrepaidCardPaySuccessViewController alloc]init];
            //充值状态
            successVC.billMoney = self.moneyTextField.text;
            [self.navigationController pushViewController:successVC animated:YES];
            [self dissmissCurrentViewController:1];
            break;
        }
        case PWDERRORTIMES_CODE://密码错误，还可以输入"+N+"次"
        {
            [self showPwdErrorAlertViewTitle:nil message:resMsg cancelTitle:@"重新输入" confirmTitle:@"忘记密码"];
            break;
        }
        case PAYPWDLOCK_CODE://支付密码已锁定
        {
            [self.payPasswordBoxView removeFromSuperview];
            [self showPwdLockAlertViewTitle:nil message:resMsg cancelTitle:@"取消" confirmTitle:@"忘记密码"];
            break;
        }
        default:
        {
            [self.payPasswordBoxView removeFromSuperview];
            [self showAlertViewTitle:nil message:resMsg cancelTitle:@"确定"];
            break;
        }
    }
}

//密码错误，还可以输入"+N+"次"
- (void)showPwdErrorAlertViewTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle{
    WEAK_SELF;
    [YMPublicHUD showAlertView:title message:message cancelTitle:cancelTitle confirmTitle:confirmTitle cancel:^{
        STRONG_SELF;
        strongSelf.payPasswordBoxView.loading = NO;
    } confirm:^{
        STRONG_SELF;
        [strongSelf.payPasswordBoxView removeFromSuperview];
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
        [strongSelf.payPasswordBoxView removeFromSuperview];
    }];
}
#pragma mark - eventResponse                - Method -
//点击>按钮显示支付方式
-(void)accessoryButtonClick
{
    [self.view endEditing:YES];
    self.prepaidCardListView.prepaidCardArray = self.prepaidCardArray;
    [self.prepaidCardListView show];
}

-(void)nextBtnClick
{
    [self.view endEditing:YES];
    [self loadData];
}

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return SCREENWIDTH * ROWProportion;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERSECTION_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"cell";
    
    YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[YMGetUserInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell.userInputTF addTarget:self action:@selector(textFieldDidEditingChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    if (indexPath.section == 0) {
        cell.leftTitle   = @"卡号";
        cell.userInputTF.placeholder  = @"请输入预付卡卡号";
        cell.userInputTF.keyboardType = UIKeyboardTypeNumberPad;
        cell.userInputTF.delegate     = self;
        cell.accessoryView            = [self createAccessoryButton];
        self.cardNOTextField          = cell.userInputTF;
        
    } else {
    
        cell.leftTitle                = @"金额";
        cell.userInputTF.placeholder  = @"请输入充值金额(元)";
        cell.userInputTF.delegate     = self;
        cell.userInputTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.moneyTextField           = cell.userInputTF;
        CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
        [self setNextButtonFrame:rect];
    }
    return cell;
}

-(void)textFieldDidEditingChange:(UITextField *)textField
{

    if (self.moneyTextField.text.length
        && [self.moneyTextField.text doubleValue] > 0
        && [self.cardNOTextField.text clearSpace].length >= 16) {
        
        self.nextBtn.enabled = YES;
    } else {
        
        self.nextBtn.enabled = NO;
    }
}

-(UIButton *)createAccessoryButton
{
    if (self.prepaidCardArray.count>0) {
        UIButton *accessoryButton = [[UIButton alloc]init];
        [accessoryButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [accessoryButton addTarget:self action:@selector(accessoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [accessoryButton sizeToFit];
        return accessoryButton;
    }else{
        return nil;
    }
}

-(void)setNextButtonFrame:(CGRect)rect
{
    CGFloat w = SCREENWIDTH * 0.9;
    CGFloat h = SCREENWIDTH * ROWProportion;
    CGFloat x = (SCREENWIDTH - w) /2;
    CGFloat y = CGRectGetMaxY(rect) + (SCREENWIDTH * ROWProportion);
    self.nextBtn.frame = CGRectMake(x, y, w, h);
}

-(void)payPrepaidCardListView:(YMPayPrepaidCardListView *)list didSelectedPrepaidCard:(NSString *)card
{
    self.cardNOTextField.text = card.bankCardNumberFormat;
    if (self.moneyTextField.text.length
        && [self.moneyTextField.text doubleValue] > 0
        && [self.cardNOTextField.text clearSpace].length >= 16) {
        
        self.nextBtn.enabled = YES;
    } else {
        
        self.nextBtn.enabled = NO;
    }
}

//#pragma mark - YMCashierDeskViewDelegate
////支付详情 --- 选择支付方式
//-(void)cashierDeskViewSelecterBankCardButtonDidClick:(YMCashierDeskView *)deskView
//{
//    [deskView removeFromSuperview];
//    [self.payBankCardListView show];
//}
//
////支付详情 --- 确认支付:
//-(void)cashierDeskViewDeterminePaymentButtonDidClick:(YMCashierDeskView *)deskView
//{
//    if (!self.isCanPay) {
//        [MBProgressHUD showText:@"选择支付方式"];
//        return;
//    }
//        
//    [deskView removeFromSuperview];
//    [self.payPasswordBoxView show];
//}

//#pragma mark - YMPayBankCardListViewDelegate
//// 选择支付方式---银行卡
//-(void)payBankCardListViewCellDidSelected:(YMPayBankCardListView *)listView bankCardInfo:(YMBankCardModel *)m
//{
//    self.currentBankCard = m;
//    [self showSelectBankMoney:self.moneyTextField.text yuE:nil];
//}
////选择支付方式（点击 x 号）
//- (void)payBankCardListViewQuickButtonDidClick:(YMPayBankCardListView *)listView bankCardInfo:(YMBankCardModel *)m yuE:(NSString *)yuE
//{
//    self.currentBankCard = m;
//    [self showSelectBankMoney:self.moneyTextField.text yuE:yuE];
//}
//
//-(void)payBankCardListViewOherCellDidSelected:(YMPayBankCardListView *)listView
//{
//    YMAddBankCardController *addBankCardVC = [[YMAddBankCardController alloc]init];
//    [self.navigationController pushViewController:addBankCardVC animated:YES];
//}
////选择余额支付方式
//- (void)payBalanceViewCellDidSelected:(YMPayBankCardListView *)listView bankCardInfo:(YMBankCardModel *)m
//{
//    self.currentBankCard = m;
//    [self showSelectBankMoney:self.moneyTextField.text yuE:nil];
//}
//#pragma mark -YMVerificationPaywordBoxViewDelegate(确认支付后---输入支付密码---调用预付卡充值的接口（需要区分 银行卡支付 还是 余额支付 ）)
//-(void)verificationPaywordBoxView:(YMVerificationPaywordBoxView *)boxView completeInput:(NSString *)str
//{
//     boxView.loading = YES;
//    //银行卡  还是  余额
//    if (self.currentBankCard == nil) {//余额
//        [self loadPayByBalanceDataPayPwd:str boxView:boxView];
//    }else{//银行卡
//        [self loadPayByBankDataPayPwd:str boxView:boxView];
//    }
//}
//-(void)verificationPaywordBoxViewQuitButtonDidClick:(YMVerificationPaywordBoxView *)boxView
//{
//    [self.task cancel];
//}
//
//-(void)verificationPaywordBoxViewForgetButtonDidClick:(YMVerificationPaywordBoxView *)boxView
//{   [boxView removeFromSuperview];
//    ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
//    [self.navigationController pushViewController:changePayVC animated:YES];
//}
//
//#pragma mark - 其他
//-(void)goVerificationBankCard
//{
//    YMVerifyBankCardViewController *vBankCardVC = [[YMVerifyBankCardViewController alloc]init];
//    vBankCardVC.bankCardModel = self.currentBankCard;
//    [self.navigationController pushViewController:vBankCardVC animated:YES];
//    
//}
//-(void)showCashierDeskViewMoney:(NSString *)moneyStr;
//{
//    NSString *moRenStr = [self.dataModel getBindingBankStr];
//    self.cashierDeskView.rechargeMoney = moneyStr;
//    self.cashierDeskView.bankInfo = moRenStr;
//    self.currentBankCard = [self.dataModel getBindingBankModel];
//    
//    if ([moRenStr isEqualToString:@"选择支付方式"]) {
//        self.isCanPay = NO;
//    }else{
//        self.isCanPay = YES;
//    }
//
//    self.payBankCardListView.fromFlag = 2;//2期 预付卡充值--- 暂不支持 余额充值
//    self.payBankCardListView.bankCardDataModel = self.dataModel;
//    [self.payBankCardListView sendSelectBankModel:self.currentBankCard bankCardArray:self.dataArray];
//    //支付详情view
//    [self.cashierDeskView show];
//}
//- (void)showSelectBankMoney:(NSString *)moneyStr yuE:(NSString *)yuE;
//{
//    self.cashierDeskView.rechargeMoney = moneyStr;
//    if (yuE == nil) {
//        if (self.currentBankCard != nil) {
//            self.cashierDeskView.bankInfo = [self.currentBankCard getBankStr];
//        }else{
//            self.cashierDeskView.bankInfo = @"余额支付";
//        }
//        self.isCanPay = YES;
//    }else{
//        if ([yuE isEqualToString:@"未选余额"]) {
//            
//            if (self.currentBankCard != nil) {
//                self.cashierDeskView.bankInfo = [self.currentBankCard getBankStr];
//                self.isCanPay = YES;
//            }else{
//                self.cashierDeskView.bankInfo = @"选择支付方式";
//                self.isCanPay = NO;
//            }
//            
//        }else{
//            self.isCanPay = YES;
//        }
//    }
//    //支付详情view(选择银行卡后)
//    [self.cashierDeskView show];
//}

#pragma mark - UITextField的输入规则
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.moneyTextField == textField) {
         return [UITextField textFieldWithMoneyFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return [UITextField textFieldWithBankCardFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }
}




@end
