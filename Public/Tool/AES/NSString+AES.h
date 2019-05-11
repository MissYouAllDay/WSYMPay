//
//  NSString+Extension.h
//  WSYMPay
//
//  Created by W-Duxin on 16/11/7.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)


/**
 * 加密
 */
-(NSString *)encryptAES;

/**
 * 解密
 */
-(NSString *)decryptAES;

-(NSString *)encryptAESWithKey:(NSString *)key;

-(NSString *)decryptAESWithKey:(NSString *)key;
@end
