//
//  NSString+Format.m
//  WSYMPay
//
//  Created by W-Duxin on 16/11/10.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 *  判断名称是否合法
 *  @param name 名称
 *  @return yes / no
 */
-(BOOL)isNameValid
{
    BOOL isValid = NO;
    
    if (self.length > 0)
    {
        for (NSInteger i=0; i<self.length; i++)
        {
            unichar chr = [self characterAtIndex:i];
            
            if (chr < 0x80)
            { //字符
                if (chr >= 'a' && chr <= 'z')
                {
                    isValid = YES;
                }
                else if (chr >= 'A' && chr <= 'Z')
                {
                    isValid = YES;
                }
                else if (chr >= '0' && chr <= '9')
                {
                    isValid = NO;
                }
                else if (chr == '-' || chr == '_')
                {
                    isValid = YES;
                }
                else
                {
                    isValid = NO;
                }
            }
            else if (chr >= 0x4e00 && chr < 0x9fa5)
            { //中文
                isValid = YES;
            }
            else
            { //无效字符
                isValid = NO;
            }
            
            if (!isValid)
            {
                break;
            }
        }
    }
    
    return isValid;
}

//手机号码的正则表达式
-(BOOL)isValidateMobile
{
    //手机号以13、15、18开头，八个\d数字字符
    NSString *mobile = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(170)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

-(NSString *)MobilePhoneFormat
{
    NSString *newStr = self;
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@" "withString:@""];
    // 如果是电话号码格式化，需要添加这三行代码 如果是判断银行卡只要把这三句注释即可
    NSMutableString *temString = [NSMutableString stringWithString:newStr];
    [temString insertString:@" "atIndex:0];
    newStr = temString;
    
    NSString *newString =@"";
    while (newStr.length >0)
    {
        NSString *subString = [newStr substringToIndex:MIN(newStr.length,4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length ==4)
        {
            newString = [newString stringByAppendingString:@" "];
        }
        newStr = [newStr substringFromIndex:MIN(newStr.length,4)];
    }
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    return newString;
}

-(NSString *)bankCardNumberFormat
{
    NSString *newStr = self;
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@" "withString:@""];    
    NSString *newString =@"";
    while (newStr.length >0)
    {
        NSString *subString = [newStr substringToIndex:MIN(newStr.length,4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length ==4)
        {
            newString = [newString stringByAppendingString:@" "];
        }
        newStr = [newStr substringFromIndex:MIN(newStr.length,4)];
    }
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    return newString;

}

-(NSString *)mobilePhoneNumberEncryption
{
    if (self.length == 11) {
        
        NSMutableString *newStr = [[NSMutableString alloc]initWithString:self];
        [newStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
        return newStr;
    } else {
    
        return nil;
    }

}

/**
 *  判断字符串是否为空
 *  created by pzj
 */
-(BOOL)isEmptyStr
{
    if (!self||self.length == 0) {
        return YES;
    }
    return NO;
}

/**
 清除字符串中空格
 
 @return 无空格的string
 */
-(NSString *)clearSpace
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}
//验证邮箱
-(BOOL)isValidateEmail
{   //邮箱地址的正则表达式
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)isPasswordFormat
{
    //数字、字母、特殊符号
    
    NSRange range = [self rangeOfString:@" "];
    if (range.location != NSNotFound || self.length < 8 || self.length > 20 || [self includeChinese]) {
        return NO;
    }

    
    //判断是否包含数字
    
    NSString *regex1 = @".*[0-9]+.*";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    
    BOOL isMatch1 = [pred1 evaluateWithObject:self];
    
    
    
    //判断是否包含小写字母
    NSString *regex2 = @".*[a-z]+.*";
    
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    BOOL isMatch2 = [pred2 evaluateWithObject:self];
    
    
    
    //判断是否包含大写字母
    NSString *regex3 = @".*[A-Z]+.*";
    
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex3];
    
    BOOL isMatch3 = [pred3 evaluateWithObject:self];
    
    
    
    //判断是否包含符号
    
//    NSString * regex4 = @".*[\\W\\_]+.*";
    NSString * regex4 = @".*[-`=\\\[\\];',./~!@#￥^$%^&*()_+|{}:\"<>?]+.*";
    NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex4];
    
    BOOL isMatch4 = [pred4 evaluateWithObject:self];
    
    return (isMatch1 && isMatch4 && (isMatch2 || isMatch3));
    
}

-(BOOL)isString:(NSString *)str
{
    return [self isEqualToString:str];
}

-(BOOL)isUrlString
{
    NSString *emailRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];

}

//判断输入是否为纯数字
-(BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

- (NSAttributedString *)getHtmlStr
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

@end
