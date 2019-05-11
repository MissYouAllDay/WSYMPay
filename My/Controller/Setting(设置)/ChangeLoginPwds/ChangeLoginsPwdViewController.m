//
//  ResetPwdViewController.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ChangeLoginsPwdViewController.h"
#import "ChangeLoginPwdNextViewController.h"
#import "VerificationView.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
@implementation ChangeLoginsPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"修改登录密码";
    NSString *userName;
    if ([YMUserInfoTool shareInstance].custLogin.isValidateEmail) {
        self.leftTitle = @"邮箱";
        self.userNameTF.tag = 100;
        userName = [YMUserInfoTool shareInstance].custLogin;
        
    } else {
        userName = [YMUserInfoTool shareInstance].custLogin.MobilePhoneFormat;
    }

    self.userNameTF.text       = userName;
    self.userNameTF.enabled    = NO;
}

-(void)nextButtonDidClick
{
    
    __weak typeof(self) weakSelf = self;
    RequestModel *params = [[RequestModel alloc]init];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    params.usrMp         = self.userNameTF.text.clearSpace;
    params.tranCode      = CHANGEMOBILEVVCODE;
    params.token         = currentInfo.token;
    params.service_type  = @"02";
    params.randomCode    = [YMUserInfoTool shareInstance].randomCode;;
    params.validateCode  = self.verificationView.verificationCode;
    [MBProgressHUD showMessage:@"正在验证"];
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMLog(@"--%@",responseObject);
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (m.resCode == 1) {
            ChangeLoginPwdNextViewController * nextVC = [ChangeLoginPwdNextViewController new];
            [weakSelf.verificationView timerInvalidate];
            weakSelf.verificationView.verificationCode = nil;
            [self.navigationController pushViewController:nextVC animated:YES];
            
        }else {
            
            [MBProgressHUD showText:m.resMsg];
        }
        
    } failure:^(NSError *error) {

    }];
    
}
-(NSString *)base64DecodeString:(NSString *)string{
    //注意：该字符串是base64编码后的字符串
    //1、转换为二进制数据（完成了解码的过程）
    NSData *data=[[NSData alloc]initWithBase64EncodedString:string options:0];
    //2、把二进制数据转换成字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
-(void)loadCerCode
{
    [super loadCerCode];
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc]init];
    params.usrMp         = self.userNameTF.text.clearSpace;
    params.token         = currentInfo.token;
    params.service_type  = @"02";
    params.tranCode      = CHANGEMOBILEGETCODE;
    [MBProgressHUD showMessage:@"正在发送"];
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        [MBProgressHUD hideHUD];
        if (m.resCode == 1 || m.resCode == 36) {
            [self.verificationView createTimer];
            self.NotFirstLoad = YES;
            [MBProgressHUD showText:m.resMsg];
            
            
        } else {
            
            [MBProgressHUD showText:m.resMsg];
        }
    } failure:^(NSError *error) {
       
    }];
    
}

@end
