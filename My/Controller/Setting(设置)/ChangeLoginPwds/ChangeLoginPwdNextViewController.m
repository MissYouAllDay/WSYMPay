//
//  ForgetPwdNextViewController.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 16/9/18.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ChangeLoginPwdNextViewController.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
@interface ChangeLoginPwdNextViewController ()
{
    UITextField * pwdTF;
    UIButton * sureBtn;
    
}

@end

@implementation ChangeLoginPwdNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.title = @"修改登录密码";
    [self initViews];
}

-(void)initViews
{
    UITextField * pwdtf = [UITextField new];
    pwdTF = pwdtf;
    pwdtf.placeholder = @"请输入新的登录密码";
    pwdtf.layer.borderColor = LAYERCOLOR.CGColor;
    pwdtf.layer.borderWidth = 1.0;
    pwdtf.layer.cornerRadius = 0;
    pwdtf.borderStyle = UITextBorderStyleNone;
    pwdtf.secureTextEntry = YES;
    pwdtf.font = [UIFont systemFontOfMutableSize:14];
    pwdtf.keyboardType = UIKeyboardTypeDefault;
    pwdtf.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:pwdtf];
    UIImageView * userIconView = [UIImageView new];
    userIconView.frame = CGRectMake(0, 0, 30, 30);
    pwdtf.leftViewMode = UITextFieldViewModeAlways;
    pwdtf.leftView = userIconView;
    [self.view addSubview:pwdtf];
    
    [pwdtf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(LEFTSPACE);
        make.height.equalTo(pwdtf.mas_width).multipliedBy(0.145);
    }];
    
    UIButton * secuBtn = [UIButton new];
    [secuBtn addTarget:self action:@selector(secuBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secuBtn];
    [secuBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [secuBtn setBackgroundImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
    secuBtn.selected = NO;
    [secuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.equalTo(pwdtf.mas_centerY);
        make.width.equalTo(pwdtf.mas_height).multipliedBy(0.6);
        make.height.equalTo(secuBtn.mas_width).multipliedBy(0.8);
        
    }];
    
    

    UILabel * markL = [UILabel new];
    [self.view addSubview:markL];
    markL.font = [UIFont systemFontOfSize:DEFAULTFONT(12)];
    markL.backgroundColor = [UIColor clearColor];
    markL.textColor = [UIColor grayColor];
    markL.text = @"8-20位,数字、字母、特殊字符三种组合";
    
    [markL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE*2);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(pwdtf.mas_bottom).offset(10);
        make.height.offset(22);
    }];
    
    UIButton * nextBtn = [UIButton new];
    sureBtn = nextBtn;
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"register"] forState:UIControlStateDisabled];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
    nextBtn.enabled = NO;
    [nextBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    nextBtn.titleLabel.font = [UIFont systemFontOfMutableSize:14];
    nextBtn.layer.cornerRadius = CORNERRADIUS;
   
    [nextBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(markL.mas_bottom).offset(20);
        make.height.equalTo(nextBtn.mas_width).multipliedBy(0.144);
    }];

 
    
}


-(void)textFieldChanged:(NSNotification *) note
{
    UITextField * textF =  note.object;
    NSString * content = textF.text;
    if (textF == pwdTF) {
        if (content.length > 5) {
            sureBtn.enabled = YES;
            if (content.length > 20) {
                textF.text = [content substringToIndex:20];
            }
        }else
        {
            sureBtn.enabled = NO;
        }
    }
}
-(void)secuBtnTouchUp:(UIButton *)sender
{
    if (sender.selected) {
        pwdTF.secureTextEntry = YES;
    }else
    {
        pwdTF.secureTextEntry = NO;
    }
    sender.selected = !sender.selected;
    
}
-(void)sure:(UIButton *)sender
{
    
    NSString *pwd  =  pwdTF.text;
    if (!pwd.isPasswordFormat) {
        [MBProgressHUD showText:@"登录密码需8-20位数字、字母、特殊字符三种组合"];
        return;
    }

    RequestModel *params = [[RequestModel alloc]init];
    params.token          = [YMUserInfoTool shareInstance].token;
    params.randomCode     = [YMUserInfoTool shareInstance].randomCode;
    params.newCustPwd     = pwd;
    params.tranCode       = SETTINGLOGINPWD;
    [MBProgressHUD showMessage:@"正在设置新密码"];
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        [MBProgressHUD showText:m.resMsg];
        if (m.resCode == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
            });
        }
    } failure:^(NSError *error) {}];

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
