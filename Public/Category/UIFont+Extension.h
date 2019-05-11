//
//  UIFont+Extension.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Extension)

/**
 按屏幕比例计算字体的大小

 @param mFont 传入字体的大小
 @return 计算支付的值
 */
+(UIFont *)systemFontOfMutableSize:(CGFloat)mFont;

@end
