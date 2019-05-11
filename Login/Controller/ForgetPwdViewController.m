//
//  ResetPwdViewController.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "ForgetPwdNextViewController.h"
#import "YMRedBackgroundButton.h"
#import "YMResponseModel.h"
#import "YMUserInfoTool.h"
@interface ForgetPwdViewController ()
{
    UITextField              * userNameTF;
    UITextField              * verCodeTF;
    UIButton                 * verCodeButton;
    YMRedBackgroundButton    * nextButton;
    NSTimer                  * timer;
    NSString                 * verCodeStr;
    NSString                 *_lastUserName;
    int countDown;
    
}

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.title = @"忘记密码";
    [self initViews];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.userName.length) {
     userNameTF.text = self.userName;   
    }
        
    if ([self.userName isEqualToString:_lastUserName] && [timer isValid] && timer && verCodeTF.text.length == 0) {
        [MBProgressHUD showText:MSG2];
        
    } else {
        verCodeButton.enabled = YES;
        [timer invalidate];
    }
        
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [WSYMNSNotification removeObserver:self];
    
    
}
-(void)initViews
{
    UIView * allViews = [UIView new];
    allViews.layer.borderWidth = 1.0;
    allViews.layer.borderColor = LAYERCOLOR.CGColor;
    allViews.layer.cornerRadius = CORNERRADIUS;
    allViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:allViews];
    [allViews mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.offset(LEFTSPACE);
        make.height.equalTo(allViews.mas_width).multipliedBy(0.267);
        
    }];
    
    UITextField * userName = [UITextField new];
    userNameTF = userName;
    userName.placeholder  = @"请输入手机号";
    userName.borderStyle  = UITextBorderStyleNone;
    userName.font         = COMMON_FONT;
    userName.keyboardType = UIKeyboardTypeNumberPad;    
    userName.delegate     = self;
    userName.tag          = 10001;
    [WSYMNSNotification addObserver:self selector:@selector(textFieldChangeds:) name:UITextFieldTextDidChangeNotification object:userNameTF];
    UIImage * userIcon = [UIImage imageNamed:@"user2"];
    UIImageView * userIconView = [UIImageView new];
    userIconView.frame = CGRectMake(0, 0, 26, 29);
    userIconView.image = userIcon;
    userIconView.contentMode = UIViewContentModeCenter;
    userName.leftViewMode = UITextFieldViewModeAlways;
    userName.leftView = userIconView;
    userName.backgroundColor = [UIColor clearColor];
    [allViews addSubview:userName];

    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.equalTo(allViews.mas_bottom).multipliedBy(0.5);
    }];
    
    
    UIImageView * lineImg = [UIImageView new];
    lineImg.backgroundColor = LAYERCOLOR;
    [self.view addSubview:lineImg];
    [allViews addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(0);
        make.centerY.equalTo(allViews.mas_centerY);
        make.height.offset(1);
    }];
    
    UITextField * verCode = [UITextField new];
    verCode.placeholder   = @"请输入验证码";
    verCodeTF             = verCode;
    verCode.font          = COMMON_FONT;
    verCode.borderStyle   = UITextBorderStyleNone;
    verCode.keyboardType  = UIKeyboardTypeNumberPad;
    verCode.tag           = 10002;
    [allViews addSubview:verCode];
    verCode.delegate      = self;
    UIImage * verCodeIcon = [UIImage imageNamed:@"verification"];
    UIImageView * verCodeIconView = [UIImageView new];
    verCodeIconView.frame = CGRectMake(0, 0, 26, 29);
    verCodeIconView.image = verCodeIcon;
    verCodeIconView.contentMode = UIViewContentModeCenter;
    verCode.leftViewMode = UITextFieldViewModeAlways;
    verCode.leftView = verCodeIconView;
    verCode.backgroundColor = [UIColor whiteColor];
    [WSYMNSNotification addObserver:self selector:@selector(textFieldChangeds:) name:UITextFieldTextDidChangeNotification object:verCode];
    [verCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(0);
        make.top.equalTo(lineImg.mas_bottom);
        make.bottom.offset(0);
    }];
    
    UIButton * verCodeBtn = [UIButton new];
    verCodeButton = verCodeBtn;
    [allViews addSubview:verCodeBtn];
    [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [verCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [verCodeBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code_selected"] forState:UIControlStateNormal];
    [verCodeBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code"] forState:UIControlStateDisabled];
    [verCodeBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code"] forState:UIControlStateHighlighted];
    [verCodeBtn setTitleColor:RGBColor(222, 81, 78) forState:UIControlStateNormal];
    verCodeBtn.titleLabel.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:12]];
    [verCodeBtn addTarget:self action:@selector(loadCerCode:) forControlEvents:UIControlEventTouchUpInside];
    [verCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.offset(-12);
        make.bottom.offset(-5);
        make.top.equalTo(lineImg.mas_bottom).offset(5);
        make.width.equalTo(allViews.mas_width).multipliedBy(0.3);
    }];
    
    YMRedBackgroundButton * nextBtn = [YMRedBackgroundButton new];
    nextButton = nextBtn;
    nextBtn.enabled = NO;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = CORNERRADIUS;
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(allViews.mas_bottom).offset(30);
        make.height.equalTo(nextBtn.mas_width).multipliedBy(0.144);
    }];
    
    
}

-(void)next:(UIButton *)sender
{
    if (verCodeTF.text.length == 0) {
        [MBProgressHUD showText:@"请输入验证码"];
        return;
    }
    [self checkVerifyCode];
    
}
-(void)textFieldChangeds:(NSNotification *) note
{
    UITextField * textF =  note.object;
    
    if (textF == userNameTF) {
        if ( textF.text.length > 0 && verCodeTF.text.length == 6) {
            nextButton.enabled = YES;
        }else
        {
            nextButton.enabled = NO;
        }
    } else {
    
        if (textF.text.length == 6 && userNameTF.text.length > 0) {
            
            nextButton.enabled = YES;
        } else {
            nextButton.enabled = NO;
        }
        
    
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
     if (textField.tag == 10001){
        
        NSString* toStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toStr.length == 21) {
            return NO;
        }
     } else if (textField.tag == 10002) {
         
         NSString* toStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
         if (toStr.length == 7) {
             return NO;
         }
     }
    
    return YES;
         

}

- (void)getVerifyCode{
    
    RequestModel *params = [[RequestModel alloc]init];
    params.custLogin     = userNameTF.text;
    params.tranCode      = FORGETPWDGETVCODE;
    params.service_type  = @"02";
    [MBProgressHUD show];
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1 || m.resCode == 36) {
            _lastUserName = userNameTF.text;
            [MBProgressHUD showText:m.resMsg];
            [self createTime];
            
        } else {
            
            [MBProgressHUD showText:m.resMsg];
            
        }
        
    } failure:^(NSError *error) {}];
    
}

- (void)checkVerifyCode{
    
    RequestModel *params = [[RequestModel alloc]init];
    params.custLogin     = userNameTF.text;
    params.validateCode  = verCodeTF.text;
    params.tranCode      = FORGETPWDVVCODE;
    params.randomCode    = [YMUserInfoTool shareInstance].randomCode;
    params.service_type  = @"02";
    [MBProgressHUD show];
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (m.resCode == 1 ) {
            RequestModel *nextParams             = [[RequestModel alloc]init];
            nextParams.custLogin                 = userNameTF.text;
            nextParams.randomCode                = [YMUserInfoTool shareInstance].randomCode;
            ForgetPwdNextViewController * nextVC = [ForgetPwdNextViewController new];
            nextVC.params                        = nextParams;
            [self.navigationController pushViewController:nextVC animated:YES];
        } else {
            [MBProgressHUD showText:responseObject[@"resMsg"]];
        }
        
    } failure:^(NSError *error) {[MBProgressHUD hideHUD];}];
    
}

-(void)loadCerCode:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    NSString * userName = userNameTF.text;

    //账户名为手机号 //账户名为邮箱时
        if (userName.isValidateMobile) {
            [self getVerifyCode];
        } else {
        [MBProgressHUD showText:@"请输入正确的手机号"];
    }
}
-(void)createTime
{
    verCodeButton.enabled = NO;
    countDown = 60;
    NSString * str = [NSString stringWithFormat:@"%ds后重发",countDown];
    [verCodeButton setTitle:str forState:UIControlStateDisabled];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCountDown:) userInfo:nil repeats:YES];

}

-(void)timeCountDown:(NSTimer *)time
{
    if (countDown < 0) {
        [timer invalidate];
        timer = nil;
        verCodeButton.enabled = YES;
        return;
    }
    NSString * str = [NSString stringWithFormat:@"%ds后重发",countDown];
    [verCodeButton setTitle:str forState:UIControlStateDisabled];
    countDown = countDown - 1;
    
}


@end
