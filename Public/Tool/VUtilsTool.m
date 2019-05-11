//
//  VUtils.m
//  01_登陆页面
//
//  Created by MaKuiying on 16/9/14.
//  Copyright © 2016年 hope. All rights reserved.
//

#import "VUtilsTool.h"

@implementation VUtilsTool


//字体适应
+(float)fontWithString:(float)fontSize{
    
    CGRect mainFrme = [[UIScreen mainScreen] bounds];
    if (mainFrme.size.width*2/640 <= 1) {
        return fontSize;
    }
    fontSize = fontSize*(mainFrme.size.width/640)*2;
    return fontSize;
    
}

//图片拉伸
+(UIImage *)stretchableImageWithImgName:(NSString *)imgName
{
    UIImage * img  = [UIImage imageNamed:imgName];
    CGFloat top    = img.size.height*0.43; // 顶端盖高度
    CGFloat bottom = img.size.height*0.43; // 底端盖高度
    CGFloat left   = img.size.width*0.43; // 左端盖宽度
    CGFloat right  = img.size.width*0.43; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    img = [img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];

    return img;
}
//颜色转换图片

+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//手机号码的正则表达式
+ (BOOL)isValidateMobile:(NSString *)mobile{
    //手机号以13、15、18开头，八个\d数字字符

    NSString* str1 = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:str1];
}
//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//验证支付密码－是否重复
+(BOOL)isValidateRepeatPayPwd:(NSString *)str {
    //长度不为6
    if (str.length != 6) {
        return false;
    }
    // 获取每个字符
    NSMutableArray *arrM = [[NSMutableArray alloc] init];
    for (int i=0; i<str.length; i++) {
        [arrM addObject:[str substringWithRange:NSMakeRange(i, 1)]];
    }
    // 是否全部一样
    BOOL isSame = true;
    NSString *lastStr = arrM[0];
    for (NSString *str in arrM) {
        if (![lastStr isEqualToString:str]) {
            isSame = false;
            break;
        }
    }
    if (isSame == true) {
        return false;
    }
    
    
    return true;
}

//验证支付密码是否是连续的
+(BOOL)isValidateContinuousPayPwd:(NSString*)str{
    
    //长度不为6
    if (str.length != 6) {
        return false;
    }
    // 获取每个字符
    NSMutableArray *arrM = [[NSMutableArray alloc] init];
    for (int i=0; i<str.length; i++) {
        [arrM addObject:[str substringWithRange:NSMakeRange(i, 1)]];
    }

    // 是否是递增的
    if ([arrM[0] integerValue] + 1 == [arrM[1] integerValue] &&
        [arrM[1] integerValue] + 1 == [arrM[2] integerValue] &&
        [arrM[2] integerValue] + 1 == [arrM[3] integerValue] &&
        [arrM[3] integerValue] + 1 == [arrM[4] integerValue] &&
        [arrM[4] integerValue] + 1 == [arrM[5] integerValue]) {
        return false;
    }
    if ([arrM[0] integerValue] - 1 == [arrM[1] integerValue] &&
        [arrM[1] integerValue] - 1 == [arrM[2] integerValue] &&
        [arrM[2] integerValue] - 1 == [arrM[3] integerValue] &&
        [arrM[3] integerValue] - 1 == [arrM[4] integerValue] &&
        [arrM[4] integerValue] - 1 == [arrM[5] integerValue]) {
        return false;
    }
    return YES;

}
// 身份证号码
+ (BOOL) validateIdentityCard: (NSString *)identityCard{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(identityCard.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
}
+(NSString *)MobilePhoneFormat:(NSString *)text
{
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    text = [text stringByReplacingOccurrencesOfString:@" "withString:@""];
    // 如果是电话号码格式化，需要添加这三行代码 如果是判断银行卡只要把这三句注释即可
    NSMutableString *temString = [NSMutableString stringWithString:text];
    [temString insertString:@" "atIndex:0];
    text = temString;
    
    NSString *newString =@"";
    while (text.length >0)
    {
        NSString *subString = [text substringToIndex:MIN(text.length,4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length ==4)
        {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length,4)];
    }
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    return newString;
}

//判断输入是否为纯数字
+(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isEmptyStr:(NSString *)str
{
    if (str != nil) {
        if (!str||str.length == 0) {
            return YES;
        }
    }
    return NO;
}

@end
