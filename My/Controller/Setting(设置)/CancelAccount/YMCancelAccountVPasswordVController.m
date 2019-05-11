//
//  YMCancelAccountVPasswordVController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCancelAccountVPasswordVController.h"
#import "DXInputPasswordView.h"
#import "ChangePayPwdViewController.h" //修改支付密码界面
#import "YMUserInfoTool.h"
#import "YMCancelAccountFinishController.h"
#import "YMMyHttpRequestApi.h"
#import "YMPublicHUD.h"
#import "YMResponseModel.h"
#import "YMCancelAccountFinishController.h"

@interface YMCancelAccountVPasswordVController ()<DXInputPasswordViewDelegate>

@property (nonatomic, weak) DXInputPasswordView *inputpwdView;

@end

@implementation YMCancelAccountVPasswordVController

#pragma mark - lifeCycle                    - Method -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.navigationItem.title = @"验证支付密码";
    [self initViews];
}
#pragma mark - privateMethods               - Method -
- (void)initViews {
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请输入支付密码";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:14.0]];
    [self.view addSubview:label];
    
    
    DXInputPasswordView *inputpwdView  = [[DXInputPasswordView alloc]init];
    inputpwdView.frame                 = CGRectMake(15, label.frame.size.height+30, SCREENWIDTH-30,SCREENWIDTH*ROWProportion);
    inputpwdView.intervalLineColor     = LAYERCOLOR;
    inputpwdView.borderColor           = LAYERCOLOR;
    inputpwdView.layer.cornerRadius    = CORNERRADIUS;
    inputpwdView.delegate              = self;
    [inputpwdView becomeFirstResponder];
    [self.view addSubview:inputpwdView];
    self.inputpwdView                  = inputpwdView;
}

/**
 网络请求验证支付密码

 @param payPwd 支付密码
 */
- (void)loadDataPayPwd:(NSString *)payPwd
{
    WEAK_SELF;
    [MBProgressHUD show];
    [self.view endEditing:YES];
    [YMMyHttpRequestApi loadHttpRequestWithCheckPayPwdOrValidateCode:payPwd success:^(YMResponseModel *model) {
        [MBProgressHUD hideHUD];
        STRONG_SELF;
        if ([model getResCode] == 1) {//注销成功，跳到下一界面(注销账户成功界面)
            [MBProgressHUD showText:[model getResMsg]];
            YMCancelAccountFinishController *cancelFinishVC = [[YMCancelAccountFinishController alloc] init];
            cancelFinishVC.model = model;
            [strongSelf.navigationController pushViewController:cancelFinishVC animated:YES];
            
        }else{//注销失败（弹框重输密码。。。）
            [self showMessage:model.resMsg resCode:model.resCode];
        }
    } failure:^(NSError *error) {}];
}

-(void)showMessage:(NSString *)message resCode:(NSInteger)code
{
    if (code == PWDERRORTIMES_CODE){//密码错误，还可以输入"+N+"次"
        [YMPublicHUD showAlertView:nil message:message cancelTitle:@"重新输入" confirmTitle:@"忘记密码" cancel:^{
            [self.inputpwdView clearUpPassword];
            [self.inputpwdView.textField becomeFirstResponder];
        } confirm:^{
            [self goChangePayPassword];
        }];
        
    }else {
        if (code == PAYPWDLOCK_CODE) {
            [YMPublicHUD showAlertView:nil message:MSG15 cancelTitle:@"取消" confirmTitle:@"忘记密码" cancel:nil confirm:^{
                [self goChangePayPassword];
            }];
        } else {
            [YMPublicHUD showAlertView:nil message:message cancelTitle:@"确定" handler:nil];
        }
    }
}

#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -（DXInputPasswordViewDelegate/PromptBoxViewDelegate/YMPublicHUDDelegate）
-(void)inputPasswordView:(DXInputPasswordView *)inputPasswordView completeInput:(NSString *)str{
    YMLog(@"支付密码");
    [self.view endEditing:YES];
    [self loadDataPayPwd:str];
}

-(void)goChangePayPassword
{
    [self.inputpwdView clearUpPassword];
    ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
    [self.navigationController pushViewController:changePayVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.inputpwdView becomeFirstResponder];
}

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -


@end
