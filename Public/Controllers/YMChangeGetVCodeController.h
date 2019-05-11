//
//  YMGetVerificationCodeController.h
//  WSYMPay
//
//  Created by W-Duxin on 16/11/17.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerificationView,YMRedBackgroundButton;

@interface YMChangeGetVCodeController : UIViewController

/**
 *  继承本类时设置显示的账号，键盘输入格式，否则为默认输入格式，如果是邮箱请将TAG值设为100
 */
@property (nonatomic, weak) UITextField  *userNameTF;
/**
 *  用户名按钮左侧显示文字
 */
@property (nonatomic, copy) NSString     *leftTitle;
/**
 *  下一步按钮，可设置其Title
 */
@property (nonatomic, weak) YMRedBackgroundButton *nextButton;
/**
 *  输入验证码界面
 */
@property (nonatomic, weak) VerificationView *verificationView;
/**
 *是否是第一次加载 请在获取验证码成功为其赋值YES
 */
@property (nonatomic, assign, getter=isNotFirstLoad) BOOL  NotFirstLoad;
/**
 *  获取验证码的方法写在这里面
 */
-(void)loadCerCode;
/**
 *  nextButton点击时的方法写在这里面
 */
-(void)nextButtonDidClick;
@end
