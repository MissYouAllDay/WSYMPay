//
//  E_MailViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/22.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "E_MailViewController.h"
#import "YMUserInfoTool.h"
#import "VerificationView.h"
#import "YMResponseModel.h"
@interface E_MailViewController ()

@end

@implementation E_MailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title   = @"邮箱";
    self.userNameTF.placeholder = @"请输入邮箱";
    self.leftTitle              = @"邮　箱";
    self.userNameTF.tag         = 100;
}


//发送验证码{
-(void)loadCerCode{
    
    [super loadCerCode];

    NSString *userName = self.userNameTF.text;
    
        if (![VUtilsTool isValidateEmail:userName]){
        
            [MBProgressHUD showText:@"请输入正确的邮箱"];
            return;
        }
        
    RequestModel *params  = [[RequestModel alloc]init];
    params.token          = [YMUserInfoTool shareInstance].token;
    params.tranCode       = CHANGEE_MAILGETCODE;
    params.newUsrMp       = userName;
    [MBProgressHUD showMessage:@"正在发送验证码"];
     [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
         
         YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
         
         if (m.resCode == 1||m.resCode == 36) {
             
             if (m.resCode == 1) {
                [self.verificationView createTimer];
                 self.NotFirstLoad = YES;
             }
             [MBProgressHUD showText:m.resMsg];
             
         } else {
             
             [MBProgressHUD showText:m.resMsg];
         }
     } failure:^(NSError *error) {}];
    
    
}
- (void)nextButtonDidClick
{
    [super nextButtonDidClick];
    NSString * verificationCode = self.verificationView.verificationCode;
    NSString * userName         = self.userNameTF.text;
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    
    RequestModel *params  = [[RequestModel alloc]init];
    params.newUsrMp       = userName;
    params.token          = currentInfo.token;
    params.validateCode   = verificationCode;
    params.tranCode       = CHANGEEMAIL;
    params.randomCode     = [YMUserInfoTool shareInstance].randomCode;;
    __weak typeof(self) weakSelf = self;

   [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
       
       YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
       if (m.resCode == 1) {
           
           if (currentInfo.custLogin.isValidateEmail) {
               currentInfo.custLogin = userName;
           }
           
           currentInfo.usrEmail    = userName;
           [currentInfo saveUserInfoToSanbox];
           [currentInfo refreshUserInfo];
           [MBProgressHUD showText:m.resMsg];
           [weakSelf.navigationController popViewControllerAnimated:YES];
           if (weakSelf.changeBlock) {
               
               weakSelf.changeBlock(userName);
           }
           
       } else {
           
           [MBProgressHUD showText:m.resMsg];
       }
   } failure:^(NSError *error) {}];
    
}
@end

