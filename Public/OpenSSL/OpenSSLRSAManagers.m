//
//  OpenSSLRSAManagers.m
//  Taodandan
//
//  Created by junchiNB on 2019/5/6.
//  Copyright © 2019年 junchiNB. All rights reserved.
//

#import "OpenSSLRSAManagers.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>
#import <openssl/ocsp.h>
#import <openssl/pem.h>
@implementation OpenSSLRSAManagers
//static OpenSSLRSAManagers *manager;
//+(OpenSSLRSAManagers *)shareManager {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if(manager==nil) {
//            manager =[[OpenSSLRSAManagers alloc]init];
//        }
//    });
//
//    return manager;
//}
//-(instancetype)init {
//    if(self=[super init]) {
//
//    }
//    return self;
//}
+ (BOOL)generateRSAKeyPairWithKeySize:(int)keySize publicKey:(RSA **)publicKey privateKey:(RSA **)privateKey {
    if (keySize == 512 || keySize == 1024 || keySize == 2048) {
        RSA *rsa = RSA_generate_key(keySize,RSA_F4,NULL,NULL);
        if (rsa) {
            *privateKey =    (rsa);
            *publicKey = RSAPublicKey_dup(rsa);
            if (publicKey && privateKey) {
                return YES;
                
            }
        }
    }
    return NO;
}
+ (NSString *)pemEncodedStringKey:(RSA *)rsaKey isPubkey:(BOOL)isPubkey{
    if (!rsaKey) {
        return nil;
    }
    BIO *bio = BIO_new(BIO_s_mem());
    
    if (isPubkey) {
        PEM_write_bio_RSA_PUBKEY(bio, rsaKey);
    }else{
        //此方法生成的是pkcs1格式的,IOS中需要pkcs8格式的,因此通过PEM_write_bio_PrivateKey 方法生成
        // PEM_write_bio_RSAPrivateKey(bio, rsaKey, NULL, NULL, 0, NULL, NULL);
        EVP_PKEY* key = NULL;
        key = EVP_PKEY_new();
        EVP_PKEY_assign_RSA(key, rsaKey);
        PEM_write_bio_PrivateKey(bio, key, NULL, NULL, 0, NULL, NULL);
    }
    
    BUF_MEM *bptr;
    BIO_get_mem_ptr(bio, &bptr);
    BIO_set_close(bio, BIO_NOCLOSE); /* So BIO_free() leaves BUF_MEM alone */
    BIO_free(bio);
    NSString *res = [NSString stringWithUTF8String:bptr->data];
    if(isPubkey) {
    }else {
        NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
        NSString*privPath = [documentsPath stringByAppendingPathComponent:@"privatekeys.pem"];
        //        BIO *outs;
        //        outs = BIO_new_file(privPath,"w");
        //        //这里生成的私钥没有加密，可选加密
        //        int ret = PEM_write_bio_RSAPrivateKey(outs, rsaKey, NULL, NULL, 0, NULL, NULL);
        //        BIO_flush(outs);
        //        BIO_free(outs);
        FILE* priWtire =NULL;
        priWtire =fopen([privPath UTF8String],"wb");
        if(priWtire ==NULL){
            NSLog(@"Read Filed.");
        }else{
            EVP_PKEY* key = NULL;
            key = EVP_PKEY_new();
            EVP_PKEY_assign_RSA(key, rsaKey);
            PEM_write_PKCS8PrivateKey(priWtire,key,NULL,NULL,0,0,NULL);
            fclose(priWtire);
        }
    }
    return res;
    //将PEM格式转换为base64格式
    //    return [self base64EncodedStringFromPEM:res];
}
+(NSString *)rsaSignStringwithString:(NSString *)stringToSign{
    
    NSString * _signErrorMessage = [[NSString alloc]init];
    
    NSMutableString *string = [[NSMutableString alloc]init];
    [string appendString:stringToSign];
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    size_t messageLength = strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    unsigned int sig_len = 0;
    //    NSString *myBandle=[[NSBundle mainBundle]pathForResource:@"privatekeys" ofType:@".pem"];
    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    NSString *mybandle=[NSString stringWithFormat:@"%@/privatekeys.pem",documentsPath];
    char *filePath = (char *)[mybandle cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char sha1[CC_SHA256_DIGEST_LENGTH];
    SHA256((unsigned char *)message, messageLength, sha1);
    int success = 0;
    BIO *bio_private = NULL;
    RSA *rsa_private = NULL;
    bio_private = BIO_new(BIO_s_file());
    BIO_read_filename(bio_private, filePath);
    rsa_private = PEM_read_bio_RSAPrivateKey(bio_private, NULL, NULL, "");
    if (rsa_private != nil) {
        if (1 == RSA_check_key(rsa_private)){
            int rsa_sign_valid = RSA_sign(NID_sha256, sha1, CC_SHA256_DIGEST_LENGTH, sig, &sig_len, rsa_private);
            if (1 == rsa_sign_valid){
                success = 1;
            }
        }
        BIO_free_all(bio_private);
    }else {
        
        NSLog(@"rsa_private read error : private key is NULL");
        
        _signErrorMessage = @"private key is NULL";
    }
    if(success == 1){
        //        Base64加密之前签名结果反转
        
        //
        //        for(int i = 0; i < sig_len ; i++)
        //
        //        {
        //
        //            finalsig[i] = sig[sig_len - i -1];
        //
        //        }
        NSData* signedHash = [NSData dataWithBytes:sig
                                            length:sig_len];
        NSString * signedString = [signedHash base64EncodedStringWithOptions:0];
        return signedString;
        
    }else return nil;
    
}
@end
