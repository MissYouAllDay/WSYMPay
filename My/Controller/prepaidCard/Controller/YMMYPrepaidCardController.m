//
//  YMMYPrepaidCardController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/2.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMMYPrepaidCardController.h"
#import "YMBankCardNoneCell.h"
#import "YMVerificationPaywordBoxView.h"
#import "YMAddBankCardCell.h"
#import "YMBankCardNoneCell.h"
#import "YMMyPrepaidCardCell.h"
#import "YMAddPrepaidController.h"
#import "YMPrepaidCardModel.h"
#import "YMPublicHUD.h"
#import "ChangePayPwdViewController.h"
#import "YMMyHttpRequestApi.h"
#import "FirstRealNameCertificationViewController.h"
#import "PromptBoxView.h"
#import "YMUserInfoTool.h"
@interface YMMYPrepaidCardController ()<UIActionSheetDelegate,YMMyPrepaidCardCellDelegate,YMVerificationPaywordBoxViewDelegate,PromptBoxViewDelegate>

@property (nonatomic, strong) YMVerificationPaywordBoxView *payPasswordBoxView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) YMPublicHUD *hud;
@property (nonatomic, strong) YMPrepaidCardModel *deletePrepaidCard;
@property (nonatomic, strong) PromptBoxView *promptBoxView;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, weak) NSURLSessionTask *task;

@end

@implementation YMMYPrepaidCardController
#pragma mark - getters and setters          - Method -
- (NSMutableArray *)bankCardArray
{
    if (!_bankCardArray) {
        _bankCardArray = [[NSMutableArray alloc] init];
    }
    return _bankCardArray;
}
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

-(YMVerificationPaywordBoxView *)payPasswordBoxView
{
    if (!_payPasswordBoxView) {
        _payPasswordBoxView = [[YMVerificationPaywordBoxView alloc]init];
        _payPasswordBoxView.delegate = self;
    }
    
    return _payPasswordBoxView;
}
-(UILabel *)promptLabel
{
    if (!_promptLabel) {
        
        _promptLabel           = [[UILabel alloc]init];
        _promptLabel.text      = @"添加您本人名下的有名预付卡,线上支付更快捷";
        _promptLabel.textColor = RGBColor(193, 193, 193);
        _promptLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:11]];
    }
    return _promptLabel;
}

-(YMPublicHUD *)hud{
    if (!_hud) {
        _hud = [[YMPublicHUD alloc]init];
    }
    return _hud;
}

#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoaded = NO;
    [self setupSubViews];
    [self loadData];
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setNavigationBarTitntColor:[UIColor whiteColor] titleColor:RGBColor(43, 43, 43)];
    [self setNavigationItem];
    [self setShouldResignOnTouchOutside:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setNavigationBarTitntColor:NAVIGATIONBARCOLOR titleColor:[UIColor whiteColor]];
    [self setShouldResignOnTouchOutside:YES];
}

#pragma mark - privateMethods               - Method -
-(void)setNavigationItem
{
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"backblack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)setupSubViews
{
    self.tableView.delaysContentTouches = NO;
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"我的预付卡";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadData
{
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPrepaidCardListSuccess:^(NSArray<YMPrepaidCardModel *> *prepaidCardList) {
        STRONG_SELF;
        strongSelf.isLoaded = YES;
        YMLog(@"array = %@",[NSMutableArray arrayWithArray:prepaidCardList]);
        strongSelf.bankCardArray = [NSMutableArray arrayWithArray:prepaidCardList];
        [strongSelf.tableView reloadData];
    }];
}
//每个分区中的cell个数
- (NSInteger)getBankCardCount:(NSInteger)section
{
    NSInteger count = 0;
    if (self.bankCardArray.count>0) {
        if (section == 0) {
            count = self.bankCardArray.count;
        }else{
            count = 1;
        }
    }else{
        count = 1;
    }
    return count;
}
#pragma mark - eventResponse                - Method -
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - notification                 - Method -
-(void)addNotification
{
    [WSYMNSNotification addObserver:self selector:@selector(loadData) name:WSYMUserAddPrepaidCardSuccessNotification object:nil];
}

#pragma mark - objective-cDelegate          - Method -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //changed by pzj
    if (self.isLoaded) {
        return 2;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //changed by pzj
    return [self getBankCardCount:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //changed by pzj
    if (indexPath.section == 0) {
        if (self.bankCardArray.count>0) {//显示预付卡
            static NSString *cellID = @"YMMyPrepaidCardCell";
            YMMyPrepaidCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[YMMyPrepaidCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.delegate = self;
            }
            if (self.bankCardArray.count>0) {
                cell.prepaidCardNO = self.bankCardArray[indexPath.row];
            }
            return cell;
        }else{//没有预付卡的样式
            
            static NSString *cellID = @"YMBankCardNoneCell";
            YMBankCardNoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[YMBankCardNoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
             cell.backgroundView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"prepaycard_none"]];
            return cell;
            
        }
    }else{
        static NSString *cellID = @"YMAddBankCardCell";
        YMAddBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[YMAddBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.titleStr = @"+ 添加有名预付卡";
        CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
        self.promptLabel.width   = SCREENWIDTH * 0.9;
        self.promptLabel.height  = LEFTSPACE;
        self.promptLabel.y       = CGRectGetMaxY(rect) + LEFTSPACE * 0.3;
        self.promptLabel.centerX = SCREENWIDTH * 0.5;
        self.promptLabel.textAlignment = NSTextAlignmentCenter;
        [self.tableView addSubview:self.promptLabel];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //changed by pzj
    if (indexPath.section == 1) {
        YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
        if (currentInfo.usrStatus == -1) {
            [self.promptBoxView show];
            return;
        }else{
            YMAddPrepaidController *addPrepaidCardVC = [[YMAddPrepaidController alloc]init];
            [self.navigationController pushViewController:addPrepaidCardVC animated:YES];
        
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return SCREENHEIGHT * 0.17 + HEADERSECTION_HEIGHT;
    }else{
        return (SCREENWIDTH * ROWProportion);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return HEADERSECTION_HEIGHT;
    }else{
        if (self.bankCardArray.count>0) {
           return 1;
        }else{
            return HEADERSECTION_HEIGHT;
        }
    }
}

#pragma mark - YMMyBankCardCellDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self deleteBankCard];
    }
}

-(void)deleteBankCard
{
    [self.payPasswordBoxView show];
}

-(void)myPrepaidCardCellManagementButtonDidClick:(YMMyPrepaidCardCell *)cardCell
{
    self.deletePrepaidCard = cardCell.prepaidCardNO;//卡号
    [YMPublicHUD showActionSheetTitle:nil message:nil destructiveBtn:@"删除预付费卡" cancelBtn:@"取消" destrusctive:^{
        [self deleteBankCard];
    } cancel:nil];
}

#pragma mark - YMVerificationPaywordBoxViewDelegate
-(void)verificationPaywordBoxViewQuitButtonDidClick:(YMVerificationPaywordBoxView *)boxView
{
    [self.task cancel];
}
//删除预付费卡
-(void)verificationPaywordBoxView:(YMVerificationPaywordBoxView *)boxView completeInput:(NSString *)str
{
    boxView.loading = YES;
  self.task = [YMMyHttpRequestApi loadHttpRequestWithDeletePrepaidCard:self.deletePrepaidCard.prepaidNo payPwd:str success:^(NSInteger resCode, NSString *resMsg) {
        if (resCode == 1) {
            [boxView removeFromSuperview];
            [self.bankCardArray removeObject:self.deletePrepaidCard];
            [self loadData];
            [self.tableView reloadData];
        }else {
            [self showMessage:resMsg resCode:resCode];
        }
    }];
}

-(void)verificationPaywordBoxViewForgetButtonDidClick:(YMVerificationPaywordBoxView *)boxView
{
    [boxView removeFromSuperview];
    
    ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
    [self.navigationController pushViewController:changePayVC animated:YES];
    
}

#pragma mark - YMPublicHUDDelegate
-(void)publicHUDViewOtherBtnDidClick:(YMPublicHUD *)hud
{
    [self.payPasswordBoxView removeFromSuperview];
    ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
    [self.navigationController pushViewController:changePayVC animated:YES];
}

-(void)showMessage:(NSString *)message resCode:(NSInteger)code
{
    if (code ==  PWDERRORTIMES_CODE){//密码错误，还可以输入"+N+"次"
        [YMPublicHUD showAlertView:nil message:message cancelTitle:@"重新输入" confirmTitle:@"忘记密码" cancel:^{
            self.payPasswordBoxView.loading = NO;
        } confirm:^{
            [self goChangePayPassword];
        }];
        
    }else {
        [self.payPasswordBoxView removeFromSuperview];
        if (code == PAYPWDLOCK_CODE) {
            [YMPublicHUD showAlertView:nil message:MSG15 cancelTitle:@"取消" confirmTitle:@"忘记密码" cancel:nil confirm:^{
                [self goChangePayPassword];
            }];
        } else {
            [YMPublicHUD showAlertView:nil message:message cancelTitle:@"确定" handler:nil];
        }
    }
}

-(void)goChangePayPassword
{
    [self.payPasswordBoxView removeFromSuperview];
    ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
    [self.navigationController pushViewController:changePayVC animated:YES];
}

#pragma mark - PromptBoxViewDelegate(未实名弹框代理)
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{
    
}

-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    FirstRealNameCertificationViewController * firstCerVC = [[FirstRealNameCertificationViewController alloc] init];
    [self.navigationController pushViewController:firstCerVC animated:YES];
}


@end
