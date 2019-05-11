//
//  YMTransferVC.m
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferVC.h"
#import "YMTransferTool.h"
#import "YMTransferToYmWalletVC.h"
#import "YMTransferToBankCardVC.h"
#import "YMTransferListVC.h"
#import "YMTransferMoneyVC.h"
#import "YMMyHttpRequestApi.h"
#import "YMTransferRecentRecodeDataListModel.h"
#import "YMTransferCheckAccountDataModel.h"
#import "PromptBoxView.h"
#import "YMCustomHeader.h"
#import "YMAllBillListVC.h"
#import "YMBillRecordListVC.h"

@interface YMTransferVC ()<YMTransferToolDelegate,PromptBoxViewDelegate>
@property (nonatomic, strong) YMTransferTool *tableViewTool;
@property (nonatomic, strong) YMTransferCheckAccountDataModel *dataModel;
@property (nonatomic, strong) PromptBoxView *promptBoxView;
@property (nonatomic, copy) NSString *accountStr;
@end

@implementation YMTransferVC

#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}
- (void)dealloc
{
    [WSYMNSNotification removeObserver:self name:WSYMRefreshTransferNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadData];
    [self addNotification];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - eventResponse                - Method -
- (void)rightBtnClick
{
    YMBillRecordListVC *billListVC = [[YMBillRecordListVC alloc] init];
    billListVC.billType = BillAccountTransfer;
    [self.navigationController pushViewController:billListVC animated:YES];
}
#pragma mark - notification                 - Method -
-(void)addNotification
{
    [WSYMNSNotification addObserver:self selector:@selector(loadData) name:WSYMRefreshTransferNotification object:nil];
}

#pragma mark - privateMethods               - Method -
- (void)initViews{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.title = @"转账";
    UIBarButtonItem  *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bill"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.tableView.delegate = [self tableViewTool];
    self.tableView.dataSource = [self tableViewTool];

    self.tableView.mj_header = [YMCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeadRefresh)];
}

- (void)loadData{
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithTransferRecentRecordSucess:^(NSMutableArray *array) {
        STRONG_SELF;
        [strongSelf tableViewTool].dataArray = array;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView reloadData];
    }failure:^{
        STRONG_SELF;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView reloadData];
    }];
}

- (void)loadCheckAccountData
{
    [MBProgressHUD show];
    WEAK_SELF;
    RequestModel *params = [[RequestModel alloc] init];
    params.usrMp = weakSelf.accountStr;
    [YMMyHttpRequestApi loadHttpRequestWithTransferToBalanceCheckAccount:params success:^(YMTransferCheckAccountDataModel *model) {
        STRONG_SELF;
        strongSelf.dataModel = model;
        [strongSelf goToNextMethod];
    } failure:^(NSString *resMsg) {
        
    }];
}
//发送注册邀请
- (void)loadInVitationData
{
    [YMMyHttpRequestApi loadHttpRequestWithTransferToBalanceInviteAccount:self.accountStr];
}
/**
 * 根据返回的信息判断需要执行什么操作
 * 1、该用户还未注册有名钱包
 * 2、账户被冻结或禁用，进行提示
 * 3、对方账户为一类账户，弹框提示
 * 4、检测到账户为二、三类账户，进入有名钱包账户转账 转账金额界面
 */
- (void)goToNextMethod
{
    NSInteger num = [self.dataModel goToAction];
    switch (num) {
        case 1:
        {
            //该用户还未注册有名钱包
            [self promptBoxView].title = @"该用户还未注册有名钱包!";
            [self promptBoxView].rightButtonTitle = @"邀请注册";
            [self promptBoxView].tag = 102;
            [self.promptBoxView show];
        }
            break;
        case 2:
        {
            //账户冻结或禁用
            [self promptBoxView].title = MSG17;
            [self promptBoxView].rightButtonTitle = @"确定";
            [self promptBoxView].tag = 100;
            [self.promptBoxView show];
        }
            break;
        case 3:
        {
            //一类账户
            [self promptBoxView].title = @"对方账户为一类账户，每年累计付款交易（包括转账到个人银行卡）不超过1000元。您可以提醒对方进行账户升级。继续向对方转账？";
            [self promptBoxView].rightButtonTitle = @"确定";
            [self promptBoxView].tag = 101;
            [self.promptBoxView show];
        }
            break;
        case 4:
        {
            //二三类账户，直接进入有名钱包账户转账 转账金额界面
            [self goToTransferMoneyVC];
        }
            break;
        default:
            break;
    }
}
- (void)goToTransferMoneyVC
{
    YMTransferToYmWalletVC *vc = [[YMTransferToYmWalletVC alloc] init];
    vc.accountString = self.accountStr;
    [self.navigationController pushViewController:vc animated:YES];
//    YMTransferMoneyVC *vc = [[YMTransferMoneyVC alloc] init];
//    vc.functionSource = @"1";
//    vc.dataModel = self.dataModel;
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableViewHeadRefresh
{
    [self loadData];
}
#pragma mark - customDelegate               - Method -(0--转到有名钱包账户,1--转到银行卡/转账到最近的转账用户)
- (void)selectLocalMethod:(NSInteger)row
{//0--转到有名钱包账户,1--转到银行卡
    switch (row) {
        case 0:
        {
            YMTransferToYmWalletVC *vc = [[YMTransferToYmWalletVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            YMTransferToBankCardVC *vc = [[YMTransferToBankCardVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
//最近转账记录列表点击事件
- (void)selectRecentlyMethod:(YMTransferRecentRecodeDataListModel *)model
{//先请求 （校验转入方账户、转出方余额限额信息） 这个接口
    self.accountStr = [model getToAccountsStr];
    NSString *tratype = [model getTratypeStr];
    [self loadCheckAccountData];
//    if ([tratype isEqualToString:@"01"]) {//01余额转余额（转账到有名钱包账户）
//        [self loadCheckAccountData];
//    }else if ([tratype isEqualToString:@"06"]){//06余额转银行卡
//        YMTransferToBankCardVC *vc = [[YMTransferToBankCardVC alloc] init];
//        vc.dataListModel = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}
#pragma mark - PromptBoxViewDelegate 弹框
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{
    
}
-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    switch (promptBoxView.tag) {
        case 100://账户冻结或禁用,点击确定返回YMTransferVC
            [self.promptBoxView removeView];
            break;
        case 101://一类账户，点击确定，继续跳转到 -- 有名钱包账户转账 转账金额界面
        {
            [self goToTransferMoneyVC];
        }
            break;
        case 102://该用户还未注册有名钱包--发短信邀请。。。
            YMLog(@"发送短信邀请");
            [self loadInVitationData];
            [self.promptBoxView removeView];
            break;
        default:
            break;
    }
}
#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (YMTransferTool *)tableViewTool
{
    if (!_tableViewTool) {
        _tableViewTool = [[YMTransferTool alloc] initWithTableView];
        _tableViewTool.tableView = self.tableView;
        _tableViewTool.delegate = self;
    }
    return _tableViewTool;
}
-(PromptBoxView *)promptBoxView
{
    if (!_promptBoxView) {
        _promptBoxView = [[PromptBoxView alloc]init];
        _promptBoxView.delegate = self;
        _promptBoxView.leftButtonTitle = @"取消";
    }
    return _promptBoxView;
}

@end
