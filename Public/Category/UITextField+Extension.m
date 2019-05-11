//
//  UITextField+Extension.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)
+(BOOL)textFieldWithPhoneFormat:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField) {
    NSString* text = textField.text;
    //删除
    if([string isEqualToString:@""]){
        
        //删除一位
        if(range.length == 1){
            //最后一位,遇到空格则多删除一次
            if (range.location == text.length-1 ) {
                if ([text characterAtIndex:text.length-1] == ' ') {
                    [textField deleteBackward];
                }
                return YES;
            }
            //从中间删除
            else{
                NSInteger offset = range.location;
                
                if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                    [textField deleteBackward];
                    offset --;
                }
                [textField deleteBackward];
                textField.text = [self parseString:textField.text];
                UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                return NO;
            }
        }
        else if (range.length > 1) {
            BOOL isLast = NO;
            //如果是从最后一位开始
            if(range.location + range.length == textField.text.length ){
                isLast = YES;
            }
            [textField deleteBackward];
            textField.text = [self parseString:textField.text];
            
            NSInteger offset = range.location;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            if (isLast) {
                //光标直接在最后一位了
            }else{
                UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            }
            
            return NO;
        }
        
        else{
            return YES;
        }
    }
    
    else if(string.length >0){
        
        //限制输入字符个数
        if (([self noneSpaseString:textField.text].length + string.length - range.length > 11) ) {
            return NO;
        }
        //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
        //            if(![string isNum]){
        //                return NO;
        //            }
        [textField insertText:string];
        textField.text = [self parseString:textField.text];
        
        NSInteger offset = range.location + string.length;
        if (range.location == 3 || range.location  == 8) {
            offset ++;
        }
        UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
        textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
        return NO;
    }else{
        return YES;
    }
}
    return YES;
}

+(NSString*)noneSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(NSString*)parseString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length >3) {
        [mStr insertString:@" " atIndex:3];
    }if (mStr.length > 8) {
        [mStr insertString:@" " atIndex:8];
        
    }
    return  mStr;
}
#define kMaxAmount 99999999
+(BOOL)textFieldWithMoneyFormat:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *amountText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *regStr = @"^([1-9][\\d]{0,100}|0)(\\.[\\d]{0,2})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regStr];
    BOOL match = [predicate evaluateWithObject:amountText];
    if ([string isEqualToString:@""]) return YES;  // 始终允许用户删除
    NSString *tmpStr = [amountText stringByAppendingString:string];
    NSString *numStr = [[tmpStr componentsSeparatedByString:@"."] firstObject];
    NSInteger amount = [numStr integerValue];
    if (([amountText integerValue] == kMaxAmount) && (![string isEqualToString:@""])) return NO;
    BOOL result = [amountText isEqualToString:@""] ? YES : (match && ((amount <= kMaxAmount) || [string isEqualToString:@"."]));
    return result;
}

+(BOOL)textFieldWithBankCardFormat:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField) {
        NSString* text = textField.text;
        //删除
        if([string isEqualToString:@""]){
            
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length-1 ) {
                    if ([text characterAtIndex:text.length-1] == ' ') {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self bankCardString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self bankCardString:textField.text];
                
                NSInteger offset = range.location;
                if (range.location == 4 || range.location  == 9 || range.location  == 14|| range.location  == 19) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        
        else if(string.length >0){
            
            //限制输入字符个数
            if (([self noneSpaseString:textField.text].length + string.length - range.length > 19) ) {
                return NO;
            }
            //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
            //            if(![string isNum]){
            //                return NO;
            //            }
            [textField insertText:string];
            textField.text = [self bankCardString:textField.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 4 || range.location  == 9 || range.location  == 14|| range.location  == 19) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

+(NSString*)bankCardString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length >4) {
        [mStr insertString:@" " atIndex:4];
    }if (mStr.length > 9) {
        [mStr insertString:@" " atIndex:9];
    }if (mStr.length > 14) {
        [mStr insertString:@" " atIndex:14];
    }if (mStr.length > 19) {
        [mStr insertString:@" " atIndex:19];
    }
    return  mStr;
}
@end
