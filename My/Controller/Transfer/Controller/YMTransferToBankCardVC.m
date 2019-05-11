//
//  YMTransferToBankCardVC.m
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankCardVC.h"
#import "YMTransferToBankCardTool.h"
#import "YMTransferMoneyLimitVC.h"
#import "YMTransferToBankCardConfirmVC.h"
#import "YMMyHttpRequestApi.h"
#import "YMTransferToBankCheckBankDataModel.h"
#import "RequestModel.h"
#import "YMTransferToBankSearchFeeDataModel.h"
#import "YMTransferRecentRecodeDataListModel.h"

@interface YMTransferToBankCardVC ()<YMTransferToBankCardToolDelegate>
@property (nonatomic, strong) YMTransferToBankCardTool *tableViewTool;
@property (nonatomic, copy) NSString *nameStr;//姓名
@property (nonatomic, copy) NSString *bankCardNumStr;//卡号
@property (nonatomic, copy) NSString *moneyStr;//金额
@property (nonatomic, assign) YMTransferToBankCheckBankDataModel *checkBankModel;
@end

@implementation YMTransferToBankCardVC
#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadLimitData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - privateMethods               - Method -
- (void)initViews
{
    self.title = @"转到银行卡";
    self.tableView.delegate = [self tableViewTool];
    self.tableView.dataSource = [self tableViewTool];
    [self tableViewTool].vc = self;
}
- (void)loadLimitData
{
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithTransferToBankMoneyLimitSuccess:^(YMTransferToBankLimitDataModel *model) {
        STRONG_SELF;
        [strongSelf tableViewTool].limitDataModel = model;
        [strongSelf.tableView reloadData];
    }];
}
- (void)loadData//查询转账手续费,确认转账按钮
{
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.txAmt = self.moneyStr;
    parameters.bankAcNo = self.bankCardNumStr;
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithTransferToBankSearchReqFeeParameters:parameters success:^(YMTransferToBankSearchFeeDataModel *model) {
        STRONG_SELF;
        model.txAmt = strongSelf.moneyStr;
        model.bankAcNo = strongSelf.bankCardNumStr;
        model.cardName = strongSelf.nameStr;
        strongSelf.checkBankModel = model;
        [strongSelf tableViewTool].checkBankModel = model;
        [strongSelf.tableView reloadData];
        
        if (model == nil) {
            return ;
        }
        if (![[model getCardTypeStr]isEqualToString:@"01"]) {//银行卡类型不支持信用卡转账
            [MBProgressHUD showText:MSG16];
            return;
        }

        YMTransferToBankCardConfirmVC *confirmVC = [[YMTransferToBankCardConfirmVC alloc] init];
        confirmVC.searchFeeDataModel = model;
        [strongSelf.navigationController pushViewController:confirmVC animated:YES];
   }];
}

- (void)loadCheckBankCardData//验证银行卡
{
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithTransferToBankCheckBankCard:self.bankCardNumStr success:^(YMTransferToBankCheckBankDataModel *model) {
        STRONG_SELF;
        strongSelf.checkBankModel = model;
        [strongSelf tableViewTool].checkBankModel = model;
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void) selectLimitBtn//限额说明
{
    YMTransferMoneyLimitVC *limitVC = [[YMTransferMoneyLimitVC alloc] init];
    [self.navigationController pushViewController:limitVC animated:YES];
}
- (void)selectSureTransferBtnName:(NSString *)name bankCard:(NSString *)bankCard money:(NSString *)money//确认转账
{
    self.nameStr = name;
    self.bankCardNumStr = [bankCard clearSpace];
    self.moneyStr = money;
    double moneyNum = [money doubleValue];
    if (moneyNum >0) {
        [self loadData];
    }else{
        [MBProgressHUD showText:@"转账金额应大于0"];
    }
    
}
- (void)checkBankCard:(NSString *)bankAcNo
{//输入银行卡号，网络请求。。。
    self.bankCardNumStr = [bankAcNo clearSpace];
    [self loadCheckBankCardData];
}

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (YMTransferToBankCardTool *)tableViewTool
{
    if (!_tableViewTool) {
        _tableViewTool = [[YMTransferToBankCardTool alloc] initWithTableView];
        _tableViewTool.tableView = self.tableView;
        _tableViewTool.delegate = self;
    }
    return _tableViewTool;
}
- (void)setDataListModel:(YMTransferRecentRecodeDataListModel *)dataListModel
{
    _dataListModel = dataListModel;
    if (_dataListModel == nil) {
        return;
    }
    [self tableViewTool].fromDataListModel = _dataListModel;
    [self.tableView reloadData];
}
@end
