//
//  YMVerifyBankCardViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/4/7.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMVerifyBankCardViewController.h"
#import "YMGetUserInputCell.h"
#import "YMRedBackgroundButton.h"
#import "YMProtocolButton.h"
#import "ProtocolViewController.h"
#import "YMBankCardModel.h"
#import "YMMyHttpRequestApi.h"
#import "UITextField+Extension.h"
#import "YMUserInfoTool.h"
#import "YMVerifyBankCardGetCodeController.h"
#import "VerificationView.h"
#import "DatePickerView.h"
#import "RequestModel.h"
#import "LKDBHelper.h"
#import "YMVerifyBankCardDataModel.h"
@interface YMVerifyBankCardViewController ()<YMProtocolButtonDelegate,YMGetUserInputCellDelegate>

@property (nonatomic, weak) YMRedBackgroundButton *nextBtn;
@property (nonatomic, weak) YMProtocolButton *agreementButton;
@property (nonatomic, weak) UILabel     *warningLabel;
@property (nonatomic, weak) UITextField *phoneNoTF,*termTF,*safetyCodeTF;
@property (nonatomic, strong) YMVerifyBankCardGetCodeController *vCodeVC;
@property (nonatomic, strong) DatePickerView *datePickerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) LKDBHelper *listDB;
@end

@implementation YMVerifyBankCardViewController

#pragma mark - lifeCycle                    - Method -
#pragma mark - 生命
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self initDB];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationItem];
}

#pragma mark - privateMethods               - Method -
-(void)setupNavigationItem
{
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTouchUp)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)setupSubviews
{
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"验证银行卡";
    
    self.fromXinYongCardPay = NO;
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, LEFTSPACE, 0, 0)];

    self.tableView.tableFooterView = self.footerView;
    
    //注册按钮
    YMRedBackgroundButton*nextBtn = [[YMRedBackgroundButton alloc]init];
    nextBtn.enabled               = NO;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UILabel *warningLabel  = [[UILabel alloc]init];
    warningLabel.text      = @"信息加密处理,仅用于银行验证";
    warningLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:12]];
    warningLabel.textColor = RGBColor(150, 150, 150);
    [self.footerView addSubview:warningLabel];
    self.warningLabel = warningLabel;
    
    //协议按钮
    YMProtocolButton *agreementButton = [[YMProtocolButton alloc]init];
    agreementButton.delegate         = self;
    agreementButton.selected         = YES;
    agreementButton.title            = @"同意《网上有名服务协议》";
    [self.footerView addSubview:agreementButton];
    self.agreementButton = agreementButton;
    
    [warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-LEFTSPACE);
        make.top.mas_equalTo(SCALEZOOM(18/2));
        make.height.mas_equalTo(SCALEZOOM(38/2));
    }];
    
    [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-LEFTSPACE);
        make.top.mas_equalTo(warningLabel.mas_bottom).offset(SCALEZOOM(10/2));
        make.height.mas_equalTo(SCALEZOOM(38/2));
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-LEFTSPACE);
        make.top.mas_equalTo(agreementButton.mas_bottom).offset(SCALEZOOM(30/2));
        make.height.mas_equalTo(SCALEZOOM(80/2));
    }];
}
-(NSString *)setSecurityText:(NSString *)str
{
    NSString *str1 = [str substringToIndex:4];
    NSString *str2 = [str substringFromIndex:14];
    return [[str1 stringByAppendingString:@"********"]stringByAppendingString:str2];
}

-(void)setNextBtnEnabled
{
    if (self.bankCardModel.getCardTypeCount == 1) {
        
        if(self.phoneNoTF.text.length == 13 && self.agreementButton.isSelected) {
            self.nextBtn.enabled = YES;
            
        } else {
            
            self.nextBtn.enabled = NO;
        }
        
    }else if (self.bankCardModel.getCardTypeCount == 2) {
        if(self.phoneNoTF.text.length == 13 && self.agreementButton.isSelected && self.termTF.text && self.safetyCodeTF.text.length >= 2)
            
        {
            self.nextBtn.enabled = YES;
        } else {
            
            self.nextBtn.enabled = NO;
        }
    }
    
}

#pragma mark - eventResponse                - Method -
- (void)backBtnTouchUp
{
    self.payCashierView.hidden = NO;
    self.payCardListView.hidden = NO;
    self.payCashierView.backgroundColor = RGBAlphaColor(13, 13, 13, 0.5);
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)nextBtnClick
{
    [self.view endEditing:YES];
    NSString *phoneNO = self.phoneNoTF.text.clearSpace;
    
    if (!phoneNO.isValidateMobile) {
        [MBProgressHUD showText:@"请输入正确的手机号"];
        return;
    }
    
    if (self.bankCardModel.getCardTypeCount == 2) {
        
        if (!self.termTF.text.length) {
            [MBProgressHUD showText:@"请输入信用卡有效期"];
            return;
        }
        
        if (!self.safetyCodeTF.text.length) {
            [MBProgressHUD showText:@"请输入安全码"];
            return;
        }
        
        self.bankCardModel.cardDeadline = self.termTF.text;
        self.bankCardModel.safetyCode   = self.safetyCodeTF.text;
    }
    
    if (_fromXinYongCardPay) {//将安全码存入本地数据库中。。。
        [self saveDB];
        [self.payCardListView removeFromSuperview];
        [self backBtnTouchUp];
    }else{
        RequestModel *paramers  = [[RequestModel alloc]init];
        paramers.token          = [YMUserInfoTool shareInstance].token;
        paramers.cardType       = [NSString stringWithFormat:@"0%ld",(long)self.bankCardModel.cardType];
        paramers.bankPreMobile  = phoneNO;
        paramers.cardDeadline   = self.termTF.text;
        paramers.safetyCode     = self.safetyCodeTF.text;
        paramers.reAuthBankCard = @"01";
        
        WEAK_SELF;
        [YMMyHttpRequestApi loadHttpRequestWithGetBankVCode:paramers success:^(NSInteger resCode, NSString *resMsg, NSDictionary *data) {
            if (resCode == 1) {
                [weakSelf.vCodeVC.verificationView createTimer];
            }
            [MBProgressHUD showText:resMsg];
            weakSelf.bankCardModel.randomCode    = [YMUserInfoTool shareInstance].randomCode;
            weakSelf.bankCardModel.bankPreMobile = phoneNO;
            weakSelf.vCodeVC.bankCardModel       = weakSelf.bankCardModel;
            [weakSelf.navigationController pushViewController:self.vCodeVC animated:YES];
        }];
    }
}

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)textFieldWithAnQuanMa:(NSString *)str
{
    YMLog(@"%@",str);
    self.safetyCodeTF.text = str;
    [self setNextBtnEnabled];
}
- (void)textFieldWithPhone:(NSString *)str
{
   YMLog(@"%@",str);
    self.phoneNoTF.text = str;
    [self setNextBtnEnabled];
}
#pragma mark -AgreementButtonDelegate
-(void)protocolButtonTitleBtnDidClick:(YMProtocolButton *)agBtn
{
    ProtocolViewController *protocolVC = [[ProtocolViewController alloc]init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}

-(void)protocolButtonImageBtnSelected:(YMProtocolButton *)agBtn
{
    [self setNextBtnEnabled];
}
#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.bankCardModel.getCardTypeCount == 1) {
        if (section == 0) {
            return 4;
        }else if (section == 1){
            return 0;
        }else{
            return 1;
        }
    }else{
        if (section == 0) {
            return 2;
        }else if (section == 1){
            return 3;
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"YMGetUserInputCell";
    YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[YMGetUserInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    [cell sendBankCardWithSection:indexPath.section row:indexPath.row model:self.bankCardModel];
    
    if(self.bankCardModel.getCardTypeCount == 2){
        if (indexPath.section == 1 && indexPath.row == 1) {
            self.termTF = cell.userInputTF;
        }else if (indexPath.section == 1 && indexPath.row == 2){
            self.safetyCodeTF = cell.userInputTF;
        }
    }
    if (indexPath.section == 2){
        self.phoneNoTF = cell.userInputTF;
    }
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return HEADERSECTIONVIEW_HEIGHT;
    }else{
        return HEADERSECTION_HEIGHT;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEADERSECTIONVIEW_HEIGHT)];
        headView.backgroundColor = VIEWGRAYCOLOR;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFTSPACE, 0, SCREENWIDTH-LEFTSPACE*2,headView.height)];
        label.textColor = FONTCOLOR;
        label.font = [UIFont systemFontOfMutableSize:13];
        [headView addSubview:label];
        if (self.bankCardModel.getCardTypeCount==1) {
            label.text = @"您的储蓄卡信息已过期，请重新认证";
        }else{
            label.text = @"您的信用卡信息已过期，请重新认证";
        }
        return headView;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bankCardModel.getCardTypeCount == 1) {
        
    }else if(self.bankCardModel.getCardTypeCount == 2){
        if (indexPath.section == 1) {
            if (indexPath.row == 1) {
                [self.view endEditing:YES];
                [self.datePickerView removeFromSuperview];
                self.datePickerView = nil;
                [self.view addSubview:self.datePickerView];
                self.tableView.scrollEnabled = NO;
            }
        }
    }
}
#pragma mark - getters and setters          - Method -
#pragma mark - 懒加载
-(YMVerifyBankCardGetCodeController *)vCodeVC
{
    if (!_vCodeVC) {
        _vCodeVC = [[YMVerifyBankCardGetCodeController alloc]init];
    }
    return _vCodeVC;
}

-(DatePickerView *)datePickerView
{
    if (!_datePickerView) {
        __weak typeof(self) weakSelf = self;
        _datePickerView = [[DatePickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.datePickerView strYearMonth:^(NSString *strTM) {
            YMLog(@"选中的值---%@",strTM);
            weakSelf.termTF.text = strTM;
            weakSelf.tableView.scrollEnabled = YES;
        }];
    }
    return _datePickerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCALEZOOM(240/2))];
        _footerView.backgroundColor = VIEWGRAYCOLOR;
    }
    return _footerView;
}
- (void)setBankCardModel:(YMBankCardModel *)bankCardModel
{
    _bankCardModel = bankCardModel;
    if (_bankCardModel == nil) {
        return;
    }
    [self.tableView reloadData];
}
- (void)setFromXinYongCardPay:(BOOL)fromXinYongCardPay
{
    _fromXinYongCardPay = fromXinYongCardPay;
    if (_fromXinYongCardPay) {
        [self.nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}
- (void)setPayCashierView:(UIView *)payCashierView
{
    _payCashierView = payCashierView;
    [self.tableView reloadData];
}
- (void)setPayCardListView:(UIView *)payCardListView
{
    _payCardListView = payCardListView;
    [self.tableView reloadData];
}
#pragma mark - 数据库相关
- (void)initDB
{
    self.listDB = [YMVerifyBankCardDataModel getUsingLKDBHelper];
    YMLog(@"create table sql :\n%@\n",[YMVerifyBankCardDataModel getCreateTableSQL]);
}
//存入数据库
- (void)saveDB
{
    //清空表数据
    [LKDBHelper clearTableData:[YMVerifyBankCardDataModel class]];
    YMVerifyBankCardDataModel *model = [[YMVerifyBankCardDataModel alloc] init];
    model.paySingKey = self.bankCardModel.getPaySignStr;
    model.safetyCode = self.bankCardModel.safetyCode;
    [model saveToDB];
}

@end
