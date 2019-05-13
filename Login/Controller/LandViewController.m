//
//  LandViewController.m
//  01_登陆页面
//
//  Created by MaKuiying on 16/9/14.
//  Copyright © 2016年 hope. All rights reserved.
//

#import "LandViewController.h"
#import "ForgetPwdViewController.h"
#import "RegisterViewController.h"
#import "DKTextField.h"
#import "MyViewController.h"
#import "YMRedBackgroundButton.h"
#import "YMUserInfoTool.h"
#import <MJExtension.h>
#import "YMResponseModel.h"
#import "BPush.h"
#import "MyTabBarController.h"

#define LoginMSG1 @"该账户不存在"
#define LoginMSG2 @"密码错误,还可以输入4次"
#define LoginMSG3 @"登录密码多次输入错误，账户已锁定，请3小时以后再试"


@interface LandViewController ()<UITextFieldDelegate,UIAlertViewDelegate>{
 
    ForgetPwdViewController * pwdVC;
    DKTextField             * passwdTextField;
    UITextField             * usernameTextField;
    YMRedBackgroundButton   * loginBtn;
    UIBarButtonItem         * _buttonItem;

}

@end

@implementation LandViewController

- (instancetype)init{
    
    if (self = [super init ]) {
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [self getNavigationImageView].hidden = YES;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"loginback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self getNavigationImageView].hidden = NO;
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:NAVIGATIONBARCOLOR];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatBarButton];
    //控件
    [self initView];

}

- (void)setLoginName:(NSString *)loginName {
    
    _loginName = loginName;
    usernameTextField.text = loginName;
}
//返回
- (void)creatBarButton{
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"loginback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
     self.navigationItem.leftBarButtonItem = leftItem;
    
    
}
- (void)initView{

    //有名图标
    UIImageView* icnoImageV = [UIImageView new];
    [self.view addSubview:icnoImageV];
    icnoImageV.image    = [UIImage imageNamed:@"logo"];
    
    [icnoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.offset(43);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.125);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.52);
    }];
    
    CGFloat height = ((double)ROWProportion)*SCREENWIDTH;
    //手机号
    usernameTextField                 = [UITextField new];
    usernameTextField.backgroundColor = [UIColor clearColor];
    usernameTextField.delegate        = self;
    usernameTextField.tag             = 73;
    [WSYMNSNotification addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:usernameTextField];
    usernameTextField.font                     = COMMON_FONT;
    usernameTextField.keyboardType             = UIKeyboardTypeNumberPad;
    usernameTextField.autocapitalizationType   = UITextAutocapitalizationTypeNone;//取消自动大写
    usernameTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
    usernameTextField.borderStyle              = UITextBorderStyleNone;
    usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    usernameTextField.textColor                = [UIColor blackColor];
    usernameTextField.placeholder              = @"请输入手机号";
    [usernameTextField setValue:COMMON_FONT forKeyPath:@"_placeholderLabel.font"];
    usernameTextField.text = @"";
    usernameTextField.leftViewMode       = UITextFieldViewModeAlways;
    usernameTextField.rightViewMode      = UITextFieldViewModeAlways;
    usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameTextField.returnKeyType      = UIReturnKeyDone;
    [self.view addSubview:usernameTextField];
    [usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE-5);
        make.width.equalTo(self.view.mas_width).multipliedBy(.93);
        make.height.offset(height);
        make.top.equalTo(icnoImageV.mas_bottom).offset(SCREENWIDTH*0.15);
    }];
    
    UIImageView* userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, height, (height-12)*0.7)];
    userImageView.image        = [UIImage imageNamed:@"user"];
    userImageView.contentMode  = UIViewContentModeScaleAspectFit;
    usernameTextField.leftView = userImageView;
    UILabel* line1             = [UILabel new];
    line1.backgroundColor      = LAYERCOLOR;
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.equalTo(usernameTextField.mas_left).offset(height);
        make.right.equalTo(usernameTextField.mas_right);
        make.top.equalTo(usernameTextField.mas_bottom);
    }];
    //密码
    passwdTextField = [DKTextField new];
    [self.view addSubview:passwdTextField];
    [passwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(usernameTextField);
        make.left.equalTo(usernameTextField);
        make.height.equalTo(usernameTextField);
        make.top.equalTo(usernameTextField.mas_bottom).offset(2);
    }];
    [passwdTextField setBackgroundColor:[UIColor clearColor]];
    passwdTextField.font         = COMMON_FONT;
    passwdTextField.keyboardType = UIKeyboardTypeDefault;
    [WSYMNSNotification addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:passwdTextField];
    passwdTextField.autocapitalizationType   = UITextAutocapitalizationTypeNone;//取消自动大写
    passwdTextField.borderStyle              = UITextBorderStyleNone;
    passwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwdTextField.textColor                = [UIColor blackColor];
    passwdTextField.placeholder              = @"请输入密码";
    [passwdTextField setValue:COMMON_FONT forKeyPath:@"_placeholderLabel.font"];
    passwdTextField.text                     = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginName"];
    passwdTextField.leftViewMode             = UITextFieldViewModeAlways;
    passwdTextField.autocorrectionType       = UITextAutocorrectionTypeNo;
    passwdTextField.returnKeyType            = UIReturnKeyDone;
    passwdTextField.secureTextEntry          = YES;
    passwdTextField.delegate                 = self;
    passwdTextField.tag                      = 74;
    UIImageView* keyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, height, (height-12)*0.7)];
    keyImageView.image = [UIImage imageNamed:@"password"];
    keyImageView.contentMode = UIViewContentModeScaleAspectFit;
    passwdTextField.leftView = keyImageView;
    UILabel* line2 = [UILabel new];
    line2.backgroundColor = LAYERCOLOR;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(line1);
        make.left.equalTo(passwdTextField.mas_left).offset(height);
        make.right.equalTo(passwdTextField.mas_right);
        make.top.equalTo(passwdTextField.mas_bottom);
    }];
    
    //眼睛图标
    UIButton * secuBtn = [UIButton new];
    [secuBtn addTarget:self action:@selector(secuBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secuBtn];
    [secuBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [secuBtn setBackgroundImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
    secuBtn.selected = NO;
    [secuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.equalTo(passwdTextField.mas_centerY);
        make.width.equalTo(passwdTextField.mas_height).multipliedBy(0.5);
        make.height.equalTo(secuBtn.mas_width).multipliedBy(0.8);
        
    }];

    //登陆按钮
    loginBtn         = [YMRedBackgroundButton new];
    loginBtn.enabled = NO;
    [loginBtn  setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn  addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(passwdTextField.mas_bottom).offset(40);
        make.height.offset(SCREENWIDTH*ROWProportion);
    }];
 
    //忘记密码
    UIButton* editPwdLabel              = [UIButton new];
    editPwdLabel.backgroundColor        = [UIColor clearColor];
    editPwdLabel.titleLabel.font        = COMMON_FONT;
    editPwdLabel.userInteractionEnabled = YES;
    editPwdLabel.alpha                  = 1;
    [editPwdLabel setTitle:@"忘记密码" forState:UIControlStateNormal];
    [editPwdLabel setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    [editPwdLabel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [editPwdLabel addTarget:self action:@selector(editUserPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editPwdLabel];
    [editPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBtn.mas_left).offset(10);
        make.top.equalTo(loginBtn.mas_bottom).offset(2);
        make.height.offset(40);
    }];

    //注册
    UIButton*registerLabel               = [UIButton new];
    registerLabel.backgroundColor        = [UIColor clearColor];
    registerLabel.titleLabel.font        = COMMON_FONT;
    registerLabel.userInteractionEnabled = YES;
    [registerLabel setTitle:@"注册" forState:UIControlStateNormal];
    [registerLabel setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    [registerLabel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [registerLabel addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    registerLabel.alpha = 1;
    [self.view addSubview:registerLabel];
    [registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginBtn.mas_right).offset(-10);
        make.top.equalTo(editPwdLabel);
        make.height.equalTo(editPwdLabel);
    }];
    
    //客服电话
    UILabel*tel                = [UILabel new];
    tel.backgroundColor        = [UIColor clearColor];
    tel.font                   = COMMON_FONT;
    tel.text                   = @"客服电话 : 4000-191-077";
    tel.alpha                  = 1;
    tel.userInteractionEnabled = YES;
    tel.textColor              = FONTCOLOR;
    [self.view addSubview:tel];
    
    [tel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.offset(-5);
        make.height.equalTo(editPwdLabel);
    }];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [tel addGestureRecognizer:tap];
}

-(void)textFieldChanged:(NSNotification *) note
{
    UITextField * textF    =  note.object;
    NSString * userContent = usernameTextField.text;
    NSString * passContent = passwdTextField.text;

    if (textF == usernameTextField) {
        if (passContent.length > 0 && userContent.length >0) {
            loginBtn.enabled = YES;

        }else{
            loginBtn.enabled = NO;
        }
    }else if (textF == passwdTextField){
        if (passContent.length > 0 && userContent.length >0) {
            
            loginBtn.enabled = YES;
            
        }else{
            loginBtn.enabled = NO;
        }
    }
}

//dismiss
- (void)backBtnAction{
    NSLog(@"返回");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)secuBtnTouchUp:(UIButton*)sender{
    
    if (sender.selected) {
        passwdTextField.secureTextEntry = YES;
    }else
    {
        passwdTextField.secureTextEntry = NO;
    }
    sender.selected = !sender.selected;
}

//登陆按钮
- (void)userLogin{
    NSLog(@"登录");
    [self hideKeyboard];
    
    if (!usernameTextField.text.isValidateMobile) {
        [MBProgressHUD showText:@"请输入正确的手机号"];
    }
    
    [MBProgressHUD showMessage:@"正在登录..."];
    RequestModel *params   = [[RequestModel alloc]init];
    params.custLogin       = usernameTextField.text;
    params.custPwd         = passwdTextField.text;
    params.tranCode        = LOGIN;
    
    YMUserInfoTool *currentUserInfo = [YMUserInfoTool shareInstance];
    
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {

            currentUserInfo.responseModel = m;
            
            [currentUserInfo saveUserInfoToSanbox];
            
            [currentUserInfo refreshUserInfo];
            [MBProgressHUD showText:@"登录成功"];
            YMLog(@"jj:%@",currentUserInfo.custLogin);
            
            NSArray *his = GET_NSUSERDEFAULT(@"LOGIN_HIS");
            if (!his) {
                NSArray *loginHis = @[currentUserInfo.usrMobile];
                SET_NSUSERDEFAULT(@"LOGIN_HIS", loginHis);
            }else {
                if (![his containsObject:currentUserInfo.usrMobile]) {
                    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:his];
                    [arr addObject:currentUserInfo.usrMobile];
                    SET_NSUSERDEFAULT(@"LOGIN_HIS", arr);
                }
            }
    
            MyTabBarController * tab = (MyTabBarController *)KEYWINDOW.rootViewController;
            tab.selectedIndex = 0;
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self bindBPushAndDevice];
        } else {
        
            [MBProgressHUD showText:m.resMsg];
        }
    } failure:^(NSError *error) {}];
    
}

-(void)bindBPushAndDevice
{
    YMUserInfoTool * userInfo = [YMUserInfoTool shareInstance];
    NSString * channelidIMEI = [BPush getChannelId];
    if (channelidIMEI.length == 0) {
        channelidIMEI = @"";
    }
    NSDictionary * paramDic = @{
                                    @"token":userInfo.token,
                                    @"tranCode":BPUSHCODE,
                                    @"channelidIMEI":channelidIMEI,
                                    @"deviceType":@"4",
                                
                                    };
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:paramDic success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            
        
            
        } else {
//            [self bindBPushAndDevice];
            
        }
    } failure:^(NSError *error) {
    
    }];
    
}
//忘记密码
- (void)editUserPwd{
    
    if (!pwdVC) {
        ForgetPwdViewController * vc = [[ForgetPwdViewController alloc] init];
        pwdVC = vc;
    }
    
    if (usernameTextField.text.isValidateMobile || usernameTextField.text.isPasswordFormat) {
        pwdVC.userName = usernameTextField.text;
    }
    [self.navigationController pushViewController:pwdVC animated:YES];
}

- (void)registerUser{
    YMLog(@"注册");
    //注册VC
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}



#pragma mark- 检测信息
-(NSString*)checkInput{
    NSString *userNameStr = usernameTextField.text;//用户名
    NSString *userPwdStr  = passwdTextField.text;//密码
    NSString* msg=nil;
    
    if (userNameStr==nil||userNameStr.length==0) {
        msg = @"用户名不能为空";
    }else if (userPwdStr==nil||userPwdStr.length==0) {
        msg= @"密码不能为空";
    }
    return msg;
    
}


- (void)tapAction{
    [self showAlertView:nil message:@"4000-191-077" cancelBtn:@"取消" otherBtn:@"确定" delegate:self];
}

- (void)showAlertView:(NSString *)title message:(NSString *)message cancelBtn:(NSString *)btnTitle otherBtn:(NSString *)otherTitle delegate:(id)delegate
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:nil]];
    [alertControl addAction:[UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self makeCall];
            }]];
    [self presentViewController:alertControl animated:YES completion:nil];

}

- (void)makeCall
{
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4000191077"]];
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyboard];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField.tag == 73) {
    NSString* toStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toStr.length > 40) {
            return NO;
        }
    } else if (textField.tag == 74){
    
        NSString* toStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toStr.length == 21) {
            return NO;
        }
}
    
    return YES;
}

- (void)hideKeyboard {
    [usernameTextField resignFirstResponder];
    [passwdTextField resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

@end
