//
//  MBProgressHUD+DX.m
//  Pods
//
//  Created by W-Duxin on 16/10/11.
//
//

#import "MBProgressHUD+DX.h"


#define xFONT [UIFont systemFontOfSize:10]

#define BACKGROUNDCOLOR [UIColor colorWithWhite:0.f alpha:.5f]

@interface MBProgressHUD ()

@end


@implementation MBProgressHUD (DX)

#pragma mark显示信息

+(void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    if(view==nil) view=[UIView new];

    [self hideHUDForView:view];
    if (text.length > 8) {
        
        NSMutableString *newStr = [[NSMutableString alloc]initWithString:text];
        
        [newStr insertString:@"\n" atIndex:6];
    
        text = newStr;
    }
    //快速显示一个提示信息
    MBProgressHUD *hud               = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text            =  text;
    hud.detailsLabel.font            = COMMON_FONT;
    hud.margin                       = 10;
    hud.bezelView.style              =  MBProgressHUDBackgroundStyleBlur;
    hud.bezelView.color              = BACKGROUNDCOLOR;
    hud.bezelView.layer.cornerRadius = CORNERRADIUS;
    hud.contentColor                 = [UIColor whiteColor];
    hud.backgroundView.style         = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color         = [UIColor colorWithWhite:0.f alpha:.2f];
    //设置图片
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@",icon]]];
    
    //在设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏的时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    //1秒后再消失
    [hud hideAnimated:YES afterDelay:1.5];
    
}

#pragma mark 显示错误信息

+(void)showError:(NSString *)error toView:(UIView *)view
{
    
    [self show:error icon:@"error.png" view:view];

}

+(void)showSuccess:(NSString *)success toView:(UIView *)view
{
    
    [self show:success icon:@"success.png" view:view];
}

+(void)showInfo:(NSString *)info toView:(UIView *)view
{
    
    [self show:info icon:@"info.png" view:view];

}

+(void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+(void)showError:(NSString *)error
{
    
    [self showError:error toView:nil];
}

+(void)showInfo:(NSString *)info
{

    [self showInfo:info toView:nil];
}
+(MBProgressHUD *)show{
    return [self showInView:nil];
}

+(MBProgressHUD *)showInView:(UIView *)view
{
    if (!view) view = [UIApplication sharedApplication].keyWindow;
    if(view==nil) view=[UIView new];

    //快速显示一个提示信息
    MBProgressHUD *hud               = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style              =  MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor                 = [UIColor whiteColor];
    hud.margin                       = 8;
    hud.bezelView.color              = BACKGROUNDCOLOR;
    hud.bezelView.layer.cornerRadius = CORNERRADIUS;
    hud.backgroundView.style         = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color         = [UIColor colorWithWhite:0.f alpha:.1f];
    hud.removeFromSuperViewOnHide    = YES;
    hud.mode                         = MBProgressHUDModeIndeterminate;
    return hud;
}

#pragma mark 显示一些信息
+(MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    if(view==nil) view=[UIView new];

    //快速显示一个提示信息
    MBProgressHUD *hud               = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text                   = message;
    hud.label.font                   = COMMON_FONT;
    hud.margin                       = 10;
    hud.bezelView.style              = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color              = BACKGROUNDCOLOR;
    hud.bezelView.layer.cornerRadius = CORNERRADIUS;
    hud.contentColor                 = [UIColor whiteColor];
    hud.backgroundView.style         = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color         = [UIColor colorWithWhite:0.f alpha:.2f];
    hud.removeFromSuperViewOnHide    = YES;
    return hud;
}

+(MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+(void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:YES];
}

+(void)hideHUD
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
        });
    }
    
    [self hideHUDForView:nil];
}

#pragma mark - 只显示文本
+(void)showText:(NSString *)text toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view];
    //快速显示一个提示信息
    MBProgressHUD *hud    = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = text;
    hud.contentColor      = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfMutableSize:14];
    hud.margin            = 8;
    hud.offset            = CGPointMake(hud.offset.x, 60);
    hud.bezelView.style   = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color   = [UIColor colorWithWhite:0.f alpha:.5f];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.3];
}

+(void)showText:(NSString *)text
{
    [self showText:text toView:nil];
}

@end
