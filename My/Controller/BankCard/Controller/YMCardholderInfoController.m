//
//  YMCardholderInfoController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/1.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCardholderInfoController.h"
#import "YMGetUserInputCell.h"
#import "YMRedBackgroundButton.h"
#import "UIView+Extension.h"
#import "YMProtocolButton.h"
#import "ProtocolViewController.h"
#import "DatePickerView.h"
#import "YMAddBankGetCodeController.h"
#import "YMBankCardModel.h"
#import "RequestModel.h"
#import "YMMyHttpRequestApi.h"
#import "UITextField+Extension.h"
#import "YMUserInfoTool.h"
@interface YMCardholderInfoController ()<YMProtocolButtonDelegate,UITextFieldDelegate>

@property (nonatomic, weak) YMRedBackgroundButton *nextBtn;
@property (nonatomic, weak) YMProtocolButton *agreementButton;
@property (nonatomic, weak) UILabel *warningLabel;
@property (nonatomic, weak) UITextField *termTextField;
@property (nonatomic, weak) UITextField *safetyCodeTextField;
@property (nonatomic, weak) UITextField *phoneNoTextField;
@property (nonatomic, strong) DatePickerView *datePickerView;
@property (nonatomic, strong) YMAddBankGetCodeController *addBankGetCodeVC;

@end

@implementation YMCardholderInfoController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(DatePickerView *)datePickerView
{
    if (!_datePickerView) {
        __weak typeof(self) weakSelf = self;
        _datePickerView = [[DatePickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.datePickerView strYearMonth:^(NSString *strTM) {
            YMLog(@"选中的值---%@",strTM);
            weakSelf.termTextField.text = strTM;
            weakSelf.tableView.scrollEnabled = YES;
        }];
    }
    
    return _datePickerView;
}
-(YMAddBankGetCodeController *)addBankGetCodeVC{
    if (!_addBankGetCodeVC) {
        _addBankGetCodeVC = [[YMAddBankGetCodeController alloc]init];
    }
    
    return _addBankGetCodeVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    
}

-(void)setupSubviews
{
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"添加银行卡";
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, SCREENWIDTH * 0.23, 0, 0)];
    
    //注册按钮
    YMRedBackgroundButton*nextBtn = [[YMRedBackgroundButton alloc]init];
    nextBtn.enabled               = NO;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UILabel *warningLabel  = [[UILabel alloc]init];
    warningLabel.text      = @"信息加密处理,仅用于银行验证";
    warningLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:12]];
    warningLabel.textColor = RGBColor(150, 150, 150);
    [self.tableView addSubview:warningLabel];
    self.warningLabel = warningLabel;
    
    //协议按钮
    YMProtocolButton *agreementButton = [[YMProtocolButton alloc]init];
    agreementButton.delegate         = self;
    agreementButton.selected         = YES;
    agreementButton.title            = @"同意《网上有名服务协议》";
    [self.view addSubview:agreementButton];
    self.agreementButton = agreementButton;
}

-(void)nextBtnClick
{
    [self.view endEditing:YES];
    NSString *phoneNO = [self.phoneNoTextField.text clearSpace];
    
    if (!phoneNO.isValidateMobile) {
        [MBProgressHUD showText:@"请输入正确的手机号"];
        return;
    }
    
    RequestModel *paramers = [[RequestModel alloc]init];
    paramers.cardType      = [NSString stringWithFormat:@"0%ld",(long)self.bankCardModel.cardType];
    paramers.bankPreMobile = phoneNO;
    paramers.cardNo = self.bankCardModel.bankAcNo;
    paramers.randomCode    = [YMUserInfoTool shareInstance].randomCode;
    if (self.bankCardModel.cardType == 2) {
        paramers.cardDeadline = self.termTextField.text;
        paramers.safetyCode   = self.safetyCodeTextField.text;
    }
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetBankVCode:paramers success:^(NSInteger resCode, NSString *resMsg, NSDictionary *data) {
        
        [MBProgressHUD showText:resMsg];
        weakSelf.addBankGetCodeVC.paramers = paramers;
        weakSelf.addBankGetCodeVC.data = data;
        weakSelf.addBankGetCodeVC.bankCardModel = weakSelf.bankCardModel;
        [self.navigationController pushViewController:self.addBankGetCodeVC animated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        return 1;
    } else {
    
        if (self.bankCardModel.cardType == 1) {
        
            return 1;
        } else {
           return 3;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YMGetUserInputCell *cell = [[YMGetUserInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    
    if (indexPath.section == 0) {
        
          if (indexPath.row == 0) {
              
            cell.leftTitle = @"发卡行";
              NSString *bStr = nil;
              if (self.bankCardModel.cardType == 01) {
                  bStr = @"储蓄卡";
              } else {
                  bStr = @"信用卡";
              }
              
            NSString *bankInfo = [NSString stringWithFormat:@"%@ | %@",self.bankCardModel.bankName,bStr];
            cell.userInputTF.text = bankInfo;
            cell.userInputTF.enabled = NO;
           }
            if (indexPath.row == 1) {
                cell.leftTitle = @"有效期";
                cell.userInputTF.placeholder = @"月份/年份";
                cell.userInputTF.enabled = NO;
                self.termTextField = cell.userInputTF;
            }
            if (indexPath.row == 2) {
                cell.leftTitle = @"安全码";
                cell.userInputTF.placeholder  = @"卡背面末3位数字";
                cell.userInputTF.keyboardType = UIKeyboardTypeNumberPad;
                self.safetyCodeTextField  = cell.userInputTF;
            }
           cell.userInputTF.delegate = self;
        }

    if (indexPath.section == 1) {

        cell.leftTitle = @"手机号";
        cell.userInputTF.placeholder  = @"请输入银行预留手机号";
        cell.userInputTF.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneNoTextField         = cell.userInputTF;
        cell.userInputTF.delegate     = self;
        
        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
    
        self.warningLabel.x      = LEFTSPACE *2;
        self.warningLabel.height = LEFTSPACE;
        self.warningLabel.width  = SCREENWIDTH - LEFTSPACE *2;
        self.warningLabel.y      = rect.origin.y + rect.size.height + LEFTSPACE;
        
        self.agreementButton.x      = LEFTSPACE *1.5;
        self.agreementButton.height = LEFTSPACE * 1.5;
        self.agreementButton.width  = SCREENWIDTH *0.6;
        self.agreementButton.y      = self.warningLabel.bottom + LEFTSPACE;
    
        self.nextBtn.height = SCREENWIDTH*ROWProportion;
        self.nextBtn.width  = SCREENWIDTH - LEFTSPACE * 2;
        self.nextBtn.x      = LEFTSPACE;
        self.nextBtn.y      = self.agreementButton.bottom + LEFTSPACE;
    }
 
    [cell.userInputTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return cell;
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

-(void)textFieldDidChange:(UITextField *)textField
{
    
    UITextField *termTF       = self.termTextField;
    UITextField *safetyCodeTF = self.safetyCodeTextField;
    UITextField *phoneNOTF    = self.phoneNoTextField;
    if (self.bankCardModel.cardType == 1) {
        
        if(phoneNOTF.text.length == 13 && self.agreementButton.isSelected) {
            self.nextBtn.enabled = YES;
            
        } else {
            
            self.nextBtn.enabled = NO;
        }
        
    } else {
    
       if (textField == safetyCodeTF) {
        
           if (safetyCodeTF.text.length > 3) {
            
            safetyCodeTF.text = [safetyCodeTF.text substringToIndex:3];
           }
       }
    
      if(termTF.text.length && safetyCodeTF.text.length == 3 && phoneNOTF.text.length == 13 && self.agreementButton.isSelected)
        
       {
        self.nextBtn.enabled = YES;
       } else {
    
        self.nextBtn.enabled = NO;
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            [self.view endEditing:YES];
            [self.view addSubview:self.datePickerView];
        }
    }
}

#pragma mark -AgreementButtonDelegate
-(void)protocolButtonTitleBtnDidClick:(YMProtocolButton *)agBtn
{
    ProtocolViewController *protocolVC = [[ProtocolViewController alloc]init];
    WEAK_SELF;
    protocolVC.block = ^(){
        weakSelf.agreementButton.selected = YES;
        [weakSelf protocolButtonImageBtnSelected:nil];
    };
    [self.navigationController pushViewController:protocolVC animated:YES];
    
}

-(void)protocolButtonImageBtnSelected:(YMProtocolButton *)agBtn
{
    
    if (self.bankCardModel.cardType == 1) {
        
        if( self.phoneNoTextField.text.length == 13 && self.agreementButton.isSelected) {
            
            self.nextBtn.enabled = YES;
            
        } else {
            
            self.nextBtn.enabled = NO;
        }
        
    } else {
        
        if(self.termTextField.text.length
           &&self.safetyCodeTextField.text.length == 3
           && self.phoneNoTextField.text.length == 13
           && self.agreementButton.isSelected) {
            
            self.nextBtn.enabled = YES;
            
        } else {
            
            self.nextBtn.enabled = NO;
        }
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNoTextField) {
        return [UITextField textFieldWithPhoneFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

@end
