//
//  ViewController.m
//  网上有名
//
//  Created by W-Duxin on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "YMProtocolButton.h"
#import "VerificationViewController.h"
#import "PromptBoxView.h"
#import "ProtocolViewController.h"
#import "YMUserInfoTool.h"
#import "YMRedBackgroundButton.h"
#import "YMLocationTool.h"
#import "YMTextField.h"
#import "UITextField+Extension.h"
#import "VerificationView.h"
#import "ObtainUserIDFVTool.h"
#import "YMResponseModel.h"
#import "YMPublicHUD.h"

#define Interval 11

@interface RegisterViewController ()
<PromptBoxViewDelegate,
YMProtocolButtonDelegate,
UITextFieldDelegate,VerificationViewDelegate>

@property (nonatomic, weak)   YMTextField *userNmaeTF;

@property (nonatomic, weak)   YMTextField *passwordTF;
@property (nonatomic, weak)   YMTextField *surePasswordTF;
@property (nonatomic, weak)   YMTextField *userRealNameTF;
@property (nonatomic, weak)   YMTextField *userIdentityTF;
@property (nonatomic, weak)   YMTextField *identifyDateTF;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, weak)   VerificationView *verificationView;
@property (nonatomic, copy)   NSString         *verificationCode;

@property (nonatomic, weak)   UIButton *registerBtn;

@property (nonatomic, weak)   YMProtocolButton *agreementButton;
 
@property (nonatomic, copy)   NSString *currentCity;

@property (nonatomic, copy)   NSString *currentPhoneNum;
/**
 *  纬度
 */
@property (nonatomic, copy)   NSString *latitudeStr;
/**
 *  经度
 */
@property (nonatomic, copy)   NSString *longitudeStr;
//防止界面销毁
@property (nonatomic, strong) VerificationViewController *verificationVC;

@property (nonatomic, weak) UIButton *showPasswordButton;

@end

@implementation RegisterViewController


-(VerificationViewController *)verificationVC
{
    if (!_verificationVC) {
        
        _verificationVC = [[VerificationViewController alloc]init];
    }

    return _verificationVC;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupSubviews];
    //开始定位
    
    self.latitudeStr  = @"";
    self.longitudeStr = @"";
    self.currentCity  = @"";
    
    __weak typeof(self) weakSelf = self;
    [[YMLocationTool sharedInstance] startLocationWithFineLocation:^(NSString *location, NSString *latitude, NSString *longitude) {
        weakSelf.currentCity  = location;
        weakSelf.latitudeStr  = latitude;
        weakSelf.longitudeStr = longitude;
    } locationError:^(NSString *error) {
        weakSelf.currentCity  = @"定位失败";
    }];
}


-(void)setupSubviews
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //注册
    self.navigationItem.title            = @"注册";
    YMTextField *userNmaeTF = [[YMTextField alloc]init];
    userNmaeTF.leftTitle    = @"手机号";
    userNmaeTF.placeholder  = @"请输入手机号";
    userNmaeTF.keyboardType = UIKeyboardTypeNumberPad;
    userNmaeTF.delegate     = self;
    [userNmaeTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:userNmaeTF];
    self.userNmaeTF = userNmaeTF;
    
    //密码
    UIView *topLineView = [[UIView alloc]init];
    topLineView.backgroundColor = LAYERCOLOR;
    [self.view addSubview:topLineView];
    
    
    YMTextField *passwordTF = [[YMTextField alloc]init];
    passwordTF.leftTitle    = @"密    码";
    passwordTF.placeholder  = @"8-20位数字、字母、特殊字符三种组合";
    [passwordTF setValue:[UIFont systemFontOfMutableSize:11] forKeyPath:@"_placeholderLabel.font"];
    passwordTF.secureTextEntry = YES;
    [passwordTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordTF];
    self.passwordTF = passwordTF;
  
    
    UIButton *showPassWordButton = [[UIButton alloc]init];
    [showPassWordButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [showPassWordButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
    [showPassWordButton addTarget:self action:@selector(isPassWordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showPassWordButton];
    [showPassWordButton sizeToFit];
    self.showPasswordButton = showPassWordButton;
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = LAYERCOLOR;
    [self.view addSubview:bottomLineView];
    //确认密码
    YMTextField *surePasswordTF = [[YMTextField alloc]init];
    surePasswordTF.leftTitle    = @"确认密码";
    surePasswordTF.placeholder  = @"";
    [surePasswordTF setValue:[UIFont systemFontOfMutableSize:11] forKeyPath:@"_placeholderLabel.font"];
    surePasswordTF.secureTextEntry = YES;
    [surePasswordTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:surePasswordTF];
    self.surePasswordTF = surePasswordTF;
    
    UIView *bottomLineView1 = [[UIView alloc]init];
    bottomLineView1.backgroundColor = LAYERCOLOR;
    [self.view addSubview:bottomLineView1];
    
    //真实姓名
    YMTextField *realNameTF = [[YMTextField alloc]init];
    realNameTF.leftTitle    = @"真实姓名";
    realNameTF.placeholder  = @"";
    [realNameTF setValue:[UIFont systemFontOfMutableSize:11] forKeyPath:@"_placeholderLabel.font"];
//    realNameTF.secureTextEntry = YES;
//    [realNameTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:realNameTF];
    self.userRealNameTF = realNameTF;
    UIView *bottomLineView2 = [[UIView alloc]init];
    bottomLineView2.backgroundColor = LAYERCOLOR;
    [self.view addSubview:bottomLineView2];
    //身份证号码
    YMTextField *userIdtifityTF = [[YMTextField alloc]init];
    userIdtifityTF.leftTitle    = @"身份证号码";
    userIdtifityTF.placeholder  = @"";
    [userIdtifityTF setValue:[UIFont systemFontOfMutableSize:11] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:userIdtifityTF];
    self.userIdentityTF = userIdtifityTF;
    UIView *bottomLineView3 = [[UIView alloc]init];
    bottomLineView3.backgroundColor = LAYERCOLOR;
    [self.view addSubview:bottomLineView3];
    
    
    UILabel *identityDateLabel = [[UILabel alloc] init];
    identityDateLabel.text = @"证件有效期";
    identityDateLabel.font = [UIFont systemFontOfSize:16];
    identityDateLabel.textAlignment = NSTextAlignmentLeft;
    identityDateLabel.textColor = [UIColor grayColor];
    [self.view addSubview:identityDateLabel];
    //身份有效期
    UILabel *startLabel = [[UILabel alloc] init];
    startLabel.text = @"选择起始日期";
    startLabel.font = [UIFont systemFontOfSize:14];
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.textColor = [UIColor grayColor];
    startLabel.userInteractionEnabled = YES;
    [self.view addSubview:startLabel];
    self.startLabel = startLabel;
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.text = @"-";
    lineLabel.font = [UIFont systemFontOfSize:16];
    lineLabel.textAlignment = NSTextAlignmentCenter;
    lineLabel.textColor = [UIColor grayColor];
    [self.view addSubview:lineLabel];
    
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.text = @"选择截止日期";
    endLabel.font = [UIFont systemFontOfSize:14];
    endLabel.textAlignment = NSTextAlignmentCenter;
    endLabel.textColor = [UIColor grayColor];
    endLabel.userInteractionEnabled = YES;
    [self.view addSubview:endLabel];
    self.endLabel = endLabel;
    
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTapAction)];
    [startLabel addGestureRecognizer:startTap];
    UITapGestureRecognizer *endTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTapAction)];
    [endLabel addGestureRecognizer:endTap];
    
    UIView *bottomLineView4 = [[UIView alloc]init];
    bottomLineView4.backgroundColor = LAYERCOLOR;
    [self.view addSubview:bottomLineView4];
    
    VerificationView *verificationView = [[VerificationView alloc]init];
    verificationView.delegate          = self;
    [self.view addSubview:verificationView];
    self.verificationView              = verificationView;
    
    //分割线
    UIView *lineView5 = [[UIView alloc]init];
    lineView5.backgroundColor = LAYERCOLOR;
    [self.view  addSubview:lineView5];
    
    //协议按钮
    YMProtocolButton *agreementButton = [[YMProtocolButton alloc]init];
    agreementButton.delegate         = self;
    agreementButton.selected         = YES;
    agreementButton.title            = @"同意《网上有名服务协议》";
    [self.view addSubview:agreementButton];
    self.agreementButton = agreementButton;
    
    //注册按钮
    YMRedBackgroundButton*registerBtn = [[YMRedBackgroundButton alloc]init];
    registerBtn.enabled               = NO;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    self.registerBtn = registerBtn;
    
     CGFloat height = ((double)ROWProportion)*SCREENWIDTH;
    
    [userNmaeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(30);
        make.width.equalTo(self.view.mas_width).multipliedBy(.88);
        make.height.mas_equalTo(height);
    }];
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(userNmaeTF.mas_bottom);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat btnY = (self.view.width * 0.88) - showPassWordButton.width;
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNmaeTF.mas_left);
        make.top.equalTo(userNmaeTF.mas_bottom).offset(1);
        make.width.mas_equalTo(btnY);
        make.height.mas_equalTo(height);
    }];
    [showPassWordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordTF.mas_right);
        make.centerY.equalTo(passwordTF.mas_centerY);
    }];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(passwordTF.mas_bottom);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.height.mas_equalTo(1);
    }];
    
    [surePasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordTF.mas_left);
        make.top.equalTo(passwordTF.mas_bottom).offset(1);
        make.width.equalTo(self.view.mas_width).multipliedBy(.88);
        make.height.mas_equalTo(height);
    }];
    [bottomLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(surePasswordTF.mas_bottom);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.height.mas_equalTo(1);
    }];
    
    [realNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(surePasswordTF.mas_left);
        make.top.equalTo(surePasswordTF.mas_bottom).offset(1);
        make.width.equalTo(self.view.mas_width).multipliedBy(.88);
        make.height.mas_equalTo(height);
    }];
    [bottomLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(realNameTF.mas_bottom);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.height.mas_equalTo(1);
    }];
    
    [userIdtifityTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(realNameTF.mas_left);
        make.top.equalTo(realNameTF.mas_bottom).offset(1);
        make.width.equalTo(self.view.mas_width).multipliedBy(.88);
        make.height.mas_equalTo(height);
    }];
    [bottomLineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(userIdtifityTF.mas_bottom);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.height.mas_equalTo(1);
    }];
    
    [identityDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIdtifityTF.mas_left);
        make.top.equalTo(userIdtifityTF.mas_bottom).offset(1);
        make.width.equalTo(self.view.mas_width).multipliedBy(.88);
        make.height.mas_equalTo(height);
    }];
    [endLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(userIdtifityTF.mas_bottom).offset(1);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(height);
    }];
    [startLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(endLabel.mas_left).offset(-10);
        make.top.equalTo(userIdtifityTF.mas_bottom).offset(1);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(height);
    }];
    [lineLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startLabel.mas_right).offset(0);
        make.right.equalTo(endLabel.mas_left).offset(0);
        make.top.equalTo(userIdtifityTF.mas_bottom).offset(1);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(height);
    }];

    [bottomLineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(startLabel.mas_bottom);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.height.mas_equalTo(1);
    }];
    [verificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startLabel.mas_bottom).offset(1);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(height);
    }];
    [lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(verificationView.mas_bottom);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.height.mas_equalTo(1);
    }];
    
    [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE * 2);
        make.top.equalTo(verificationView.mas_bottom).with.offset(Interval);
        make.height.mas_equalTo(23);
        make.width.equalTo(self.view.mas_width).multipliedBy(.6);
    }];
    
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(agreementButton.mas_bottom).with.offset(Interval);
        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
    }];
}
- (void)startTapAction{
    __weak typeof(self) weakSelf = self;
    [CGXPickerView showDatePickerWithTitle:@"起始时间" DateType:UIDatePickerModeDate DefaultSelValue:[self getCurrentDateAndTime:@"yyyy-MM-dd"] MinDateStr:nil MaxDateStr:nil IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
        weakSelf.startLabel.text = selectValue;
    }];
}
- (void)endTapAction{
    __weak typeof(self) weakSelf = self;
    [CGXPickerView showDatePickerWithTitle:@"截止时间" DateType:UIDatePickerModeDate DefaultSelValue:[self getCurrentDateAndTime:@"yyyy-MM-dd"] MinDateStr:nil MaxDateStr:nil IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
        weakSelf.endLabel.text = selectValue;
    }];
}
#pragma mark -当前时间 yyyy-MM-dd HH:mm:ss
- (NSString *)getCurrentDateAndTime:(NSString *)type{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    return destDateString;
}
#pragma mark - VerificationViewDelegate
-(void)verificationViewTextDidEditingChange:(NSString *)text
{
    NSLog(@"text--------%@",text);
    self.verificationCode=text;

    if (text.length == 6) {
        
        self.registerBtn.enabled = YES;
    } else  if (text.length <= 5) {
        self.registerBtn.enabled = NO;
        
    }
}
-(void)verificationViewCountdownButtonDidClick:(VerificationView *)verificationView
{
    RequestModel *params         = [[RequestModel alloc]init];
  
    NSString *custlogin = [self.userNmaeTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!self.userNmaeTF.text.isValidateMobile) {
        [MBProgressHUD showText:@"请输入正确的手机号"];
        return;
    }
    params.custLogin             =  custlogin; //[custlogin decryptAESWithKey:AESKEYS];
    params.tranCode              = REGISTERGETVCODE;
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在发送..."];
    
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1 || m.resCode == 36) {
            [weakSelf.verificationView createTimer];
        }
        [MBProgressHUD showText:m.resMsg];
    } failure:^(NSError *error) {}];
}
//RegisterInputViewDelegate
-(void)textFieldTextDidChange:(UITextField *)textField
{
    
    if (self.passwordTF == textField) {
        
        if (textField.text.length > 20) {
            self.passwordTF.text = [textField.text substringToIndex:20];
        }
    }
  
    if (self.userNmaeTF.text.length >=11 && self.passwordTF.text.length >= 8 && self.agreementButton.selected&&self.surePasswordTF.text.length>=8&&self.userRealNameTF.text.length>0&&self.userIdentityTF.text.length>14&&self.startLabel.text.length>0&&self.endLabel.text.length>0&&self.verificationCode.length>=5) {
        self.registerBtn.enabled = YES;

    } else {
    
        self.registerBtn.enabled = NO;
    
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
    if (self.userNmaeTF.text.length >=13 && self.passwordTF.text.length >= 8 && self.agreementButton.selected) {
        
        self.registerBtn.enabled = YES;
    } else {
        
        self.registerBtn.enabled = NO;
        
    }

}

//注册
-(void)registerBtnClick
{
    [self.view endEditing:YES];
    /*
    1. 点击“注册”按钮，判断手机号是否已注册，已注册时,toast 提示
    2s文案“手机号已注册，请直接登录”
    2. 点击“注册”按钮，判断密码是否符合规范，,toast 提示
    2s“密码不能全是数字”；密码不能全为数字
    3. 点击“注册”按钮，检查是否勾选协议，未勾选toast 提示2s“勾选同意协议才可注册*/
    
    NSString *custlogin = [self.userNmaeTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    if([custlogin isEqualToString:self.verificationVC.params.custLogin]){
//
//        [self.navigationController pushViewController:self.verificationVC animated:YES];
//        return;
//    }
    

    if (!self.userNmaeTF.text.isValidateMobile) {
        
        [MBProgressHUD showText:@"请输入正确的手机号"];
        return;
    }
    if (self.userIdentityTF.text.length == 0 || [self.userIdentityTF.text isEqualToString:@""] || self.userIdentityTF.text == nil || self.userIdentityTF.text == NULL || [self.userIdentityTF.text isEqual:[NSNull null]]){
        [MBProgressHUD showText:@"请输入正确的手机号"];
        return;
    }
    if (!self.passwordTF.text.isPasswordFormat) {
        [MBProgressHUD showText:@"登录密码需8-20位数字、字母、特殊字符三种组合"];
        return;
    }
    if([self.passwordTF.text isEqualToString:self.surePasswordTF.text]) {
    }else {
        [MBProgressHUD showText:@"两次输入的密码不一致"];
        return;
    }
    if ([self.startLabel.text isEqualToString:@"选择起始日期"]) {
        [MBProgressHUD showText:@"请选择开始日期"];
        return;
    }
    if ([self.endLabel.text isEqualToString:@"选择截止日期"]) {
        [MBProgressHUD showText:@"选择截止日期"];
        return;
    }
    NSLog(@"%@",[self.startLabel.text stringByReplacingOccurrencesOfString:@"-"withString:@""]);//把指定的字符串替换成你想要的
    
    NSString *starttext =[self.startLabel.text stringByReplacingOccurrencesOfString:@"-"withString:@""];
    NSString *endtext =[self.endLabel.text stringByReplacingOccurrencesOfString:@"-"withString:@""];

    [MBProgressHUD showMessage:@"正在注册..."];
    RequestModel *params    = [[RequestModel alloc]init];
    params.custLogin        = custlogin;
    params.custPwd       = self.passwordTF.text;
    params.latitude      = self.latitudeStr;
    params.longitude     = self.longitudeStr;
    params.phoneAddress  = self.currentCity;
    params.custIdNo      = self.userIdentityTF.text;
    params.custName      = self.userRealNameTF.text;
//    params.tranCode         = REGISTERGETVCODE;
    params.validateCode   = self.verificationCode;
    params.tradeTerminal  = @"iOS";
//    params.macAddress     = @"";
    params.tranCode       = REGISTERUPLOADINFO;
    params.phoneModel     = @"";
    params.ipAddress      = @"";
    params.machineNum     = [ObtainUserIDFVTool getIDFV];
    params.macAddress = [[UIDevice currentDevice]identifierForVendor].UUIDString;
    
    params.idNoBegDate = starttext;
    params.idNoEndDate = endtext;
    
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (m.resCode == 1) {
            m.custLogin    = params.custLogin;
            m.usrStatus    = -1;
            m.payPwdStatus = -1;
            m.usrMobile    = params.custLogin;
            m.phoneAddress = params.phoneAddress;
            m.cashAcBal    = @"0.00";
            currentInfo.responseModel = m;
            [currentInfo saveUserInfoToSanbox];
            [currentInfo refreshUserInfo];
            [MBProgressHUD showText:@"注册成功"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else if(m.resCode == 83) {
            [YMPublicHUD showAlertView:nil message:m.resMsg cancelTitle:@"确定" handler:nil];
        } else {
            [MBProgressHUD showText:m.resMsg];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

-(void)isPassWordButtonClick
{
    self.showPasswordButton.selected = !self.showPasswordButton.isSelected;
    [self.passwordTF setSecureTextEntry:!self.showPasswordButton.selected];
    [self.passwordTF resignFirstResponder];
    
}
-(void)showPromptMessage
{
    PromptBoxView *promptBoxView = [[PromptBoxView alloc]init];
    promptBoxView.title = MSG9;
    promptBoxView.delegate = self;
    [promptBoxView show];
}

#pragma mark - PromptBoxViewDelegate
-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.userNmaeTF) {
        return [UITextField textFieldWithPhoneFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
  
}


@end
