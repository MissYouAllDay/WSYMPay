//
//  YMAllBillDetailVC.m
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillDetailVC.h"
#import "YMAllBillDetailTool.h"
#import "YMAllBillComplaintVC.h"
#import "YMAllBillComplaintVC.h"
#import "YMAllBillListDataListModel.h"
#import "YMMyHttpRequestApi.h"
#import "RequestModel.h"
#import "YMAllBillDetailDataModel.h"
#import "YMBankCardDataModel.h"
#import "YMBankCardBaseModel.h"
#import "YMBankCardModel.h"
#import "ChangePayPwdViewController.h"

#import "YMPayCashierView.h"
#import "YMVerificationPaywordBoxView.h"

@interface YMAllBillDetailVC ()<YMAllBillDetailToolDelegate,CXFunctionDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YMAllBillDetailTool *tableViewTool;
@property (nonatomic, strong) YMAllBillDetailDataModel *detailDataModel;
@property (nonatomic, copy) NSString *orderNoStr;
@property (nonatomic, copy) NSString *tranTypeStr;
@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;
@property (nonatomic, strong) YMBankCardModel *payTypeModel;
@property (nonatomic, strong) YMVerificationPaywordBoxView *pwdBoxView;
@property (nonatomic, strong) NSURLSessionTask *task;
@end

@implementation YMAllBillDetailVC
#pragma mark - lifeCycle                    - Method -
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - privateMethods               - Method -
- (void)initView{
    self.title = @"交易详情";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.hidden = YES;
}
- (void)loadData
{
    RequestModel *params = [[RequestModel alloc] init];
    params.orderNo = self.orderNoStr;
    params.orderTypeSel = self.tranTypeStr;
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithBillDetailsParams:params success:^(YMAllBillDetailDataModel *detailDataModel) {
        STRONG_SELF;
        strongSelf.tableView.hidden = NO;
       
        strongSelf.detailDataModel = detailDataModel;
        strongSelf.tableViewTool.tranType = self.tranTypeStr;
        [strongSelf tableViewTool].billDetailType = self.billDetailType;
        [strongSelf tableViewTool].detailDataModel = strongSelf.detailDataModel;
        [strongSelf.tableView reloadData];
        
        if (self.hiddenFooterView) {
            
            strongSelf.tableView.tableFooterView = [UIView new];
            
        }
    }];
}
//optType1 撤销 2 确认
- (void)loadRevokeOrConfirmData:(NSString *)optType
{
    if ([optType isEqualToString:@"3"]) {
        RequestModel *params = [[RequestModel alloc] init];
//        params.prdOrdNo = self.orderNoStr;
        params.orderNo = self.orderNoStr;
//        params.optType = @"1";
        WEAK_SELF;
        [YMMyHttpRequestApi loadHttpRequestWithRevokeOrConfirmParamsONE:params success:^(NSString *acceptState) {
            STRONG_SELF;
//            strongSelf.detailDataModel.acceptState = acceptState;
//            [strongSelf tableViewTool].billDetailType = self.billDetailType;
//            [strongSelf tableViewTool].detailDataModel = strongSelf.detailDataModel;
            [strongSelf.tableView reloadData];
        }];
        
    }else{
    RequestModel *params = [[RequestModel alloc] init];
    params.prdOrdNo = self.orderNoStr;
    params.optType = optType;
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithRevokeOrConfirmParams:params success:^(NSString *acceptState) {
        STRONG_SELF;
        strongSelf.detailDataModel.acceptState = acceptState;
        [strongSelf tableViewTool].billDetailType = self.billDetailType;
        [strongSelf tableViewTool].detailDataModel = strongSelf.detailDataModel;
        [strongSelf.tableView reloadData];
    }];
    
    }
    
    
    
    
}

//查询支付方式接口
- (void)loadCheckPayTypeData
{
    RequestModel *params = [[RequestModel alloc] init];
    params.txAmt = self.detailDataModel.getTxAmtStr;
    params.tranTypeSel = @"5";
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *baseModel) {
        STRONG_SELF;
        YMBankCardDataModel *dataM = [baseModel getBankCardDataModel];
        strongSelf.bankCardDataModel = dataM;
        if ([strongSelf.bankCardDataModel getIsAcbalUse]) {
            [strongSelf loadPayCashierView];
        }else{
            [MBProgressHUD showText:@"余额不足"];
        }
    }];
}
//网络请求 （请求创建手机充值订单接口）
- (void)loadCreatOrderData
{
    //有订单号，调用下面密码弹框方法
    [self loadPayPasswordBoxView];
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

//网络请求 （请求校验手机充值支付密码接口）
- (void)loadPayPwdData:(NSString *)payPwd withPayType:(int)paytype
{
    YMUserInfoTool * user = [YMUserInfoTool shareInstance];
    //请求之后进行相应的操作
    NSDictionary * paramDic = @{@"token":user.token,
                                @"tranCode":MOBILERECHARGEPAYCODE,
                                @"recPhoneNo":[self.detailDataModel.getPhoneNumberStr encryptAES],
                                @"payPwd ":[payPwd encryptAES],
                                @"prdOrdNo":self.detailDataModel.getShangPinDingDanHaoStr
                                };
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:paramDic];
    
    if (paytype == 1) {
        [param setObject:payPwd forKey:@"payPwd"];
    }
    NSString *fingerText = [NSString stringWithFormat:@"{\"machineNum\":\"%@\",\"raw\":\"%@\",\"tee_n\":\"IOS\",\"tee_v\":\"%@\"}",[ObtainUserIDFVTool getIDFV],[YMUserInfoTool shareInstance].randomCode,[[UIDevice currentDevice] systemVersion]];
    [param setObject:fingerText forKey:@"fingerText"];
    [param setObject:[[ObtainUserIDFVTool getIDFV] encryptAES] forKey:@"machineNum"];
    [param setObject:[[NSString stringWithFormat:@"%d",paytype] encryptAES] forKey:@"pwdType"];
    
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:paramDic success:^(id responseObject) {
        //停止转动
        self.pwdBoxView.loading = NO;
        
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        [MBProgressHUD showText:resMsg];
        if (resCode == 1) {
            [self loadData];
            //通知列表界面刷新数据。
            
            [WSYMNSNotification postNotificationName:WSYMRefreshBillListNotification object:nil];
            
            //移除
            [self.pwdBoxView removeFromSuperview];
        }
    } failure:^(NSError *error) {
        //停止转动
        self.pwdBoxView.loading = NO;
    }];
    
}
#pragma mark - 调起收银台 弹框view
- (void)loadPayCashierView
{
    WEAK_SELF;
    YMPayCashierView *payCashierView = [YMPayCashierView getPayCashierView];
    payCashierView.payCashierType = PayCashierMobile;
    [payCashierView showPayCashierDeskViewWtihCurrentVC:self withBankCardDataModel:self.bankCardDataModel withMoney:self.detailDataModel.getTxAmtStr resultBlock:^(YMBankCardModel *bankCardModel, BOOL isAddCard) {
        STRONG_SELF;
        strongSelf.payTypeModel = bankCardModel;
        [strongSelf loadCreatOrderData];
    }];
}
#pragma mark -//支付密码弹框
- (void)loadPayPasswordBoxView
{
    self.pwdBoxView = [YMVerificationPaywordBoxView getPayPwdBoxView];
    [self.pwdBoxView showPayPwdBoxViewResultSuccess:^(NSString *pwdStr) {
//        self.pwdBoxView.loading = YES;
        YMLog(@"pwdStr = %@",pwdStr);
        [self havaFingerPay];
    } forgetPwdBtn:^{
        [self.pwdBoxView removeFromSuperview];
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navigationController pushViewController:changePayVC animated:YES];
    } quitBtn:^{
        [self.task cancel];
    }];
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)selectComplaintsMethod
{
    YMLog(@"订单投诉相关按钮。。。");
    switch (self.billDetailType) {
        case BillDetailConsumeMobilePhoneRecharge://手机充值
        {
            if ([[self.detailDataModel getXiaoFeiOrderStatusCode]isEqualToString:@"00"]) {
                [self loadCheckPayTypeData];
            }else if ([[self.detailDataModel getXiaoFeiOrderStatusCode]isEqualToString:@"99"]){
        
            }else{
                NSString *AcceptStateCode = [self.detailDataModel getAcceptStateCodeStr];
                if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
                    [self loadWeiTouSu];
                }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
                    [self loadRevokeOrConfirmData:@"1"];//请求投诉-撤销或者确认接口
                }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
                    [self loadRevokeOrConfirmData:@"2"];//请求投诉-撤销或者确认接口
                }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
                }
            }
        }
            break;
        case BillDetailConsumeScan://手机充值,//消费---扫一扫超级收款码 //扫一扫pc端生成的二维码//TX
        {
            if ([[self.detailDataModel getXiaoFeiOrderStatusCode]isEqualToString:@"00"]||[[self.detailDataModel getXiaoFeiOrderStatusCode]isEqualToString:@"99"]) {
            }else{
                NSString *AcceptStateCode = [self.detailDataModel getAcceptStateCodeStr];
                if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
                    [self loadWeiTouSu];
                }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
                    [self loadRevokeOrConfirmData:@"1"];//请求投诉-撤销或者确认接口
                }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
                    [self loadRevokeOrConfirmData:@"2"];//请求投诉-撤销或者确认接口
                }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
                }
            }
        }
            break;
        case BillDetailAccountTransfer://转账(我要收款/ 扫一扫有名收款码)
        {
            if ([[self.detailDataModel getXiaoFeiOrderStatusCode]isEqualToString:@"04"]) {
                
                [self loadRevokeOrConfirmData:@"3"];

            }else{
            NSString *AcceptStateCode = [self.detailDataModel getAcceptStateCodeStr];
            if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
                
                [self loadWeiTouSu];
            }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
                [self loadRevokeOrConfirmData:@"1"];//请求投诉-撤销或者确认接口
            }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
                [self loadRevokeOrConfirmData:@"2"];//请求投诉-撤销或者确认接口
            }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
                
            }
            }
            
        }
            break;
        case BillDetailAccountRecharge://账户充值
        {
            if ([[self.detailDataModel getXiaoFeiOrderStatusCode]isEqualToString:@"00"]||[[self.detailDataModel getXiaoFeiOrderStatusCode]isEqualToString:@"99"]) {
                
            }else{
                NSString *AcceptStateCode = [self.detailDataModel getAcceptStateCodeStr];
                if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
                    [self loadWeiTouSu];
                }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
                    [self loadRevokeOrConfirmData:@"1"];//请求投诉-撤销或者确认接口
                }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
                    [self loadRevokeOrConfirmData:@"2"];//请求投诉-撤销或者确认接口
                }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
                }
            }
        }
            break;
        case BillDetailAccountWithDrawal://账户提现
        {
            NSString *AcceptStateCode = [self.detailDataModel getAcceptStateCodeStr];
            if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
                [self loadWeiTouSu];
            }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
                [self loadRevokeOrConfirmData:@"1"];//请求投诉-撤销或者确认接口
            }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
                [self loadRevokeOrConfirmData:@"2"];//请求投诉-撤销或者确认接口
            }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
            }
        }
            break;
            
        default:
            break;
    }
    
}

//未投诉时  按钮点击事件
- (void)loadWeiTouSu
{
    YMAllBillComplaintVC *complaintVC = [[YMAllBillComplaintVC alloc] init];
    complaintVC.billDetailType = self.billDetailType;
    //self.tranTypeStr;1消费2手机充值3充值4转账5提现
    NSString *tranType = @"";
    if ([self.tranTypeStr isEqualToString:@"1"]) {
        tranType = @"1";
    }else if ([self.tranTypeStr isEqualToString:@"2"]){
        tranType = @"5";
    }else if ([self.tranTypeStr isEqualToString:@"3"]){
        tranType = @"2";
    }else if ([self.tranTypeStr isEqualToString:@"4"]){
        tranType = @"4";
    }else if ([self.tranTypeStr isEqualToString:@"5"]){
        tranType = @"3";
    }
    // 1消费 2账户充值 3提现 4转账 5手机充值
    complaintVC.tranType = tranType;
    complaintVC.detailDataModel = self.detailDataModel;
    [self.navigationController pushViewController:complaintVC animated:YES];
}
#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.tableViewTool;
        _tableView.dataSource = self.tableViewTool;
        _tableView.rowHeight = 46;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (YMAllBillDetailTool *)tableViewTool
{
    if (!_tableViewTool) {
        _tableViewTool = [[YMAllBillDetailTool alloc] initWithTableView];
        _tableViewTool.tableView = self.tableView;
        _tableViewTool.delegate = self;
    }
    return _tableViewTool;
}

- (void)setBillDetailType:(BillDetailType)billDetailType
{
    _billDetailType = billDetailType;
}

- (void)setBillListModel:(YMAllBillListDataListModel *)billListModel
{
    _billListModel = billListModel;
    if (_billListModel == nil) {
        return;
    }
    self.orderNoStr = [self.billListModel getOrderNoStr];
    self.tranTypeStr = [self.billListModel getTranTypeStr];
    [self.tableView reloadData];
}
- (void) sendOrderNo:(NSString *)orderNo tranType:(NSString *)tranType
{
    self.orderNoStr = orderNo;
    self.tranTypeStr = tranType;
    [self.tableView reloadData];
}
-(void)hideTableViewFooter
{
    self.tableView.tableFooterView = [UIView new];
}
@end
