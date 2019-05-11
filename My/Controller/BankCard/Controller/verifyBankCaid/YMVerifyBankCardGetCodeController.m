//
//  YMVerifyBankCardGetCodeControllerViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/4/11.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMVerifyBankCardGetCodeController.h"
#import "VerificationView.h"
#import "YMMyHttpRequestApi.h"
#import "YMBankCardModel.h"
#import "YMUserInfoTool.h"
#import "RequestModel.h"
#import "YMResponseModel.h"
#import "LKDBHelper.h"
#import "YMVerifyBankCardDataModel.h"

@interface YMVerifyBankCardGetCodeController ()
@property (nonatomic, strong) LKDBHelper *listDB;
@property (nonatomic, strong) YMResponseModel *responseModel;
@end

@implementation YMVerifyBankCardGetCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证银行卡";
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self initDB];
    });
}

-(void)nextBtnClick
{
    [super nextBtnClick];
    [self.view endEditing:YES];
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithVerifyBankVCode:self.bankCardModel validateCode:self.verificationView.verificationCode success:^(YMResponseModel *m){
        weakSelf.responseModel = m;
        /*
         * 信用卡时将安全码存入本地数据库
         */
        if ([m.cardFlag isEqualToString:@"02"]) {//信用卡
            [self saveDB];
        }
        
        [MBProgressHUD showText:@"验证银行卡成功"];
        
        NSInteger index = self.navigationController.viewControllers.count - 3;
        [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[index] animated:YES];
    }];

}

-(void)loadCerCode
{
    [super loadCerCode];

    RequestModel *paramers  = [[RequestModel alloc]init];
    paramers.token          = [YMUserInfoTool shareInstance].token;
    paramers.cardType       = [NSString stringWithFormat:@"0%ld",(long)self.bankCardModel.cardType];
    paramers.bankPreMobile  = self.bankCardModel.bankPreMobile;
    paramers.cardDeadline   = self.bankCardModel.cardDeadline;
    paramers.safetyCode     = self.bankCardModel.safetyCode;
    paramers.reAuthBankCard = @"01";
    
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetBankVCode:paramers success:^(NSInteger resCode, NSString *resMsg, NSDictionary *data) {
        if (resCode == 1) {
            [weakSelf.verificationView createTimer];
        }
        [MBProgressHUD showText:resMsg];
    }];

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
