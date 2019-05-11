//
//  MBProgressHUD+DX.h
//  Pods
//
//  Created by W-Duxin on 16/10/11.
//
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (DX)

+(void)showSuccess:(NSString *)success toView:(UIView *)view;
+(void)showError:(NSString *)error toView:(UIView *)view;
+(void)showInfo:(NSString *)info toView:(UIView *)view;

+(MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+(void)showSuccess:(NSString *)success;
+(void)showError:(NSString *)error;
+(void)showInfo:(NSString *)info;
/**
 只显示菊花转圈圈
 */
+(MBProgressHUD *)show;
+(MBProgressHUD *)showInView:(UIView *)view;
+(MBProgressHUD *)showMessage:(NSString *)message;
+(void)hideHUDForView:(UIView *)view;

+(void)hideHUD;

//只显示文字
+(void)showText:(NSString *)text toView:(UIView *)view;
+(void)showText:(NSString *)text;
@end
