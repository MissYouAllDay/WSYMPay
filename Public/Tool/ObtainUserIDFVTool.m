//
//  ObtainUserIDFVTool.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ObtainUserIDFVTool.h"

@implementation ObtainUserIDFVTool
+ (NSString *)getIDFV

{
    
    //定义存入keychain中的账号 也就是一个标识 表示是某个app存储的内容   bundle id就好
    
    NSString * const KEY_USERNAME_PASSWORD = @"com.yinglian.WSYMPay.UserName";
    
    NSString * const KEY_PASSWORD = @"com.yinglian.WSYMPay.Password";
    
    
    //读取账号中保存的内容
    
    NSMutableDictionary *readUserPwd = (NSMutableDictionary *)[ObtainUserIDFVTool load:KEY_USERNAME_PASSWORD];
    
    //NSLog(@"keychain------><>%@",readUserPwd);
    
    
    
    if (!readUserPwd) {
        
        //如果为空 说明是第一次安装 做存储操作
        
        NSString *identifierStr = [[UIDevice currentDevice].identifierForVendor UUIDString];
        
        
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionaryWithObject:identifierStr forKey:KEY_PASSWORD];
        
        [ObtainUserIDFVTool save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
        
        return identifierStr;
        
    }else{
        
        return [readUserPwd objectForKey:KEY_PASSWORD];
        
    }
    
}



//储存

+ (void)save:(NSString *)service data:(id)data {
    
    //Get search dictionary
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Delete old item before add new item
    
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    //Add new object to search dictionary(Attention:the data format)
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    
}



+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            
            service, (__bridge id)kSecAttrService,
            
            service, (__bridge id)kSecAttrAccount,
            
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            
            nil];
    
}



//取出

+ (id)load:(NSString *)service {
    
    id ret = nil;
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Configure the search setting
    
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        
        @try {
            
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            
        } @catch (NSException *e) {
            
            NSLog(@"Unarchive of %@ failed: %@", service, e);
            
        } @finally {
            
        }
        
    }
    
    if (keyData)
        
        CFRelease(keyData);
    
    return ret;
    
}



//删除

+(void)delete:(NSString *)service {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
}

@end
