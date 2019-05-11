//
//  YMCancelAccountGetVCodeController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCancelAccountGetVCodeController.h"
#import "YMUserInfoTool.h"
#import "YMRedBackgroundButton.h"
#import "VerificationView.h"
#import "YMCancelAccountFinishController.h"
#import "YMMyHttpRequestApi.h"
#import "YMResponseModel.h"

@interface YMCancelAccountGetVCodeController ()

@end

@implementation YMCancelAccountGetVCodeController
#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self loadData];
}
#pragma mark - privateMethods               - Method -
-(void)setupSubviews
{
    self.navigationItem.title = @"注销账户";
    
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.textColor = RGBColor(70, 70, 70);
    titleLabel.font      = [UIFont systemFontOfMutableSize:16];
    titleLabel.text      = [NSString stringWithFormat:@"验证码已发送至  %@",[YMUserInfoTool shareInstance].usrMobile.mobilePhoneNumberEncryption];
    [titleLabel sizeToFit];
    [self.tableView addSubview:titleLabel];
    
    CGFloat interval = ((SCREENWIDTH * ROWProportion) - titleLabel.bounds.size.height) / 2;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(interval);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
}
- (void)loadData
{
    [self loadCerCode];
}
-(void)loadCerCode
{
    [super loadCerCode];
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithSendValidateCodeSuccess:^(YMResponseModel *model) {
        
        STRONG_SELF;
        [strongSelf.verificationView createTimer];
        strongSelf.NotFirstLoad = YES;
        
    }];
}

#pragma mark - eventResponse                - Method -
-(void)nextBtnClick
{
    [super nextBtnClick];
    NSString *validateCode = self.textFieldStr;
    YMLog(@"验证码 = %@",validateCode);
    [MBProgressHUD showMessage:@"正在注销账户..."];
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithCheckPayPwdOrValidateCode:validateCode success:^(YMResponseModel *model) {
        STRONG_SELF;
        if ([model getResCode] == 1) {//注销成功,跳转界面
            YMCancelAccountFinishController *cancelFinishVC = [[YMCancelAccountFinishController alloc]init];
            cancelFinishVC.model = model;
            [strongSelf.navigationController pushViewController:cancelFinishVC animated:YES];
        }
        [MBProgressHUD showText:model.resMsg];
    } failure:^(NSError *error) {}];
}

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (SCREENWIDTH * ROWProportion);
}

#pragma mark - getters and setters          - Method -


@end
