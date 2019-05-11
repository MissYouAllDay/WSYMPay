//
//  SettingPayPasswordView.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/22.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMPayPasswordBoxView;

@protocol YMPayPasswordBoxViewDelegate <NSObject>

@optional
//输入框完成输
-(void)payPasswordBoxView:(YMPayPasswordBoxView *)settingPayPasswordView inputPasswordComplete:(NSString *)pwd;
//返回按钮被点击
-(void)payPasswordBoxViewBackButtonDidClick:(YMPayPasswordBoxView *)settingPayPasswordView;
//退出按钮被点击
-(void)payPasswordBoxViewQuitButtonDidClick:(YMPayPasswordBoxView *)settingPayPasswordView;
@end

@interface YMPayPasswordBoxView : UIView

@property (nonatomic, weak) id <YMPayPasswordBoxViewDelegate> delegate;

//返回按钮的显示状态
@property (nonatomic, assign, getter=isBackButtonHiden) BOOL backButtonHiden;
//退出按钮的显示状态
@property (nonatomic, assign, getter=isQuitButtonHiden) BOOL quitButtonHiden;

@property (nonatomic, assign) BOOL isSettingPayPasswordBox;

@property (nonatomic, copy) NSString *title;

-(void)clearPasswordBox;
-(void)becomeFirstResponder;
@end
