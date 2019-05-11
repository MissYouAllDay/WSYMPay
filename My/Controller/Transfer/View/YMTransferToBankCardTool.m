//
//  YMTransferToBankCardTool.m
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankCardTool.h"
#import "YMGetUserInputCell.h"
#import "YMRedBackgroundButton.h"
#import "UITextField+Extension.h"
#import "YMTransferToBankCheckBankDataModel.h"
#import "YMTransferRecentRecodeDataListModel.h"
#import "YMTransferToBankLimitDataModel.h"

@interface YMTransferToBankCardTool()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *limitButton;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) YMRedBackgroundButton *sureBtn;
@property (nonatomic, copy) NSString *tipsStr;
@property (nonatomic, copy) NSString *nameStr;//姓名
@property (nonatomic, copy) NSString *bankCardNumStr;//卡号
@property (nonatomic, copy) NSString *moneyStr;//金额
@property (nonatomic, copy) NSString *bankCardNameStr;//银行卡
@property (nonatomic, assign) BOOL isFocus;//是否是焦点

@end

@implementation YMTransferToBankCardTool

- (void)selectSureTransferBtnName:(NSString *)name bankCard:(NSString *)bankCard money:(NSString *)money{}
- (void)selectLimitBtn{}
- (void)checkBankCard:(NSString *)bankAcNo{}

#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithTableView
{
    self = [super init];
    if (self) {
        self.bankCardNameStr = @"";
        self.isFocus = NO;
    }
    return self;
}
#pragma mark - privateMethods               - Method -
- (void)checkBankAcNoMethod
{
    if (self.isFocus) {
        if (self.bankCardNumStr.length>0) {
            if ([self.delegate respondsToSelector:@selector(checkBankCard:)]) {
                [self.delegate checkBankCard:self.bankCardNumStr];
            }
        }
        self.isFocus = NO;
    }
}
#pragma mark - eventResponse                - Method -
- (void)limitButtonClick
{//限额说明
    [self.vc.view endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(selectLimitBtn)]) {
        [self.delegate selectLimitBtn];
    }
}

- (void)sureBtnClick
{//确认转账
    [self.vc.view endEditing:YES];
    YMLog(@"姓名=%@\n 卡号=%@\n 金额=%@",self.nameStr,self.bankCardNumStr,self.moneyStr);
    if ([self.delegate respondsToSelector:@selector(selectSureTransferBtnName:bankCard:money:)]) {
        [self.delegate selectSureTransferBtnName:self.nameStr bankCard:self.bankCardNumStr money:self.moneyStr];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    [self.vc.view endEditing:YES];
    [self checkBankAcNoMethod];
}
#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YMGetUserInputCell";
    YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[YMGetUserInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.leftTitle = @"姓名";
            cell.userInputTF.placeholder = @"收款人姓名";
            cell.userInputTF.text = self.nameStr;
            cell.userInputTF.keyboardType = UIKeyboardTypeNamePhonePad;
            cell.userInputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            cell.userInputTF.delegate = self;
            cell.userInputTF.tag = 202;
            return cell;
        }
            break;
        case 1:
        {
            cell.leftTitle = @"卡号";
            cell.userInputTF.placeholder = @"收款人储蓄卡号";
            cell.userInputTF.text = self.bankCardNumStr;
            cell.userInputTF.keyboardType = UIKeyboardTypeNumberPad;
            cell.userInputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            cell.userInputTF.delegate = self;
            cell.userInputTF.tag = 203;
            NSRange range = NSMakeRange(0, self.bankCardNumStr.length);
            [self textField:cell.userInputTF shouldChangeCharactersInRange:range replacementString:self.bankCardNumStr];
            
            return cell;
        }
            break;
        case 2:
        {
            cell.leftTitle = @"银行";
            cell.userInputTF.placeholder = @"";
            cell.userInputTF.text = self.bankCardNameStr;
            cell.userInputTF.enabled = NO;
            return cell;
        }
            break;
        case 3:
        {
            cell.leftTitle = @"金额";
            cell.userInputTF.placeholder = @"请输入金额";
            cell.userInputTF.keyboardType = UIKeyboardTypeDecimalPad;
            cell.userInputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            cell.userInputTF.delegate = self;
            cell.userInputTF.tag = 204;
            //限额说明暂时先屏蔽
//            cell.accessoryView = [self limitButton];
            return cell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERSECTION_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - UITextField的输入规则
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag != 203) {
        [self checkBankAcNoMethod];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 203) {
        self.isFocus = YES;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldEditChanged:textField];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    if (textField.tag == 203) {//卡号
         return [UITextField textFieldWithBankCardFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }else if (textField.tag == 204){//金额
        return [UITextField textFieldWithMoneyFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }else{
        return YES;
    }

}
- (void)textFieldEditChanged:(UITextField *)textField
{
    YMLog(@"----textField = %@",textField.text);
    switch (textField.tag) {
        case 202:
            self.nameStr = textField.text;
            break;
        case 203:
            self.bankCardNumStr = textField.text;
            break;
        case 204:
            self.moneyStr = textField.text;
            break;
        default:
            break;
    }
    if (_limitDataModel != nil) {
        if (self.nameStr.length>0&&self.bankCardNumStr.length>0&&self.moneyStr.length>0) {
            self.sureBtn.enabled = YES;
        }else{
            self.sureBtn.enabled = NO;
        }
    }
}

#pragma mark - getters and setters          - Method -
-(UIButton *)limitButton
{
    if (!_limitButton) {
        _limitButton = [[UIButton alloc] init];
        [_limitButton setTitle:@"限额说明" forState:UIControlStateNormal];
        [_limitButton setTitleColor:LoginButtonBackgroundColor forState:UIControlStateNormal];
        _limitButton.titleLabel.font = [UIFont systemFontOfMutableSize:12];
        [_limitButton addTarget:self action:@selector(limitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_limitButton sizeToFit];
    }
    return _limitButton;
}
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfMutableSize:12];
        _tipsLabel.textColor = FONTCOLOR;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        _tipsLabel.text = self.tipsStr;
        if (!([_tipsLabel.text isEmptyStr]||_tipsLabel.text == nil)) {
            [UILabel changeLineSpaceForLabel:_tipsLabel WithSpace:7];
            [self.tableView addSubview:_tipsLabel];
            
            CGSize size = [_tipsLabel sizeThatFits:CGSizeMake(SCREENWIDTH * 0.85, MAXFLOAT)];
            CGFloat f = SCREENWIDTH * ROWProportion;
            [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(4*f+HEADERSECTION_HEIGHT+20);
                make.width.mas_equalTo(size.width);
                make.height.mas_equalTo(size.height);
                make.centerX.equalTo(self.tableView.mas_centerX);
            }];        
        }
    }
    return _tipsLabel;
}

- (YMRedBackgroundButton *)sureBtn
{
    if (!_sureBtn) { //确认转账按钮
        _sureBtn = [[YMRedBackgroundButton alloc]init];
        _sureBtn.enabled = NO;
        [_sureBtn setTitle:@"确认转账" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:_sureBtn];
       
        CGFloat w = SCREENWIDTH * 0.9;
        CGFloat h = SCREENWIDTH * ROWProportion;
        CGFloat x = (SCREENWIDTH - w) /2;
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_tipsLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(x);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(h);
        }];
    }
    return _sureBtn;
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, SCREENWIDTH * 0.23, 0, 0)];
}

- (void)setVc:(UITableViewController *)vc
{
    _vc = vc;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_vc.view addGestureRecognizer:tap];
}

- (void)setCheckBankModel:(YMTransferToBankCheckBankDataModel *)checkBankModel
{
    _checkBankModel = checkBankModel;
    if (_checkBankModel == nil) {
        self.bankCardNameStr = @"";
        return;
    }
    self.bankCardNameStr = [_checkBankModel getBankNameStr];
    [self.tableView reloadData];
}

- (void)setFromDataListModel:(YMTransferRecentRecodeDataListModel *)fromDataListModel
{
    _fromDataListModel = fromDataListModel;
    if (_fromDataListModel == nil) {
        self.nameStr = @"";
        self.bankCardNumStr = @"";
        self.bankCardNameStr = @"";
        return;
    }
    self.nameStr = [_fromDataListModel getToAccNameStr];
    self.bankCardNumStr = [_fromDataListModel getToAccountsStr];
    self.bankCardNameStr = [_fromDataListModel getBankNameStr];
    [self.tableView reloadData];
}
- (void)setLimitDataModel:(YMTransferToBankLimitDataModel *)limitDataModel
{
    _limitDataModel = limitDataModel;
    if (_limitDataModel == nil) {
        return;
    }
    self.tipsStr = [_limitDataModel getLimitDescStr];
    [self tipsLabel];
    [self sureBtn];
    [self.tableView reloadData];
}
@end
