//
//  YMAddPrepaidController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/5.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAddPrepaidController.h"
#import "YMGetUserInputCell.h"
#import "YMRedBackgroundButton.h"
#import "UIView+Extension.h"
#import "YMAddPrepaidCardGetCodeController.h"
#import "YMMyHttpRequestApi.h"
#import "YMResponseModel.h"
#import "VerificationView.h"
#import "UITextField+Extension.h"
@interface YMAddPrepaidController ()<UITextFieldDelegate>

@property (nonatomic, weak) YMRedBackgroundButton *nextBtn;

@property (nonatomic, strong) YMAddPrepaidCardGetCodeController *addPrepaidCardGetCodeVC;

@property (nonatomic, weak) UILabel *warningLabel;

@property (nonatomic, weak) UITextField *cardNOTextField;

@property (nonatomic, weak) UITextField *TelTextField;
@end

@implementation YMAddPrepaidController
#pragma mark - getters and setters          - Method -
-(YMAddPrepaidCardGetCodeController *)addPrepaidCardGetCodeVC
{
    if (!_addPrepaidCardGetCodeVC) {
        _addPrepaidCardGetCodeVC = [[YMAddPrepaidCardGetCodeController alloc]init];
    }
    return _addPrepaidCardGetCodeVC;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}
#pragma mark - privateMethods               - Method -
- (void)setupSubviews
{
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"添加预付卡";
    
    YMRedBackgroundButton*nextBtn = [[YMRedBackgroundButton alloc]init];
    nextBtn.enabled               = NO;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UILabel *warningLabel = [[UILabel alloc]init];
    warningLabel.text      = @"信息加密处理,仅用于银行验证";
    warningLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:12]];
    warningLabel.textColor = RGBColor(150, 150, 150);
    [self.tableView addSubview:warningLabel];
    self.warningLabel = warningLabel;
}

- (void)loadData
{
    [MBProgressHUD showMessage:@"正在验证预付卡..."];
    RequestModel *parames = [[RequestModel alloc] init];
    parames.prepaidNo     = [self.cardNOTextField.text clearSpace];
    parames.usrMp         = [self.TelTextField.text clearSpace];
     WEAK_SELF;
    [self.view endEditing:YES];
    [YMMyHttpRequestApi loadHttpRequestWithAddPrepaidCardRequestModel:parames success:^(YMResponseModel *model) {
        [MBProgressHUD hideHUD];
        if (model.resCode == 1) {
            STRONG_SELF;
            strongSelf.addPrepaidCardGetCodeVC.prepaidNoStr = [self.cardNOTextField.text clearSpace];
            strongSelf.addPrepaidCardGetCodeVC.usrMpStr = [self.TelTextField.text clearSpace];
            strongSelf.addPrepaidCardGetCodeVC.responseModel = model;
            [MBProgressHUD showText:model.resMsg];
            [weakSelf.addPrepaidCardGetCodeVC.verificationView createTimer];
            [strongSelf.navigationController pushViewController:strongSelf.addPrepaidCardGetCodeVC animated:YES];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERSECTION_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMGetUserInputCell *cell = [[YMGetUserInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.userInputTF.keyboardType = UIKeyboardTypeNumberPad;
    cell.userInputTF.delegate     = self;
    [cell.userInputTF addTarget:self action:@selector(textFieldDidEditingChange:) forControlEvents:UIControlEventEditingChanged];
    if (indexPath.section == 0) {
        cell.leftTitle   = @"卡号";
        cell.userInputTF.placeholder = @"请输入预付卡卡号";
        cell.userInputTF.delegate = self;
        self.cardNOTextField = cell.userInputTF;
    }
    
    if (indexPath.section == 1) {
        cell.leftTitle   = @"手机号";
        cell.userInputTF.placeholder = @"请输入银行预留手机号";
        self.TelTextField = cell.userInputTF;
        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
        
        self.warningLabel.x      = LEFTSPACE *2;
        self.warningLabel.height = LEFTSPACE;
        self.warningLabel.width  = SCREENWIDTH - LEFTSPACE *2;
        self.warningLabel.y      = rect.origin.y + rect.size.height + LEFTSPACE;
        
        
        self.nextBtn.height = SCREENWIDTH*ROWProportion;
        self.nextBtn.width  = SCREENWIDTH - LEFTSPACE * 2;
        self.nextBtn.x      = LEFTSPACE;
        self.nextBtn.y      = self.warningLabel.bottom + LEFTSPACE;
    }
    
    return cell;
}

-(void)textFieldDidEditingChange:(UITextField *)textField
{
    if (self.TelTextField.text.length == 13 && [self.cardNOTextField.text clearSpace].length >= 16) {
        
        self.nextBtn.enabled = YES;
    } else {
    
        self.nextBtn.enabled = NO;
    }
}


-(void)nextBtnClick
{
    [self loadData];
}

#pragma mark - UITextField的输入规则
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.TelTextField == textField) {
        return [UITextField textFieldWithPhoneFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if (self.cardNOTextField == textField) {
        return [UITextField textFieldWithBankCardFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

@end
