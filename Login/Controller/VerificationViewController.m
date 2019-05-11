//
//  VerificationViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/18.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "VerificationViewController.h"
#import "VerificationView.h"
#import "ObtainUserIDFVTool.h"
#import "NSString+AES.h"
#import "YMRedBackgroundButton.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
#import "YMPublicHUD.h"
@interface VerificationViewController ()<VerificationViewDelegate>

@property (nonatomic, weak)   VerificationView *verificationView;

@property (nonatomic, weak)   UIButton         *submitButton;

@property (nonatomic, assign) BOOL              isFirstLoad;

@property (nonatomic, copy)   NSString         *verificationCode;

@end

@implementation VerificationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self.verificationView createTimer];
    
}


-(void)setupSubviews
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    
    
    CGFloat height = ((double)ROWProportion)*SCREENWIDTH;
    
    VerificationView *verificationView = [[VerificationView alloc]init];
    verificationView.delegate          = self;
    [self.view addSubview:verificationView];
    self.verificationView              = verificationView;
   
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = LAYERCOLOR;
    [self.view  addSubview:lineView];

    //提交
    YMRedBackgroundButton *submitButton       = [[YMRedBackgroundButton alloc]init];
    submitButton.enabled                      = NO;
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(commitButttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    self.submitButton            = submitButton;
    
   [verificationView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.view.mas_top).offset(30);
       make.width.equalTo(self.view.mas_width).multipliedBy(.8);
       make.centerX.equalTo(self.view.mas_centerX);
       make.height.offset(height);
   }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verificationView.mas_bottom).offset(5);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(1);
    }];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.top.equalTo(lineView.mas_bottom).offset(30);
        make.height.offset(SCREENWIDTH*ROWProportion);
    }];

}



//提交
-(void)commitButttonClick
{
    
    [MBProgressHUD showMessage:@"正在注册..."];
    _params.validateCode   = self.verificationCode;
    _params.tradeTerminal  = @"iOS";
    _params.macAddress     = @"";
    _params.tranCode       = REGISTERUPLOADINFO;
    _params.phoneModel     = @"";
    _params.ipAddress      = @"";
    _params.machineNum     = [ObtainUserIDFVTool getIDFV];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    
    __weak typeof(self) weakSelf = self;
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:_params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            m.custLogin    = weakSelf.params.custLogin;
            m.usrStatus    = -1;
            m.payPwdStatus = -1;
            m.usrMobile    = weakSelf.params.custLogin;
            m.phoneAddress = weakSelf.params.phoneAddress;
            m.cashAcBal    = @"0.00";
            currentInfo.responseModel = m;
            [currentInfo saveUserInfoToSanbox];
            [currentInfo refreshUserInfo];
            [MBProgressHUD showText:@"注册成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else if(m.resCode == 83) {
            [YMPublicHUD showAlertView:nil message:m.resMsg cancelTitle:@"确定" handler:nil];
        } else {
            [MBProgressHUD showText:m.resMsg];
        }
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        
    }];
    
    
    
}

#pragma mark - VerificationViewDelegate
-(void)verificationViewTextDidEditingChange:(NSString *)text
{
    
    if (text.length == 6) {
        
        self.submitButton.enabled = YES;
        self.verificationCode     = text;
    } else {
    
        self.submitButton.enabled = NO;
        
    }
}

-(void)verificationViewCountdownButtonDidClick:(VerificationView *)verificationView
{
    
    RequestModel *params         = [[RequestModel alloc]init];
    params.custLogin             =  [_params.custLogin decryptAESWithKey:AESKEYS];
    params.tranCode              = REGISTERGETVCODE;
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在发送..."];
    
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1 || m.resCode == 36) {
            [weakSelf.verificationView createTimer];
        }
        [MBProgressHUD showText:m.resMsg];
    } failure:^(NSError *error) {}];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isFirstLoad) {
        
        [MBProgressHUD showText:MSG2];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.isFirstLoad = YES;
}

-(void)dealloc
{
    
    YMLog(@"%s",__func__);
}

@end
