//
//  YMVerificationPaywordBoxView.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/2.
//  Copyright © 2016年 赢联. All rights reserved.
//


/*
 * 点击确认支付按钮后出来的弹框
 * 2017-3-22 changed by pzj
 * 输入支付密码view 弹框
 * 修改成block回调的方法 2017-7-19 changed by pzj
 */
#import <UIKit/UIKit.h>

@class YMVerificationPaywordBoxView;

@protocol YMVerificationPaywordBoxViewDelegate <NSObject>

@optional

-(void)verificationPaywordBoxViewForgetButtonDidClick:(YMVerificationPaywordBoxView *)boxView;

-(void)verificationPaywordBoxViewQuitButtonDidClick:(YMVerificationPaywordBoxView *)boxView;

-(void)verificationPaywordBoxView:(YMVerificationPaywordBoxView *)boxView completeInput:(NSString *)str;

@end

@interface YMVerificationPaywordBoxView : UIView

@property (nonatomic, weak) id <YMVerificationPaywordBoxViewDelegate> delegate;

@property (nonatomic, assign)BOOL  loading;

-(void)show;


#pragma mark - app4期 changed by pzj 
+ (YMVerificationPaywordBoxView *)getPayPwdBoxView;

/**
 调起输入支付密码弹框view

 @param success 输入密码成功---返回输入的密码
 @param forgetPwd 忘记密码
 @param quit 退出view
 */
- (void)showPayPwdBoxViewResultSuccess:(void(^)(NSString *pwdStr))success
                          forgetPwdBtn:(void(^)())forgetPwd
                               quitBtn:(void(^)())quit;

@property (nonatomic, strong)void(^successBlock)(NSString *pwdStr);
@property (nonatomic, strong)void(^forgetPwdBlock)();
@property (nonatomic, strong)void(^quitBlock)();


@end
