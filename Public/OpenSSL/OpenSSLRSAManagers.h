//
//  OpenSSLRSAManagers.h
//  Taodandan
//
//  Created by junchiNB on 2019/5/6.
//  Copyright © 2019年 junchiNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/pem.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenSSLRSAManagers : NSObject
/*
 *keysize : 密匙大小  使用2048的大小吧
 *publicKey:RSA公匙
 *privateKey:RSA私匙
 return  成功 失败
 */
+ (BOOL)generateRSAKeyPairWithKeySize:(int)keySize publicKey:(RSA **)publicKey privateKey:(RSA **)privateKey;
/*
 *rsaKey :rsa 密匙
 *isPubkey：是否是公匙 yes 是
 *return string  生成的是 pemkey  其中 pem公匙 传给服务器, pem私匙生成文件 用于签名 （不用再用KeyChain保存了，生成的文件在沙盒下只能本地访问）
 */
+ (NSString *)pemEncodedStringKey:(RSA *)rsaKey isPubkey:(BOOL)isPubkey;
/*
 *stringToSign :需要签名字符串
 *
 *return string 签名的数据 上传服务
 */
+(NSString *)rsaSignStringwithString:(NSString *)stringToSign;
@end

NS_ASSUME_NONNULL_END
