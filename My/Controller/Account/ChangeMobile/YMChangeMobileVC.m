//
//  ChangePayPwdViewController.m
//  WSYMPay
//
//  Created by MaKuiying on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMChangeMobileVC.h"
#import "VerificationView.h"
#import "YMRedBackgroundButton.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
@implementation YMChangeMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.navigationItem.title = @"更换手机号";
    self.userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.nextButton setTitle:@"确定" forState:UIControlStateNormal];

}

//发送验证码{
-(void)loadCerCode{
    [super loadCerCode];
    NSString * userName =self.userNameTF.text.clearSpace;
    if (!userName.isValidateMobile) {
        [MBProgressHUD showText:@"请输入正确的手机号"];
        return;
    }
    RequestModel *params  = [[RequestModel alloc]init];
    params.token          = [YMUserInfoTool shareInstance].token;
    params.newUsrMp       = userName;
    params.tranCode       = CHANGEE_MGETNEWMCODE;
    [MBProgressHUD show];
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if( m.resCode == 1){
            [self.verificationView createTimer];
            self.NotFirstLoad = YES;
            [MBProgressHUD showText:m.resMsg];
        } else {
            
            [MBProgressHUD showText:responseObject[@"resMsg"]];
            
        }
    } failure:^(NSError *error) {
       
    }];
    
 
}
- (void)nextButtonDidClick{
    YMLog(@"下一步");
    [super nextButtonDidClick];
     NSString * userName  =self.userNameTF.text.clearSpace;
    if(!userName.isValidateMobile){
        [MBProgressHUD showText:@"请输入正确的手机号"];
        return;
    }
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    
    RequestModel *params  = [[RequestModel alloc]init];
    params.token          = currentInfo.token;
    params.randomCode     = [YMUserInfoTool shareInstance].randomCode;
    params.validateCode   = self.verificationView.verificationCode;
    params.newUsrMp       = userName;
    params.tranCode       = CHANGEMOBILEVVNEWCODE;
    [MBProgressHUD show];
    WEAK_SELF;
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (m.resCode == 1){
            [MBProgressHUD showText:m.resMsg];
            
            if (currentInfo.custLogin.isValidateMobile) {
                currentInfo.custLogin = userName;
            }
            
            currentInfo.usrMobile = userName;
            [currentInfo saveUserInfoToSanbox];
            [currentInfo refreshUserInfo];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.userNameTF.text = nil;
                weakSelf.verificationView.verificationCode = nil;
                [weakSelf.verificationView timerInvalidate];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        } else {
            
            [MBProgressHUD showText:m.resMsg];
        }

    } failure:^(NSError *error) {
        
    }];
 
}



@end
