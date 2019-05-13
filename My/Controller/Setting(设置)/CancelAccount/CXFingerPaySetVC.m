//
//  YMFingerSetViewController.m
//  WSYMPay
//
//  Created by jey on 2019/5/10.
//  Copyright © 2019 赢联. All rights reserved.
//
#define SET_NSUSERDEFAULT(k, o)           ([[NSUserDefaults standardUserDefaults] setObject:o forKey:k])
#define REMOVE_NSUSERDEFAULT(k)           ([[NSUserDefaults standardUserDefaults] removeObjectForKey:k])
#define NSUSERDEFAULT_SYNCHRONIZE         ([[NSUserDefaults standardUserDefaults] synchronize])
#import "CXFingerPaySetVC.h"
#import "YMVerificationPaywordBoxView.h"
#import "ChangePayPwdViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "OpenSSLRSAManagers.h"
#import "ObtainUserIDFVTool.h"
@interface CXFingerPaySetVC ()
@property (nonatomic,strong) UILabel *fingerMes;
@property (nonatomic,strong) UILabel *tsMes;
@property (nonatomic,strong) UIButton *ktBtn;
/** 密码输入框 */
@property (nonatomic, strong) YMVerificationPaywordBoxView *pwdBoxView;

@end

@implementation CXFingerPaySetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
- (void)setupView {
    self.title = @"指纹设置";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-82)/2, 47, 82, 94)];
    iconImageView.image = [UIImage imageNamed:@"指纹"];
    [self.view addSubview:iconImageView];
    
    _fingerMes = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImageView.bottom+30, SCREENWIDTH, 14)];
    _fingerMes.textAlignment = NSTextAlignmentCenter;
    _fingerMes.textColor = UIColorFromHex(0x000000);
    _fingerMes.font = [UIFont systemFontOfSize:15];
    _fingerMes.text = @"您未开通指纹支付";
    [self.view addSubview:_fingerMes];
    
    _tsMes = [[UILabel alloc]initWithFrame:CGRectMake(0, _fingerMes.bottom+12, SCREENWIDTH, 12)];
    _tsMes.textAlignment = NSTextAlignmentCenter;
    _tsMes.textColor = UIColorFromHex(0x9e9e9e);
    _tsMes.font = [UIFont systemFontOfSize:12];
    _tsMes.text = @"验证系统指纹快速完成支付，更安全便捷";
    [self.view addSubview:_tsMes];
    
    _ktBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, _tsMes.bottom+100, SCREENWIDTH-26, 48)];
    _ktBtn.backgroundColor = UIColorFromHex(0xE1473D);
    _ktBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _ktBtn.layer.cornerRadius = 5.0f;
    [_ktBtn.layer setMasksToBounds:YES];
    [_ktBtn setTitle:@"开通指纹支付" forState:UIControlStateNormal];
    [_ktBtn setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
    [self.view addSubview:_ktBtn];
    [_ktBtn addTarget:self action:@selector(ktBtnClick) forControlEvents:UIControlEventTouchDown];
    if ([GET_NSUSERDEFAULT(USER_FINGER) isEqualToString:@"1"]) {
        _fingerMes.text = @"您已开通指纹支付";
        [_ktBtn setTitle:@"关闭指纹支付" forState:UIControlStateNormal];
        
    }
    
}
- (void)ktBtnClick {
    
    if ([GET_NSUSERDEFAULT(USER_FINGER) isEqualToString:@"1"]) {
        REMOVE_NSUSERDEFAULT(USER_FINGER);
        _fingerMes.text = @"您未开通指纹支付";
        [_ktBtn setTitle:@"开通指纹支付" forState:UIControlStateNormal];
        return;
    }
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        [MBProgressHUD showText:@"系统版本不支持TouchID"];
        return;
    }
    
    [self loadPayPasswordBoxView];
}
// 录入 指纹
- (void)fingerReg:(NSString *)payPwd {
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"输入密码";
    if (@available(iOS 10.0, *)) {
        //  context.localizedCancelTitle = @"22222";
    } else {
        // Fallback on earlier versions
    }
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showText:@"指纹验证成功"];
                    [self postFingerprintPay:payPwd];
                });
            }else if(error){
                
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 验证失败");
                            [MBProgressHUD showText:@"指纹验证失败"];
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被用户手动取消");
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"用户不使用TouchID,选择手动输入密码");
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无效");
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                            [MBProgressHUD showText:@"TouchID 被锁定"];
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
        
    }else{
        [MBProgressHUD showText:@"当前设备不支持TouchID"];
    }
}

// 输入密码
- (void)loadPayPasswordBoxView
{
    self.pwdBoxView = [YMVerificationPaywordBoxView getPayPwdBoxView];
    [self.pwdBoxView showPayPwdBoxViewResultSuccess:^(NSString *pwdStr) {
        [self.pwdBoxView removeFromSuperview];
        YMLog(@"pwdStr = %@",pwdStr);
        [self fingerReg:pwdStr];
    } forgetPwdBtn:^{
        [self.pwdBoxView removeFromSuperview];
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navigationController pushViewController:changePayVC animated:YES];
    } quitBtn:^{
    
    }];
}

- (void)loadCheckPwdData:(NSString *)pwdStr
{
    
}

// 指纹解锁
- (void)postFingerprintPay:(NSString *)payPwd {
    
    RequestModel *params = [[RequestModel alloc]init];
    
    params.tranCode      = FIGERSETTING;
    params.token         = [YMUserInfoTool shareInstance].token;
    params.Publickey     = [self postRSA];
    params.machineNum    = [ObtainUserIDFVTool getIDFV];
    params.payPwd        = payPwd;

    [MBProgressHUD show];
    
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        
        if ([responseObject[@"resCode"] intValue] == 1) {

            SET_NSUSERDEFAULT(USER_FINGER, @"1");
            _fingerMes.text = @"您已开通指纹支付";
            [_ktBtn setTitle:@"关闭指纹支付" forState:UIControlStateNormal];
            
        }else {
            [MBProgressHUD showText:responseObject[@"resMsg"]];
        }
       
    } failure:^(NSError *error) {[MBProgressHUD hideHUD];}];
}

- (NSString *)postRSA {
    
    RSA *publicKey;
    RSA *privateKey;
    while (1) {
        BOOL isTure=[OpenSSLRSAManagers  generateRSAKeyPairWithKeySize:2048 publicKey:&publicKey privateKey:&privateKey];
        if(isTure) {
            if(privateKey&&publicKey) {
                NSString *pemPublicStr=[OpenSSLRSAManagers pemEncodedStringKey:publicKey isPubkey:YES];//上传服务器
                [OpenSSLRSAManagers pemEncodedStringKey:privateKey isPubkey:NO];//这个私匙直接保存成文件了
//                NSString *signData=[OpenSSLRSAManagers rsaSignStringwithString:@"1000"];//签名
                return pemPublicStr;
                break;
            }
        }
    }
}


@end
