//
//  YMAddBankGetCodeController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/1.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAddBankGetCodeController.h"
#import "VerificationView.h"
#import "YMRedBackgroundButton.h"
#import "YMMyHttpRequestApi.h"
#import "YMBankCardModel.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
#import "LKDBHelper.h"
#import "YMVerifyBankCardDataModel.h"

@interface YMAddBankGetCodeController ()
@property (nonatomic, strong)YMResponseModel *responseModel;
@property (nonatomic, strong) LKDBHelper *listDB;
@end
@implementation YMAddBankGetCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
    [self.verificationView createTimer];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self initDB];
    });
}

-(void)nextBtnClick
{
    [super nextBtnClick];
    [self.view endEditing:YES];
    self.paramers.chaneel_short = [self.data valueForKey:@"chaneel_short"];
    self.paramers.randomCode = [self.data valueForKey:@"randomCode"];
    self.paramers.trxDtTm = [self.data valueForKey:@"trxDtTm"];
    self.paramers.trxId = [self.data valueForKey:@"trxId"];
    self.paramers.wl_url = [self.data valueForKey:@"wl_url"];
    
    self.paramers.bankName = self.bankCardModel.bankName;
    self.paramers.bankAcNo = self.bankCardModel.bankAcNo;
    self.paramers.randomCode = [YMUserInfoTool shareInstance].randomCode;
    self.paramers.validateCode = self.verificationView.verificationCode;
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttRequestWithAttachBankCard:self.paramers success:^(YMResponseModel *m){
        //将添加银行卡流程页面全部pop
        weakSelf.responseModel = m;
        /*
         * 银行卡添加成功后安全码存入数据库
         */
        if ([m.cardFlag isEqualToString:@"02"]) {//信用卡时存
             [weakSelf saveDB];
        }
        [MBProgressHUD showText:@"添加银行卡成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSYMNSNotification postNotificationName:WSYMUserAddBankCardSuccessNotification object:nil];
        NSInteger index       = weakSelf.navigationController.viewControllers.count - 1;
        UIViewController * vc = weakSelf.navigationController.childViewControllers[index - 3];
        [weakSelf.navigationController popToViewController:vc animated:YES];
        });
    }];
}

-(void)loadCerCode
{
    [super loadCerCode];    
    [YMMyHttpRequestApi loadHttpRequestWithGetBankVCode:self.paramers success:^(NSInteger resCode, NSString *resMsg, NSDictionary *data) {
        [MBProgressHUD showText:resMsg];
        [self.verificationView createTimer];
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
    model.paySingKey = self.responseModel.paySign;
    model.safetyCode = [self.paramers.safetyCode decryptAES];
    [model saveToDB];
    YMLog(@"---%d",[model saveToDB]);
}

@end
