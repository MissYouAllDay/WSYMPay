//
//  YMControlMoneyController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/15.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMControlMoneyController.h"
#import "YMPayBankCardCell.h"
#import "YMGetUserInputCell.h"
#import "YMRedBackgroundButton.h"
#import "YMPayBankCardListView.h"
#import "YMAddBankCardController.h"
#import "YMBankCardModel.h"
#import "IQKeyboardManager.h"
#import "YMUserInfoTool.h"
#import "YMMyHttpRequestApi.h"
#import "UITextField+Extension.h"
#import "YMBankCardDataModel.h"
#import "YMBankCardBaseModel.h"
#import "YMPayCardListView.h"
#import "IDVerificationViewController.h"

@interface YMControlMoneyController ()<UITextFieldDelegate,YMPayBankCardListViewDelegate>

@property (nonatomic, weak) YMRedBackgroundButton *nextBtn;
@property (nonatomic, strong) YMPayBankCardListView *payBankCardListView;

@end

@implementation YMControlMoneyController

- (instancetype)init
{
    
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.recharge = YES;
    }
    
    return self;
}

-(UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        
        UILabel *balanceLabel      = [[UILabel alloc]init];
        balanceLabel.textColor     = RGBColor(133, 133, 133);
        balanceLabel.font          = [UIFont systemFontOfMutableSize:13];
        balanceLabel.text          = [NSString stringWithFormat:@"账户余额: %@元",[YMUserInfoTool shareInstance].cashAcBal];
        balanceLabel.textAlignment = NSTextAlignmentLeft;
        [balanceLabel sizeToFit];
        [self.tableView addSubview:balanceLabel];
        _balanceLabel = balanceLabel;
    }
    
    return _balanceLabel;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager* manager                  = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside          = NO;
    if (self.recharge) {
        self.currentBankCard = [_bankCardDataModel getPayTypeModel];
        
        if ([_bankCardDataModel getBankCardListArray].count == 0) { }else {
            self.currentBankCard = [_bankCardDataModel getBankCardListArray][0];
        }
        
    }else{
        if (self.bankCardArray.count > 0) {
            for (YMBankCardModel *model in self.bankCardArray) {
                if ([[model getLastUsedStr] containsString:@"2"]) {
                    if ([[model getLastUsedStr]isEqualToString:@"2"]) {
                        self.currentBankCard = model;
                        break;
                    }
                }
            }
        }
    }
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    IQKeyboardManager* manager                  = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside          = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotification];
    [self setupSubviews];
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

-(void)setupSubviews
{
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.tableView.delaysContentTouches = NO;
    [self.tableView reloadData];
    //注册按钮
    YMRedBackgroundButton*nextBtn = [[YMRedBackgroundButton alloc]init];
    nextBtn.enabled = NO;
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
}

-(void)setupNotification
{
    [WSYMNSNotification addObserver:self selector:@selector(refreshAccountMoney) name:WSYMRefreshUserInfoNotification object:nil];
    [WSYMNSNotification addObserver:self selector:@selector(refreshBankCardList) name:WSYMUserAddBankCardSuccessNotification object:nil];
}

-(void)refreshAccountMoney
{
    self.balanceLabel.text = [NSString stringWithFormat:@"账户余额: %@元",[YMUserInfoTool shareInstance].cashAcBal];
    [self.balanceLabel sizeToFit];
}
#pragma mark - 刷新银行卡。。。
-(void)refreshBankCardList
{
        if (self.bankCardDataModel != nil) {//充值
            RequestModel *params = [[RequestModel alloc] init];
            params.tranTypeSel = @"2";//后台说此处传2
            params.txAmt = @"0";
            WEAK_SELF;
            [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *model) {
                STRONG_SELF;
                YMBankCardDataModel *dataModel = [model getBankCardDataModel];
                strongSelf.bankCardDataModel = dataModel;
                [strongSelf.tableView reloadData];
            }];
            
        }else{//提现
            [YMMyHttpRequestApi loadHttpRequestWithCheckBankListsuccess:^(NSArray<YMBankCardModel *> *response) {
                self.bankCardArray = [NSMutableArray arrayWithArray:response];
            }];
        }
}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.bankCardArray.count>0?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.bankCardArray.count>0) {
        if (indexPath.section == 0) {
            YMPayBankCardCell *cell = [[YMPayBankCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            if (_recharge == NO) {
                cell.type = 2;
            }
            cell.bankCardModel      = self.currentBankCard;
            cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
            return [self createCellForInputMoney:tableView cellForRowAtIndexPath:indexPath];
        }
    }else{
        return [self createCellForInputMoney:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self showBankCardListView];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bankCardArray.count > 0) {
        if (indexPath.section == 0) {
            
            return (SCREENWIDTH * ROWProportion) * 1.4;
        } else {
            
            return SCREENWIDTH * ROWProportion;
        }
    }else{
        return SCREENWIDTH * ROWProportion;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERSECTION_HEIGHT;
}

-(void)textFieldDidEditingChanged:(UITextField *)textField
{
    if (_currentBankCard.userTypeNum == 9) {
        self.nextBtn.enabled = NO;
    }else{
        if (textField.text.length && [textField.text doubleValue] > 0) {
            self.nextBtn.enabled = YES;
        } else {
            
            self.nextBtn.enabled = NO;
        }
    }
}

-(void)nextBtnClick
{
    [self.view endEditing:YES];
    
    //    if (self.bankCardArray.count>0) {
    //        YMAddBankCardController *addBankCardVC = [[YMAddBankCardController alloc]init];
    //        [self.navigationController pushViewController:addBankCardVC animated:YES];
    //        return;
    //    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [UITextField textFieldWithMoneyFormat:textField shouldChangeCharactersInRange:range replacementString:string];
}

-(void)showBankCardListView
{
    [self.view endEditing:YES];
    
    WEAK_SELF;
    YMPayCardListView *cardListView = [YMPayCardListView getPayCardListView];
    
    if (self.recharge) {//充值
        cardListView.type = 1;
        [cardListView showPayTypeViewWtihCurrentVC:self withBankCardDataModel:self.bankCardDataModel bankCardArray:self.bankCardArray payTypeModel:self.currentBankCard isShowBalance:YES resultBlock:^(YMBankCardModel *payTypeModel, NSString *payTypeStr) {
            STRONG_SELF;
            strongSelf.currentBankCard = payTypeModel;
            if (payTypeModel == nil && payTypeStr == nil) {//添加新的银行卡
                [self goAddBankCard];
            }else{
                YMLog(@"payTypeStr = %@",payTypeStr);
            }
            [strongSelf.tableView reloadData];
        }];
    }else{//提现
        
        cardListView.type = 2;
        [cardListView showPayTypeViewWtihCurrentVC:self withBankCardDataModel:self.bankCardDataModel bankCardArray:self.bankCardArray payTypeModel:self.currentBankCard isShowBalance:NO resultBlock:^(YMBankCardModel *payTypeModel, NSString *payTypeStr) {
            STRONG_SELF;
            strongSelf.currentBankCard = payTypeModel;
            if (payTypeModel == nil && payTypeStr == nil) {//添加新的银行卡
                [self goAddBankCard];
            }else{
                YMLog(@"payTypeStr = %@",payTypeStr);
            }
            [strongSelf.tableView reloadData];
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

#pragma mark - YMPayBankCardListViewDelegate

-(UITableViewCell *)createCellForInputMoney:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YMGetUserInputCell *cell = [[YMGetUserInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.leftTitle = @"金额";
    cell.userInputTF.keyboardType = UIKeyboardTypeDecimalPad;
    cell.userInputTF.delegate     = self;
    _moneyTextField = cell.userInputTF;
    [cell.userInputTF addTarget:self action:@selector(textFieldDidEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.recharge) {
        
        cell.userInputTF.placeholder  = @"请输入充值金额(元)";
        CGRect  rect = [tableView rectForRowAtIndexPath:indexPath];
        CGFloat w = SCREENWIDTH * 0.9;
        CGFloat h = SCREENWIDTH * ROWProportion;
        CGFloat x = (SCREENWIDTH - w) /2;
        CGFloat y = CGRectGetMaxY(rect) + (SCREENWIDTH * ROWProportion) * 0.5;
        self.nextBtn.frame = CGRectMake(x, y, w, h);
        
    } else {
        cell.userInputTF.placeholder  = @"请输入提现金额(元)";
        CGRect  rect = [tableView rectForRowAtIndexPath:indexPath];
        CGFloat w = SCREENWIDTH * 0.9;
        CGFloat h = SCREENWIDTH * ROWProportion;
        CGFloat x = (SCREENWIDTH - w) /2;
        CGFloat y = CGRectGetMaxY(rect) + (SCREENWIDTH * ROWProportion);
        self.nextBtn.frame = CGRectMake(x, y, w, h);
        
        CGFloat bw = self.balanceLabel.bounds.size.width;
        CGFloat bh = self.balanceLabel.bounds.size.height;
        CGFloat by = CGRectGetMaxY(rect) + ((SCREENWIDTH * ROWProportion) - bh) / 2;
        
        self.balanceLabel.frame = CGRectMake(x, by, bw, bh);
        
    }
    
    return cell;
    
}



#pragma mark - 提现传过来的。。。。
-(void)setBankCardArray:(NSMutableArray *)bankCardArray
{
    _bankCardArray = bankCardArray;
    if (_bankCardArray.count > 0) {
        for (YMBankCardModel *model in _bankCardArray) {
            if ([[model getLastUsedStr] containsString:@"2"]) {
                if ([[model getLastUsedStr]isEqualToString:@"2"]) {
                    self.currentBankCard = model;
                    break;
                }
            }
        }
    }
    [self.tableView reloadData];
}
- (void)setRecharge:(BOOL)recharge
{
    _recharge = recharge;
}
#pragma mark - 充值传过来的。。。。
- (void)setBankCardDataModel:(YMBankCardDataModel *)bankCardDataModel
{
    _bankCardDataModel = bankCardDataModel;
    if (_bankCardDataModel == nil) {
        return;
    }
    self.bankCardArray = [_bankCardDataModel getBankCardListArray];
    self.currentBankCard = [_bankCardDataModel getPayTypeModel];
    [self.tableView reloadData];
}
@end
