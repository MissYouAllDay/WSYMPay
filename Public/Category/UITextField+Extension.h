//
//  UITextField+Extension.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)
/**
 控制textField为手机号的输入格式344样式

 @param textField 遵循格式的文本输入框
 */
+(BOOL)textFieldWithPhoneFormat:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
/**
 控制金额的输入
 */
+(BOOL)textFieldWithMoneyFormat:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 控制textField为手机号的输入格式344样式
 
 @param textField 遵循格式的文本输入框
 */
+(BOOL)textFieldWithBankCardFormat:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end
