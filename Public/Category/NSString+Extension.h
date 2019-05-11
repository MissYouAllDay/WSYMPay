//
//  NSString+Format.h
//  WSYMPay
//
//  Created by W-Duxin on 16/11/10.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
/**
 *  判断姓名是否合法
 */
-(BOOL)isNameValid;

/**
 *  手机号码的正则表达式
 *
 *  @return 是否是手机号
 */
-(BOOL)isValidateMobile;

/**
 *  手机号格式化
 *
 *  @return 返回344样式手机号
 */
-(NSString *)MobilePhoneFormat;

-(NSString *)bankCardNumberFormat;

/**
 返回密码形式的手机号134****1234

 @return 加密之后的手机号
 */
-(NSString *)mobilePhoneNumberEncryption;

/**
 *  判断字符串是否为空
 *  created by pzj
 */
-(BOOL)isEmptyStr;
/**
 清除字符串中空格

 @return 无空格的string
 */
- (NSString *)clearSpace;

//邮箱地址的正则表达式
/**
 验证邮箱地址

 @return YES or NO
 */
-(BOOL)isValidateEmail;

/**
 验证密码输入规则

 @return YES or NO
 */
-(BOOL)isPasswordFormat;

/**
 判断字符串是否相同

 @return YES or NO
 */
-(BOOL)isString:(NSString *)str;

/**
 判断是否是url

 @return YES or NO
 */
-(BOOL)isUrlString;

/**
 加载html格式字符串

 @return NSAttributedString
 */
- (NSAttributedString *)getHtmlStr;
@end
