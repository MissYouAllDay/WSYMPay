

//
//  CXFunctionTool.m
//  WSYMPay
//
//  Created by mac on 2019/5/10.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "CXFunctionTool.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation CXFunctionTool

+ (instancetype)shareFunctionTool {
    
    static CXFunctionTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [[CXFunctionTool alloc] init];
    });
    return tool;
}

// 指纹 识别
- (void)fingerReg {
    
    if (![GET_NSUSERDEFAULT(@"Finger") isEqualToString:@"1"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(functionWithFinger:)]) {
            [self.delegate functionWithFinger:0];
        }
        return;
    }

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
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(functionWithFinger:)]) {
                        [self.delegate functionWithFinger:1];
                    }
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
//        [MBProgressHUD showText:@"当前设备不支持TouchID"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(functionWithFinger:)]) {
            [self.delegate functionWithFinger:0];
        }
    }
   
}


@end
