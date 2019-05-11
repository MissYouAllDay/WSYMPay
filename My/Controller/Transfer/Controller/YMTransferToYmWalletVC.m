//
//  YMTransferToYmWalletVC.m
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToYmWalletVC.h"
#import "YMTransferToYmWalletTool.h"
#import "PromptBoxView.h"
#import "YMTransferMoneyVC.h"
#import "YMMyHttpRequestApi.h"
#import "YMTransferToYmDefraudVC.h"

#import "YMTransferCheckAccountDataModel.h"

@interface YMTransferToYmWalletVC ()<YMTransferToYmWalletToolDelegate,PromptBoxViewDelegate>
@property (nonatomic, strong) YMTransferToYmWalletTool *tableViewTool;
@property (nonatomic, strong) PromptBoxView *promptBoxView;
@property (nonatomic, copy) NSString *accountStr;
@property (nonatomic, strong)YMTransferCheckAccountDataModel *dataModel;
@end

@implementation YMTransferToYmWalletVC

#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}
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

#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - privateMethods               - Method -
- (void)initViews
{
    self.title = @"有名钱包账户";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    
    self.tableView.delegate = [self tableViewTool];
    self.tableView.dataSource = [self tableViewTool];
    [self tableViewTool].vc = self;
    [self.tableView reloadData];
}
- (void)loadData
{
    [MBProgressHUD show];
    WEAK_SELF;
    RequestModel *params = [[RequestModel alloc] init];
    params.usrMp = self.accountStr;
    
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
    YMTransferMoneyVC *vc = [[YMTransferMoneyVC alloc] init];
    
    vc.functionSource = @"1";
    vc.paymentDate = self.paymentDate;
    vc.dataModel = self.dataModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - customDelegate               - Method -
- (void)selectNextSearchAccount:(NSString *)account withType:(NSString *)type
{
    self.accountStr = account;
    self.paymentDate = type;
    [self loadData];
}
- (void)tipOfDefraudAction{
    YMTransferToYmDefraudVC *vc = [[YMTransferToYmDefraudVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - PromptBoxViewDelegate
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{
    
}
-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    switch (promptBoxView.tag) {
        case 100://账户冻结或禁用,点击确定返回YMTransferVC
            [[self promptBoxView] removeView];
            break;
        case 101://一类账户，点击确定，继续跳转到 -- 有名钱包账户转账 转账金额界面
        {
            [self goToTransferMoneyVC];
        }
            break;
        case 102://该用户还未注册有名钱包--发短信邀请。。。
            YMLog(@"发送短信邀请");
            [self loadInVitationData];
            [[self promptBoxView] removeView];
            break;
        default:
            break;
    }
}
#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (YMTransferToYmWalletTool *)tableViewTool
{
    if (!_tableViewTool) {
        _tableViewTool = [[YMTransferToYmWalletTool alloc] initWithTableView];
        _tableViewTool.tableView = self.tableView;
        _tableViewTool.delegate = self;
        _tableViewTool.accountString = self.accountString;
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
