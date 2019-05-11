//
//  ChangePayPwdViewController.m
//  WSYMPay
//
//  Created by MaKuiying on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ChangePayPwdViewController.h"
#import "ChangePayPwdNextViewController.h"
#import "VerificationView.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
@implementation ChangePayPwdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改支付密码";
    NSString *userName;
    
    if ([YMUserInfoTool shareInstance].custLogin.isValidateEmail) {
        self.leftTitle = @"邮箱";
        self.userNameTF.tag = 100;
         userName = [YMUserInfoTool shareInstance].custLogin;
        
    } else {
        userName = [YMUserInfoTool shareInstance].custLogin.MobilePhoneFormat;
    }
  
    self.userNameTF.text      = userName;
    self.userNameTF.enabled   = NO;
}

//发送验证码{
-(void)loadCerCode{
    
    [super loadCerCode];
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc]init];
    params.usrMp         = self.userNameTF.text.clearSpace;
    params.token         = currentInfo.token;
    params.service_type  = @"01";
    params.tranCode      = CHANGEMOBILEGETCODE;
    [MBProgressHUD showMessage:@"正在发送"];
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        [MBProgressHUD hideHUD];
        if (m.resCode == 1 || m.resCode == 36) {
            [self.verificationView createTimer];
            self.NotFirstLoad = YES;
        }
        
        [MBProgressHUD showText:m.resMsg];
    } failure:^(NSError *error) {}];
    
}
- (void)nextButtonDidClick
{
    [super nextButtonDidClick];

    RequestModel *params = [[RequestModel alloc]init];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    params.usrMp         = self.userNameTF.text.clearSpace;
    params.tranCode      = CHANGEMOBILEVVCODE;
    params.token         = currentInfo.token;
    params.service_type  = @"01";
    params.randomCode    = [YMUserInfoTool shareInstance].randomCode;;
    params.validateCode  = self.verificationView.verificationCode;
    [MBProgressHUD showMessage:@"正在验证"];
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMLog(@"--%@",responseObject);
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (m.resCode == 1) {
            //判断获取验证码是否和输入一致－－－－－－－
            [self.verificationView timerInvalidate];
            ChangePayPwdNextViewController * nextVC = [[ChangePayPwdNextViewController alloc]init];
            [self.navigationController pushViewController:nextVC animated:YES];
            
        }else if (m.resCode == 37){
          [MBProgressHUD showText:@"请重新获取验证码"];
        } else {
            
            [MBProgressHUD showText:m.resMsg];
        }

    } failure:^(NSError *error) {}];
    

}

@end
