//
//  VUtils.h
//  01_登陆页面
//
//  Created by MaKuiying on 16/9/14.
//  Copyright © 2016年 hope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VUtilsTool : NSObject


//字体适应
+ (float)fontWithString:(float)foutSize;
//图片拉伸
+ (UIImage *)stretchableImageWithImgName:(NSString *)imgName;
//颜色转图片
+(UIImage*) createImageWithColor:(UIColor*) color;
//手机号码的正则表达式
+ (BOOL)isValidateMobile:(NSString *)mobile;
//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email;
//身份证校验
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//验证支付密码－是否重复
+(BOOL)isValidateRepeatPayPwd:(NSString *)str;
//验证支付密码是否是连续的
+(BOOL)isValidateContinuousPayPwd:(NSString*)str;
//手机号格式化
+(NSString *)MobilePhoneFormat:(NSString *)text;
//判断输入是否为纯数字
+(BOOL)isPureInt:(NSString*)string;
//字符串是否为空
+ (BOOL)isEmptyStr:(NSString *)str;

@end
