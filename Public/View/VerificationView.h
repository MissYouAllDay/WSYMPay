//
//  VerificationView.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/18.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerificationView;

@protocol VerificationViewDelegate <NSObject>

@optional
-(void)verificationViewTextDidEditingChange:(NSString *)text;

-(void)verificationViewCountdownButtonDidClick:(VerificationView *)verificationView;
@end

@interface VerificationView : UIView

//显示左侧按钮
@property (nonatomic, assign) BOOL  showLeftTitlt;

@property (nonatomic, copy) NSString *countdownButtonTitle;

@property (nonatomic, weak) id <VerificationViewDelegate> delegate;
//验证码
@property (nonatomic, copy) NSString *verificationCode;

@property (nonatomic, assign,readonly) BOOL isCountDown;
//开始倒计时
-(void)createTimer;
//清空
-(void)timerInvalidate;
@end
