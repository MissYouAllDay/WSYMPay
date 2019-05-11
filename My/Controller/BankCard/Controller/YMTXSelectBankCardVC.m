//
//  YMTXSelectBankCardVC.m
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTXSelectBankCardVC.h"
#import "YMTXSelectBankCardMoneyCell.h"
#import "YMTXSelectBankCardCell.h"
#import "YMAllBillDetailFootView.h"
#import "YMSelectModel.h"
#import "YMAddBankCardController.h"
#import "YMMyHttpRequestApi.h"
#import "YMTransferCreatOrderDataModel.h"
#import "YMVerifyBankCardViewController.h"
#import "YMTransferCheckPayPwdModel.h"

//收银台相关
#import "YMPayCashierView.h"
#import "YMBankCardBaseModel.h"
#import "YMBankCardDataModel.h"
#import "YMBankCardModel.h"
#import "YMVerificationPaywordBoxView.h"
#import "ChangePayPwdViewController.h"
#import "YMPublicHUD.h"
#import "YMScanPaySuccessVC.h"
#import "YMScanPayFailVC.h"
#import "IDVerificationViewController.h"

@interface YMTXSelectBankCardVC ()<UITableViewDelegate,UITableViewDataSource,YMTXSelectBankCardMoneyCellDelegate,YMAllBillDetailFootViewDelegate,CXFunctionDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, copy) NSString *moneyStr;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) YMAllBillDetailFootView *footerView;
@property (nonatomic, strong) YMBankCardModel *debitCardModel;//到账储蓄卡model

@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;
@property (nonatomic, strong) YMBankCardModel *payTypeModel;//当前支付的model
#pragma mark - 调起收银台弹框相关
#pragma mark - 密码弹框相关
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) YMTransferCreatOrderDataModel *creatOrderDataModel;
@property (nonatomic, strong) YMVerificationPaywordBoxView *pwdBoxView;
@end

@implementation YMTXSelectBankCardVC
#pragma mark - lifeCycle                    - Method -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    self.isSelect = NO;
//    self.debitCardModel = nil;
    [self.footerView sendSelectMoney:self.moneyStr isSelect:self.isSelect];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - privateMethods               - Method -
- (void)initView
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.moneyStr = @"";
    self.footerView = [YMAllBillDetailFootView instanceView];
    self.footerView.titleStr = @"确定";
    self.footerView.delegate = self;
    self.tableView.tableFooterView = self.footerView;
}
- (void)loadData
{
    [YMMyHttpRequestApi loadHttpRequestWithCheckBankListsuccess:^(NSArray<YMBankCardModel *> *response) {
        [self.dataArray removeAllObjects];
        NSMutableArray *array = [NSMutableArray arrayWithArray:response];
        //取出储蓄卡
        for (YMBankCardModel *model in array) {
            if ([model getCardTypeCount]==1) {
                [self.dataArray addObject:model];
            }
        }
        
        self.selectArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<[self dataArray].count; i++) {
            YMSelectModel *selectModel = [[YMSelectModel alloc] init];
            selectModel.isSelect = NO;
            [self.selectArray addObject:selectModel];
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark - 检验银行卡是否可用接口
- (void)loadCheckBankCardData:(NSInteger)row
{
    RequestModel *params = [[RequestModel alloc] init];
    params.paySign = self.debitCardModel.getPaySignStr;
    params.txAmt = self.moneyStr;
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithCheckBankCardCanUse:params success:^{
        STRONG_SELF;
        //互斥选择实现（通过改变model）
        /***********/
        if ([strongSelf dataArray].count>0) {
            strongSelf.selectArray = [[NSMutableArray alloc] init];
            for (int i = 0; i<[strongSelf dataArray].count; i++) {
                YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                selectModel.isSelect = NO;
                [strongSelf.selectArray addObject:selectModel];
            }
            YMSelectModel *selectModel = strongSelf.selectArray[row];
            selectModel.isSelect = !selectModel.isSelect;
        }
        
        if (strongSelf.selectArray.count>0) {
            for (YMSelectModel *selectModel in strongSelf.selectArray) {
                if (selectModel.isSelect) {
                    strongSelf.isSelect = YES;
                }
            }
            [strongSelf.footerView sendSelectMoney:strongSelf.moneyStr isSelect:strongSelf.isSelect];
        }
        [strongSelf.tableView reloadData];
        /***********/
    } faile:^{
        STRONG_SELF;
        strongSelf.debitCardModel = nil;
        [strongSelf.tableView reloadData];
    }];
}
#pragma mark - 查询支付方式接口
- (void)loadSearchPayTypeData
{
    RequestModel *params = [[RequestModel alloc] init];
    params.txAmt = self.moneyStr;
    params.tranTypeSel = @"4";
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *baseModel) {
        STRONG_SELF;
        YMBankCardDataModel *dataM = [baseModel getBankCardDataModel];
        if (dataM.getBankCardListArray.count==0) {//没有信用卡支付，结束，返回首页
            [MBProgressHUD showText:@"没有绑定信用卡"];
            return;
        }
        strongSelf.bankCardDataModel = dataM;
        [strongSelf loadPayCashierDeskView];
        [strongSelf.tableView reloadData];
    }];
}

//创建商品订单 (需区分银行卡支付还是余额支付)
- (void)loadCreateOrderData{
    
    RequestModel *params = [[RequestModel alloc] init];
    params.toPaySign = self.debitCardModel.getPaySignStr;
    params.paySign = self.payTypeModel.getPaySignStr;
    params.txAmt = self.moneyStr;
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithTXCreatOrderParams:params success:^(YMTransferCreatOrderDataModel *model,NSString *resCode,NSString *resMsg){
        STRONG_SELF;
        if ([resCode isEqualToString:@"1"]) {
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
//校验支付密码完成支付
- (void)loadPayPwdData:(NSString *)payPwd withPayType:(int)paytype
{
    NSString *fingerText = [NSString stringWithFormat:@"{\"machineNum\":\"%@\",\"raw\":\"%@\",\"tee_n\":\"IOS\",\"tee_v\":\"%@\"}",[ObtainUserIDFVTool getIDFV],[YMUserInfoTool shareInstance].randomCode,[[UIDevice currentDevice] systemVersion]];

    RequestModel *params = [[RequestModel alloc] init];
    params.pwdType = [NSString stringWithFormat:@"%d",paytype];
    params.randomCode = [YMUserInfoTool shareInstance].randomCode;
    params.prdOrdNo = self.creatOrderDataModel.getPrdOrdNoStr;
    params.payPwd = payPwd;
    params.toPaySign = self.debitCardModel.getPaySignStr;
    params.paySign = self.payTypeModel.getPaySignStr;
    params.safetyCode = self.payTypeModel.safetyCode;
    params.token = [YMUserInfoTool shareInstance].token;
    params.fingerText = fingerText;
    params.machineNum = [ObtainUserIDFVTool getIDFV];

    WEAK_SELF;
    self.task = [YMMyHttpRequestApi loadHttpRequestWithTXCheckPwdParams:params success:^(YMTransferCheckPayPwdModel *model) {
 
        STRONG_SELF;
        NSInteger resCode = [model getResCodeNum];
        NSString *resMsg = [model getResMsgStr];
        
        switch (resCode) {
            case 1://成功之后自动发起代付
            {
                [strongSelf.pwdBoxView removeFromSuperview];
                YMScanPaySuccessVC *vc = [[YMScanPaySuccessVC alloc] init];
                vc.orderNo = strongSelf.creatOrderDataModel.getPrdOrdNoStr;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case PWDERRORTIMES_CODE://密码错误，还可以输入"+N+"次"
            {
                [strongSelf showPwdErrorAlertViewTitle:nil message:resMsg cancelTitle:@"重新输入" confirmTitle:@"忘记密码"];
            }
                break;
            case PAYPWDLOCK_CODE://支付密码已锁定！
            {
                [strongSelf.pwdBoxView removeFromSuperview];
                [strongSelf showPwdLockAlertViewTitle:nil message:resMsg cancelTitle:@"取消" confirmTitle:@"忘记密码"];
            }
                break;
            case CardInfoChange_CODE://卡片信息变更，请重新验证
            {
                [strongSelf goVerificationBankCard];
            }
                break;
            default://失败----跳转到失败界面
            {
                [strongSelf.pwdBoxView removeFromSuperview];
                YMScanPayFailVC *failVC = [[YMScanPayFailVC alloc] init];
                failVC.orderNo = strongSelf.creatOrderDataModel.getPrdOrdNoStr;
                [strongSelf.navigationController pushViewController:failVC animated:YES];
            }
                break;
        }
        
    }];
}

#pragma mark -支付收银台弹框
- (void)loadPayCashierDeskView
{
    WEAK_SELF;
    YMPayCashierView *payCashier = [YMPayCashierView getPayCashierView];
    payCashier.payCashierType = PayCashierTX;
    [payCashier showPayCashierDeskViewWtihCurrentVC:self withBankCardDataModel:self.bankCardDataModel withMoney:self.moneyStr resultBlock:^(YMBankCardModel *bankCardModel, BOOL isAddCard) {
        STRONG_SELF;
        if (isAddCard) {//跳转使用其他银行卡界面
            [strongSelf goAddBankCard];
        }else{
            strongSelf.payTypeModel = bankCardModel;
            [strongSelf loadCreateOrderData];
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
#pragma mark -支付密码弹框
- (void)loadPayPasswordBoxView
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

#pragma mark - customDelegate               - Method -
- (void)textFieldWithMoney:(NSString *)money
{
    if ((money == nil)|| [money isEmptyStr]) {
       self.moneyStr = @"";
    }
    self.moneyStr = money;
    [self.footerView sendSelectMoney:self.moneyStr isSelect:self.isSelect];
}
- (void)selectComplaintsBtnMethod
{
    YMLog(@"确定---查询支付方式接口 调起收银台");
    [self loadSearchPayTypeData];
}
#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"YMTXSelectBankCardMoneyCell";
        YMTXSelectBankCardMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YMTXSelectBankCardMoneyCell" owner:self options:nil] lastObject];
        }
        cell.moneyStr = self.moneyStr;
        cell.delegate = self;
        return cell;
    }else{
        static NSString *cellID = @"YMTXSelectBankCardCell";
        YMTXSelectBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
        if (cell == nil) {
            cell = [[YMTXSelectBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            //互斥选择实现（通过改变model）
            /***********/
            if (self.selectArray.count>0) {
                YMSelectModel *selectModel = self.selectArray[indexPath.row];
                cell.isSelected = selectModel.isSelect;
            }
            /***********/

            if (self.dataArray.count>0) {
                YMBankCardModel *model = self.dataArray[indexPath.row];
                cell.bankCardModel = model;
            }
        }else{
            cell.titleStr = @"添加银行卡";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else if (section == 1){
        return 38;
    }else{
        return 0.01f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 38)];
        headView.backgroundColor = VIEWGRAYCOLOR;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFTSPACE, 0, SCREENWIDTH-LEFTSPACE*2, 38)];
        label.textColor = FONTCOLOR;
        label.font = [UIFont systemFontOfMutableSize:13];
        label.text = @"请选择到账储蓄卡";
        [headView addSubview:label];
        return headView;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.moneyStr == nil || (!(self.moneyStr.length>0))) {
            [MBProgressHUD showText:@"请输入金额"];
            return;
        }
        if ([self dataArray].count>0) {
            //到账储蓄卡model
            self.debitCardModel = [self dataArray][indexPath.row];
            [self loadCheckBankCardData:indexPath.row];
        }
    }else if (indexPath.section == 2){
        [self goAddBankCard];
    }
}
#pragma mark - getters and setters          - Method -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
