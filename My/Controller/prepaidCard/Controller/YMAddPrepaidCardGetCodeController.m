//
//  YMAddPrepaidCardGetCodeController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/5.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAddPrepaidCardGetCodeController.h"
#import "VerificationView.h"
#import "YMMyHttpRequestApi.h"
#import "YMUserInfoTool.h"
#import "RequestModel.h"
#import "YMResponseModel.h"
#import "YMMYPrepaidCardController.h"

#define SERVER_TYPE @"04"//短信用途 04:变更短信

@interface YMAddPrepaidCardGetCodeController ()

@end

@implementation YMAddPrepaidCardGetCodeController

#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title      = @"添加预付卡";
}

#pragma mark - privateMethods               - Method -

#pragma mark - eventResponse                - Method -
-(void)nextBtnClick//确定按钮(验证手机验证码)
{
    RequestModel *params = [[RequestModel alloc]init];
    params.prepaidNo = self.prepaidNoStr;//卡号
    params.preOrderNo = self.responseModel.preOrderNo;//绑卡订单号
    params.validateCode = self.textFieldStr;//验证码：
    params.insFlag = self.responseModel.insFlag;//是否存在绑定关系
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithCheckPrepaidCardValidateCode:params success:^(YMResponseModel *model) {
        STRONG_SELF;
        if (model.resCode == 1) {//添加成功自动跳转到我的预付卡界面
            [WSYMNSNotification postNotificationName:WSYMUserAddPrepaidCardSuccessNotification object:nil];
            for (UIViewController *controller in strongSelf.navigationController.viewControllers) {
                if ([controller isKindOfClass:[YMMYPrepaidCardController class]]) {
                    [strongSelf.navigationController popToViewController:controller animated:YES];
                }
            }
        }
    }];
}

//获取验证码
-(void)loadCerCode
{
    [super loadCerCode];
    [self.view endEditing:YES];
    [MBProgressHUD show];
    RequestModel *parames = [[RequestModel alloc] init];
    parames.prepaidNo     = self.prepaidNoStr;
    parames.usrMp         = self.usrMpStr;
    WEAK_SELF;    
    [YMMyHttpRequestApi loadHttpRequestWithAddPrepaidCardRequestModel:parames success:^(YMResponseModel *model) {
        [MBProgressHUD hideHUD];
        STRONG_SELF;
        if (model.resCode == 1) {
            [weakSelf.verificationView createTimer];
            strongSelf.responseModel = model;
            [MBProgressHUD showText:model.resMsg];
        }
    }];

}

@end
