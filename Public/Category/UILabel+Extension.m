//
//  UILabel+Extension.m
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
/**
 设置lable行间距
 
 @param label label
 @param space 行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

@end
