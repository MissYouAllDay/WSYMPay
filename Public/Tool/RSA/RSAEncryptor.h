//
//  RSAEncryptor.h
//  10_17_Test_注册键值yild
//
//  Created by W-Duxin on 16/10/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject


+(NSString *)encryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path;

+(NSString *)decryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

+(NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

+(NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;

@end
