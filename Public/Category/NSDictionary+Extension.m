//
//  NSDictionary+Extension.m
//  WSYMPay
//
//  Created by W-Duxin on 16/11/1.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error   = nil;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        
        NSLog(@"解析失败%@",error.localizedDescription);
    }
    
    return dic;
}

+(NSDictionary *)attributesForUserTextWithlineHeightMultiple:(CGFloat)multiple
{
    NSMutableParagraphStyle *paragraphStyle     = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple           = multiple;//调整行间距
    paragraphStyle.lineBreakMode                = NSLineBreakByCharWrapping;
    paragraphStyle.paragraphSpacing             = 0;//段落后面的间距
    paragraphStyle.paragraphSpacingBefore       = 0;//段落之前的间距
    paragraphStyle.alignment                    = NSTextAlignmentCenter;

    return @{NSParagraphStyleAttributeName:paragraphStyle};
}

@end
