//
//  UIFont+Extension.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+(UIFont *)systemFontOfMutableSize:(CGFloat)mFont
{

    return [UIFont systemFontOfSize:[VUtilsTool fontWithString:mFont]];

}

@end
