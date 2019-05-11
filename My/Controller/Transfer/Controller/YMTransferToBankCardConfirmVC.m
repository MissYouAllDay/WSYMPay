//
//  YMTransferToBankCardConfirmVC.m
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankCardConfirmVC.h"
#import "YMTransferToBankCardConfirmTool.h"
#import "YMVerificationPaywordBoxView.h"
#import "ChangePayPwdViewController.h"
#import "YMTransferProcessVC.h"
#import "YMTransferSuccessVC.h"
#import "YMTransferFailVC.h"
#import "YMTransferToBankSearchFeeDataModel.h"
#import "YMMyHttpRequestApi.h"
#import "YMTransferCreatOrderDataModel.h"
#import "YMTransferCheckPayPwdModel.h"
#import "YMTransferCheckPayPwdDataModel.h"
#import "YMPublicHUD.h"
#import "YMUserInfoTool.h"
@interface YMTransferToBankCardConfirmVC ()<YMTransferToBankCardConfirmToolDelegate,YMVerificationPaywordBoxViewDelegate>
@property (nonatomic, strong)YMTransferToBankCardConfirmTool *tableViewTool;
@property (nonatomic, strong) YMVerificationPaywordBoxView *payPasswordBoxView;
@property (nonatomic, copy) NSString *remarkStr;
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) YMTransferCreatOrderDataModel *creatOrderDataModel;
@end

@implementation YMTransferToBankCardConfirmVC

#pragma mark - lifeCycle                    - Method -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - privateMethods               - Method -
- (void)initViews
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.title = @"有名钱包账户转账";
    
    self.tableView.delegate = [self tableViewTool];
    self.tableView.dataSource = [self tableViewTool];
}
//生成订单
- (void)loadData
{
    RequestModel *parameters = [[RequestModel alloc] init];
    parameters.cardName = [self.searchFeeDataModel getCardNameStr];
    parameters.bankAcNo = [self.searchFeeDataModel getBankAcNoStr];
    parameters.cardType = [self.searchFeeDataModel getCardTypeStr];
    parameters.bankNo   = [self.searchFeeDataModel getBankNoStr];
    parameters.txAmt    = [self.searchFeeDataModel getTxAmtStr];
    parameters.reqFee   = [self.searchFeeDataModel getReqFeeStr];
    parameters.remarks  = self.remarkStr;
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithTransferToBankCreatOrderParameters:parameters success:^(YMTransferCreatOrderDataModel *model) {
        STRONG_SELF;
        [WSYMNSNotification postNotificationName:WSYMRefreshTransferNotification object:nil];
        strongSelf.creatOrderDataModel = model;
        //转账订单创建成功后再调取支付密码
        [strongSelf.payPasswordBoxView show];
        [strongSelf.tableView reloadData];

    }];
}

//校验支付密码
//新修改 转账到银行卡 code = 1时处理中，一个状态
- (void)loadPayPwdData:(NSString *)payPwd {
      
    RequestModel *parameters = [[RequestModel alloc] init];
    parameters.randomCode = [YMUserInfoTool shareInstance].randomCode;
    parameters.traordNo = [self.creatOrderDataModel getTraordNoStr];
    parameters.payPwd = payPwd;
    WEAK_SELF;
    self.task = [YMMyHttpRequestApi loadHttpRequestWithTransferToBankPayPwdParameters:parameters success:^(YMTransferCheckPayPwdModel *model) {
        STRONG_SELF;
        NSInteger resCode = [model getResCodeNum];
        NSString *resMsg = [model getResMsgStr];
        /*
         * 跳转到下一界面需要传递的model
         * backError --- 交易失败原因
         * traordNo --- 转账订单号
         * txAmt --   - 转账金额
         */
        YMTransferCheckPayPwdDataModel *dataModel = [model getDtatModel];
        if (resCode == 1) {//新修改。。。处理中
            [strongSelf.payPasswordBoxView removeFromSuperview];
            YMTransferProcessVC *processVC = [[YMTransferProcessVC alloc] init];
            processVC.dataModel = dataModel;
            [strongSelf.navigationController pushViewController:processVC animated:YES];
            
//            dataModel.txAmt = [self.searchFeeDataModel getTxAmtStr];
//            [strongSelf.payPasswordBoxView removeFromSuperview];
//            YMTransferSuccessVC *vc = [[YMTransferSuccessVC alloc] init];
//            vc.dataModel = dataModel;
//            [strongSelf.navigationController pushViewController:vc animated:YES];

        }else if (resCode == PWDERRORTIMES_CODE){//密码错误，还可以输入"+N+"次"
            [strongSelf showPwdErrorAlertViewTitle:nil message:resMsg cancelTitle:@"重新输入" confirmTitle:@"忘记密码"];
            
        }else if (resCode == PAYPWDLOCK_CODE){//支付密码已锁定！
            
            [strongSelf.payPasswordBoxView removeFromSuperview];
            [strongSelf showPwdLockAlertViewTitle:nil message:resMsg cancelTitle:@"取消" confirmTitle:@"忘记密码"];
            
        }else{
            [strongSelf.payPasswordBoxView removeFromSuperview];
            [strongSelf showAlertViewTitle:nil message:resMsg cancelTitle:@"确定"];
        }
 
//        else if (resCode == 131){//处理中
//            [strongSelf.payPasswordBoxView removeFromSuperview];
//            YMTransferProcessVC *processVC = [[YMTransferProcessVC alloc] init];
//            processVC.dataModel = dataModel;
//            [self.navigationController pushViewController:processVC animated:YES];
//            
//        }else {//失败----跳转到失败界面（resCode = 109）
//            [strongSelf.payPasswordBoxView removeFromSuperview];
//            YMTransferFailVC *failVC = [[YMTransferFailVC alloc] init];
//            failVC.dataModel = dataModel;
//            [strongSelf.navigationController pushViewController:failVC animated:YES];
//        }
    }];
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

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -(YMTransferToBankCardConfirmToolDelegate/YMVerificationPaywordBoxViewDelegate)
//确认支付调取收银台（输支付密码弹框）。。。
- (void)selectSureTransferBtnWithbeiZhuMsg:(NSString *)beiZhuMsg
{
    self.remarkStr = beiZhuMsg;
    [self loadData];
}

-(void)verificationPaywordBoxView:(YMVerificationPaywordBoxView *)boxView completeInput:(NSString *)str//输入密码后 调取转账到银行卡---转账发起代付接口
{
    boxView.loading = YES;
    [self loadPayPwdData:str];
}

-(void)verificationPaywordBoxViewQuitButtonDidClick:(YMVerificationPaywordBoxView *)boxView
{//中断网络请求。。。
    [self.task cancel];
}

-(void)verificationPaywordBoxViewForgetButtonDidClick:(YMVerificationPaywordBoxView *)boxView
{   [boxView removeFromSuperview];
    ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
    [self.navigationController pushViewController:changePayVC animated:YES];
}

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (YMTransferToBankCardConfirmTool *)tableViewTool
{
    if (!_tableViewTool) {
        _tableViewTool = [[YMTransferToBankCardConfirmTool alloc] initWithTableView];
        _tableViewTool.tableView = self.tableView;
        _tableViewTool.delegate = self;
    }
    return _tableViewTool;
}

-(YMVerificationPaywordBoxView *)payPasswordBoxView
{
    if (!_payPasswordBoxView) {
        _payPasswordBoxView = [[YMVerificationPaywordBoxView alloc]init];
        _payPasswordBoxView.delegate = self;
    }
    return _payPasswordBoxView;
}

- (void)setSearchFeeDataModel:(YMTransferToBankSearchFeeDataModel *)searchFeeDataModel
{
    _searchFeeDataModel = searchFeeDataModel;
    if (_searchFeeDataModel == nil) {
        return;
    }
    [self tableViewTool].dataModel = _searchFeeDataModel;
    [self.tableView reloadData];
}
@end
